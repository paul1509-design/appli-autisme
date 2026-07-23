import SwiftUI
import AVFoundation
import UIKit

// Gardé pour compatibilité stub ContentLibrary
struct Question {
    let word: String
    let imageEmoji: String
    let instruction: String
    let choices: [String]
    let correctAnswer: String
    var syllableHint: String { "" }
}

@MainActor
class LearningSessionVM: ObservableObject {
    let child: ChildProfile
    let moduleType: ModuleType
    let language: AppLanguage

    @Published var exercises: [CurriculumExercise] = []
    @Published var currentIndex: Int = 0
    @Published var userInput: String = ""
    @Published var hasAnswered: Bool = false
    @Published var lastAnswerCorrect: Bool = false
    @Published var starsEarned: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var totalAnswers: Int = 0
    @Published var consecutiveErrors: Int = 0
    @Published var isSpeaking: Bool = false
    @Published var currentPromptLevel: PromptLevel = .independent
    @Published var showHint: Bool = false
    @Published var totalPromptsUsed: Int = 0

    enum PromptLevel: Int, CaseIterable {
        case independent = 0
        case gesture     = 1
        case partial     = 2
        case full        = 3

        var label: String {
            switch self {
            case .independent: return "Sans aide"
            case .gesture:     return "Indice visuel"
            case .partial:     return "Aide partielle"
            case .full:        return "Aide complète"
            }
        }

        var hintButtonLabel: String {
            switch self {
            case .independent: return "J'ai besoin d'un indice 💡"
            case .gesture:     return "Encore un indice 💡"
            case .partial:     return "Lire la réponse 🔊"
            case .full:        return ""
            }
        }
    }

    let leo: LeoPrimary
    private var correctStreak = 0
    private var sessionStartTime = Date()

    var currentExercise: CurriculumExercise? {
        guard currentIndex < exercises.count else { return nil }
        return exercises[currentIndex]
    }

    var progress: Double {
        guard !exercises.isEmpty else { return 0 }
        return Double(currentIndex) / Double(exercises.count)
    }

    var isSessionComplete: Bool { currentIndex >= exercises.count }

    init(child: ChildProfile, moduleType: ModuleType, language: AppLanguage = .french, leo: LeoPrimary? = nil) {
        self.child = child
        self.moduleType = moduleType
        self.language = language
        self.leo = leo ?? LeoPrimary()
    }

    func startSession() {
        sessionStartTime = Date()
        leo.configure(locale: language.voiceLocale)
        exercises = ContentLibrary.exercises(for: moduleType,
                                             level: child.schoolLevel,
                                             language: language,
                                             count: 8)
        currentIndex = 0
        currentPromptLevel = .independent
        let moduleName = moduleType.rawValue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.leo.speak(context: .moduleStart(module: moduleName, firstName: self.child.firstName))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.speakCurrentExercise()
        }
    }

    func requestHint() {
        guard let ex = currentExercise, !hasAnswered else { return }
        let nextLevel = PromptLevel(rawValue: currentPromptLevel.rawValue + 1) ?? .full
        currentPromptLevel = nextLevel
        totalPromptsUsed += 1
        showHint = true
        leo.speak(context: .hint)

        if nextLevel == .full {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.speak("La réponse est : \(ex.expectedAnswer)")
                self.userInput = ex.expectedAnswer
            }
        }
    }

    func hintText(for exercise: CurriculumExercise) -> String {
        switch currentPromptLevel {
        case .independent:
            return ""
        case .gesture:
            let first = String(exercise.expectedAnswer.prefix(1))
            return "Ça commence par : \(first)..."
        case .partial:
            let words = exercise.expectedAnswer.components(separatedBy: " ")
            let half = words.prefix(max(1, words.count / 2)).joined(separator: " ")
            return "Début : \(half)..."
        case .full:
            return "Réponse : \(exercise.expectedAnswer)"
        }
    }

    func speakCurrentExercise() {
        guard let ex = currentExercise else { return }
        speak(ex.characterSays)
    }

    func speak(_ text: String) {
        leo.speakText(text)
        let delay = Double(text.count) * 0.065 + 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isSpeaking = false
        }
    }

    func submitAnswer() {
        guard let ex = currentExercise, !hasAnswered else { return }
        totalAnswers += 1
        let isCorrect = evaluate(input: userInput, expected: ex.expectedAnswer)
        hasAnswered = true
        lastAnswerCorrect = isCorrect
        if isCorrect {
            correctAnswers += 1
            consecutiveErrors = 0
            correctStreak += 1
            starsEarned += 1
            leo.speak(context: .correct(streak: correctStreak))
        } else {
            consecutiveErrors += 1
            correctStreak = 0
            leo.speak(context: .wrong(attempt: consecutiveErrors))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                self.speak("La bonne réponse est : \(ex.expectedAnswer)")
            }
        }
    }

    func confirmRepeated() {
        guard !hasAnswered else { return }
        totalAnswers += 1
        correctAnswers += 1
        consecutiveErrors = 0
        correctStreak += 1
        starsEarned += 1
        hasAnswered = true
        lastAnswerCorrect = true
        leo.speak(context: .correct(streak: correctStreak))
    }

    func nextExercise() {
        userInput = ""
        hasAnswered = false
        lastAnswerCorrect = false
        currentPromptLevel = .independent
        showHint = false
        currentIndex += 1
        if !isSessionComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.speakCurrentExercise()
            }
        }
    }

    func saveSession(dataStore: DataStore) {
        var session = LearningSession(moduleType: moduleType)
        session.durationSeconds = Int(Date().timeIntervalSince(sessionStartTime))
        session.starsEarned = starsEarned
        session.wordsStudied = exercises.count
        session.correctAnswers = correctAnswers
        session.totalAnswers = totalAnswers
        session.completed = isSessionComplete
        let promptPenalty = min(totalPromptsUsed, starsEarned)
        session.starsEarned = max(0, starsEarned - promptPenalty / 4)

        var updatedChild = child
        updatedChild.sessions.append(session)
        updatedChild.totalStars += starsEarned
        updatedChild.lastActiveAt = Date()
        dataStore.updateChild(updatedChild)

        leo.speak(context: .sessionEnd(correct: correctAnswers, total: totalAnswers, firstName: child.firstName))

        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        ABAReviewService.checkAndRequestReview(totalSessions: updatedChild.sessions.count, scene: scene)
    }

    private func evaluate(input: String, expected: String) -> Bool {
        let a = normalize(input)
        let b = normalize(expected)
        if a == b { return true }
        let wa = Set(a.components(separatedBy: " ").filter { !$0.isEmpty })
        let wb = Set(b.components(separatedBy: " ").filter { !$0.isEmpty })
        guard !wb.isEmpty else { return false }
        return Double(wa.intersection(wb).count) / Double(wb.count) >= 0.7
    }

    private func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
         .lowercased()
         .folding(options: .diacriticInsensitive, locale: .current)
    }
}
