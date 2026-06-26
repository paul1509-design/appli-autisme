import SwiftUI
import SwiftData
import Combine

struct Question {
    let word: String
    let imageEmoji: String
    let instruction: String
    let choices: [String]
    let correctAnswer: String

    var syllableHint: String {
        guard !correctAnswer.isEmpty else { return "" }
        let syllables = correctAnswer.components(separatedBy: "-")
        return syllables.first ?? String(correctAnswer.prefix(2))
    }
}

@MainActor
class LearningSessionVM: ObservableObject {
    let child: ChildProfile
    let moduleType: ModuleType

    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: String?
    @Published var hasAnswered: Bool = false
    @Published var lastAnswerCorrect: Bool = false
    @Published var starsEarned: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var totalAnswers: Int = 0
    @Published var consecutiveErrors: Int = 0
    @Published var showSyllableHint: Bool = false
    @Published var shouldShowTeacherHint: Bool = false
    @Published var teacherMessage: String = ""

    // Timer
    @Published var timerActive: Bool = true
    @Published var timerProgress: Double = 1.0
    @Published var secondsLeft: Int = 20

    private var timerCancellable: AnyCancellable?
    private var sessionStartTime: Date = Date()
    private let sessionDurationSeconds = 20  // par question

    var currentQuestion: Question? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }

    var syllableHint: String? {
        currentQuestion?.syllableHint
    }

    var isSessionComplete: Bool {
        currentIndex >= questions.count - 1 && hasAnswered
    }

    init(child: ChildProfile, moduleType: ModuleType) {
        self.child = child
        self.moduleType = moduleType
    }

    func startSession() {
        sessionStartTime = Date()
        questions = ContentLibrary.questions(
            for: moduleType,
            level: child.schoolLevel,
            count: 8
        )
        startTimer()
    }

    private func startTimer() {
        secondsLeft = sessionDurationSeconds
        timerProgress = 1.0
        timerCancellable?.cancel()

        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.secondsLeft > 0 && !self.hasAnswered {
                    self.secondsLeft -= 1
                    self.timerProgress = Double(self.secondsLeft) /
                                         Double(self.sessionDurationSeconds)
                } else if self.secondsLeft == 0 && !self.hasAnswered {
                    // Temps écoulé → aide syllabique automatique
                    self.showSyllableHint = true
                    self.timerActive = false
                }
            }
    }

    func submitAnswer(_ answer: String) {
        guard !hasAnswered, let question = currentQuestion else { return }
        timerCancellable?.cancel()

        selectedAnswer = answer
        hasAnswered = true
        totalAnswers += 1

        let isCorrect = answer == question.correctAnswer
        lastAnswerCorrect = isCorrect

        if isCorrect {
            consecutiveErrors = 0
            starsEarned += bonusStars
            correctAnswers += 1
            shouldShowTeacherHint = consecutiveErrors == 0 && totalAnswers % 3 == 0
            teacherMessage = positiveMessages.randomElement() ?? "Bravo !"
        } else {
            consecutiveErrors += 1
            shouldShowTeacherHint = consecutiveErrors >= 2
            teacherMessage = encouragementMessages.randomElement() ?? "Continue !"
            if consecutiveErrors >= 2 {
                showSyllableHint = true
            }
        }
    }

    private var bonusStars: Int {
        // Plus d'étoiles si réponse rapide
        if secondsLeft > 15 { return 3 }
        if secondsLeft > 8  { return 2 }
        return 1
    }

    func nextQuestion() {
        withAnimation(.spring()) {
            currentIndex += 1
            selectedAnswer = nil
            hasAnswered = false
            showSyllableHint = false
            shouldShowTeacherHint = false
        }
        if currentIndex < questions.count {
            startTimer()
        }
    }

    func saveSession(modelContext: ModelContext) {
        let session = LearningSession(moduleType: moduleType)
        session.durationSeconds = Int(Date().timeIntervalSince(sessionStartTime))
        session.starsEarned = starsEarned
        session.wordsStudied = questions.count
        session.correctAnswers = correctAnswers
        session.totalAnswers = totalAnswers
        session.completed = isSessionComplete
        child.sessions.append(session)
        child.totalStars += starsEarned
        child.lastActiveAt = Date()
        try? modelContext.save()
    }

    // MARK: - Messages professeur
    private let positiveMessages = [
        "Excellent ! Tu apprends tellement vite !",
        "Bravo ! C'est exactement ça !",
        "Super ! Tu es vraiment fort(e) !",
        "Parfait ! Continue comme ça !",
        "Wow, tu te souviens bien !"
    ]

    private let encouragementMessages = [
        "Presque ! Regarde bien l'indice.",
        "Ce n'est pas grave, on réessaie ensemble.",
        "Tu peux y arriver ! Regarde le mot encore une fois.",
        "Chaque erreur nous aide à apprendre !",
        "Ne t'inquiète pas, tu vas y arriver !"
    ]
}
