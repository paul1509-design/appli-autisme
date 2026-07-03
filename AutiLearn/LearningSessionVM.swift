import SwiftUI
import SwiftData
import AVFoundation

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

    // Hiérarchie de prompts ABA : independent → gesture → partial → full
    enum PromptLevel: Int, CaseIterable {
        case independent = 0  // aucune aide
        case gesture     = 1  // indice visuel (emoji / 1ère lettre)
        case partial     = 2  // début de la réponse
        case full        = 3  // réponse complète lue à voix haute

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

    private let speech = AVSpeechSynthesizer()
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

    init(child: ChildProfile, moduleType: ModuleType, language: AppLanguage = .french) {
        self.child = child
        self.moduleType = moduleType
        self.language = language
    }

    func startSession() {
        sessionStartTime = Date()
        exercises = ContentLibrary.exercises(for: moduleType,
                                             level: child.schoolLevel,
                                             language: language,
                                             count: 8)
        currentIndex = 0
        currentPromptLevel = .independent
        speakCurrentExercise()
    }

    // MARK: - Hiérarchie de prompts ABA
    func requestHint() {
        guard let ex = currentExercise, !hasAnswered else { return }
        let nextLevel = PromptLevel(rawValue: currentPromptLevel.rawValue + 1) ?? .full
        currentPromptLevel = nextLevel
        totalPromptsUsed += 1
        showHint = true

        if nextLevel == .full {
            // Aide complète : lire la réponse à voix haute
            speak("La réponse est : \(ex.expectedAnswer)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.userInput = ex.expectedAnswer
            }
        }
    }

    func hintText(for exercise: CurriculumExercise) -> String {
        switch currentPromptLevel {
        case .independent:
            return ""
        case .gesture:
            // Première lettre
            let first = String(exercise.expectedAnswer.prefix(1))
            return "Ça commence par : \(first)..."
        case .partial:
            // Moitié de la réponse
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
        speech.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language.voiceLocale)
        utterance.rate = 0.42
        utterance.pitchMultiplier = 1.1
        isSpeaking = true
        speech.speak(utterance)
        let delay = Double(text.count) * 0.065 + 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isSpeaking = false
        }
    }

    // Validation d'une réponse écrite
    func submitAnswer() {
        guard let ex = currentExercise, !hasAnswered else { return }
        totalAnswers += 1
        let isCorrect = evaluate(input: userInput, expected: ex.expectedAnswer)
        hasAnswered = true
        lastAnswerCorrect = isCorrect
        if isCorrect {
            correctAnswers += 1
            consecutiveErrors = 0
            starsEarned += 1
            speak("Bravo ! C'est exact !")
        } else {
            consecutiveErrors += 1
            speak("La bonne réponse est : \(ex.expectedAnswer)")
        }
    }

    // Auto-validation pour le mode "J'ai répété à voix haute"
    func confirmRepeated() {
        guard !hasAnswered else { return }
        totalAnswers += 1
        correctAnswers += 1
        consecutiveErrors = 0
        starsEarned += 1
        hasAnswered = true
        lastAnswerCorrect = true
        speak("Super ! Bien dit !")
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

    func saveSession(modelContext: ModelContext) {
        let session = LearningSession(moduleType: moduleType)
        session.durationSeconds = Int(Date().timeIntervalSince(sessionStartTime))
        session.starsEarned = starsEarned
        session.wordsStudied = exercises.count
        session.correctAnswers = correctAnswers
        session.totalAnswers = totalAnswers
        session.completed = isSessionComplete
        // Pénalité légère si beaucoup de prompts utilisés (ABA : encourager l'indépendance)
        let promptPenalty = min(totalPromptsUsed, starsEarned)
        session.starsEarned = max(0, starsEarned - promptPenalty / 4)
        child.sessions.append(session)
        child.totalStars += starsEarned
        child.lastActiveAt = Date()
        try? modelContext.save()
    }

    private func evaluate(input: String, expected: String) -> Bool {
        let a = normalize(input)
        let b = normalize(expected)
        if a == b { return true }
        // Tolérance 70% des mots
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
