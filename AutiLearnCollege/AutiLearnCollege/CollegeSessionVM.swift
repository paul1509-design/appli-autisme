import SwiftUI
import SwiftData
import AVFoundation
import UIKit

@MainActor
class CollegeSessionVM: ObservableObject {
    let student: CollegeProfile
    let subject: CollegeSubject

    @Published var exercises: [CollegeExercise] = []
    @Published var currentIndex: Int = 0
    @Published var selectedChoice: String? = nil
    @Published var userInput: String = ""
    @Published var hasAnswered: Bool = false
    @Published var lastAnswerCorrect: Bool = false
    @Published var starsEarned: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var totalAnswers: Int = 0
    @Published var isSpeaking: Bool = false
    @Published var promptLevel: CollegePromptLevel = .independent
    @Published var showHint: Bool = false
    @Published var totalPromptsUsed: Int = 0

    let leo = LeoCompanion()
    private var correctStreak = 0

    private let synthesizer = AVSpeechSynthesizer()
    private let startDate = Date()

    init(student: CollegeProfile, subject: CollegeSubject) {
        self.student = student
        self.subject = subject
    }

    var currentExercise: CollegeExercise? {
        guard currentIndex < exercises.count else { return nil }
        return exercises[currentIndex]
    }

    var progress: Double {
        guard !exercises.isEmpty else { return 0 }
        return Double(currentIndex) / Double(exercises.count)
    }

    var isSessionComplete: Bool { currentIndex >= exercises.count }

    func startSession() {
        leo.configure(language: student.language)
        exercises = CollegeContentLibrary.exercises(for: subject, level: student.level, language: student.language, count: 8)
        // Léo accueille l'élève
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.leo.speak(context: .sessionStart(
                subject: self.subject.displayName(for: self.student.language),
                firstName: self.student.firstName))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            if let first = self.exercises.first { self.speak(first.question) }
        }
    }

    func submitChoice(_ choice: String) {
        guard let ex = currentExercise, !hasAnswered else { return }
        selectedChoice = choice
        let correct = choice.trimmingCharacters(in: .whitespaces).lowercased()
                    == ex.correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()
        recordAnswer(correct: correct, ex: ex)
    }

    func submitShortAnswer() {
        guard let ex = currentExercise, !hasAnswered else { return }
        let input = userInput.trimmingCharacters(in: .whitespaces).lowercased()
        let expected = ex.correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()
        let correct = input == expected || expected.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }.contains(input)
        recordAnswer(correct: correct, ex: ex)
    }

    func confirmOral() {
        guard let ex = currentExercise, !hasAnswered else { return }
        recordAnswer(correct: true, ex: ex)
    }

    private func recordAnswer(correct: Bool, ex: CollegeExercise) {
        hasAnswered = true
        lastAnswerCorrect = correct
        totalAnswers += 1
        if correct {
            correctAnswers += 1
            correctStreak += 1
            let stars = max(1, ex.difficulty - totalPromptsUsed)
            starsEarned += stars
        } else {
            correctStreak = 0
        }

        // Léo réagit à voix haute
        if correct {
            leo.speak(context: .correctAnswer(streak: correctStreak))
        } else {
            let attempt = totalAnswers - correctAnswers
            leo.speak(context: .wrongAnswer(attempt: attempt))
        }

        // La synthèse de l'exercice parle après Léo (délai 2s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            if !correct { self.speak(ex.explanation) }
        }

        // Mise à jour progression par exercice (spacing effect)
        let key = ex.subject.rawValue + "|" + ex.question.prefix(60)
        if let prog = student.exerciseProgresses.first(where: { $0.exerciseKey == key }) {
            prog.record(correct: correct)
        } else {
            let prog = CollegeExerciseProgress(key: key, subject: ex.subject.rawValue)
            prog.record(correct: correct)
            student.exerciseProgresses.append(prog)
        }
    }

    func requestHint() {
        guard let ex = currentExercise,
              let next = CollegePromptLevel(rawValue: promptLevel.rawValue + 1) else { return }
        promptLevel = next
        totalPromptsUsed += 1
        showHint = true
        leo.speak(context: .hintRequested)
        if next == .full {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.speak(ex.correctAnswer) }
        }
    }

    func hintText(for ex: CollegeExercise) -> String {
        switch promptLevel {
        case .independent: return ""
        case .hint:
            return "Indice : " + String(ex.question.prefix(40)) + "..."
        case .partial:
            let words = ex.correctAnswer.split(separator: " ")
            let half = Int(ceil(Double(words.count) / 2.0))
            return words.prefix(half).joined(separator: " ") + "..."
        case .full:
            return ex.correctAnswer
        }
    }

    func nextExercise() {
        currentIndex += 1
        hasAnswered = false
        selectedChoice = nil
        userInput = ""
        promptLevel = .independent
        showHint = false
        if let ex = currentExercise { speak(ex.question) }
    }

    func saveSession(modelContext: ModelContext) {
        let duration = Int(Date().timeIntervalSince(startDate))
        let session = CollegeSession(subject: subject, stars: starsEarned,
                                     correct: correctAnswers, total: totalAnswers,
                                     duration: duration)
        student.sessions.append(session)
        student.totalStars += starsEarned

        let today = Calendar.current.startOfDay(for: Date())
        if let last = student.lastSessionDate,
           Calendar.current.isDate(last, inSameDayAs: today) {
            // même jour, streak inchangé
        } else {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            if let last = student.lastSessionDate,
               Calendar.current.isDate(last, inSameDayAs: yesterday) {
                student.currentStreak += 1
            } else {
                student.currentStreak = 1
            }
        }
        student.lastSessionDate = Date()
        try? modelContext.save()

        // Léo félicite en fin de session
        leo.speak(context: .sessionEnd(correct: correctAnswers, total: totalAnswers, firstName: student.firstName))

        // Demande d'avis App Store après la 3ème session
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        CollegeReviewService.checkAndRequestReview(totalSessions: student.sessions.count, scene: scene)
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: student.language.voiceLocale)
        utterance.rate = 0.45
        isSpeaking = true
        synthesizer.speak(utterance)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.count) * 0.065 + 0.5) {
            self.isSpeaking = false
        }
    }
}
