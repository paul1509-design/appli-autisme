import SwiftUI
import StoreKit

// MARK: - Service demande d'avis App Store
struct CollegeReviewService {
    private static let sessionsForReviewKey = "collegeSessionsAtReview"
    private static let reviewRequestedKey   = "collegeReviewRequested"
    private static let bonusUnlockedKey     = "collegeBonusUnlocked"

    // Appeler après chaque session sauvegardée
    static func checkAndRequestReview(totalSessions: Int, scene: UIWindowScene?) {
        // Déclencher après la 3ème session, une seule fois
        guard !UserDefaults.standard.bool(forKey: reviewRequestedKey) else { return }
        guard totalSessions >= 3 else { return }

        UserDefaults.standard.set(true, forKey: reviewRequestedKey)
        if let scene { SKStoreReviewController.requestReview(in: scene) }
    }

    static var isBonusUnlocked: Bool {
        get { UserDefaults.standard.bool(forKey: bonusUnlockedKey) }
        set { UserDefaults.standard.set(newValue, forKey: bonusUnlockedKey) }
    }
}

// MARK: - Modal déblocage exercice bonus
struct CollegeBonusUnlockView: View {
    @Binding var isPresented: Bool
    let studentName: String
    @State private var bonusUnlocked = CollegeReviewService.isBonusUnlocked
    @State private var countdown: Int = 10
    @State private var timerStarted = false
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("🎁").font(.system(size: 56)).padding(.top, 36)
                Text("Exercice bonus spécial")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color("textPrimary"))
                Text("Débloquez le jeu des Champions pour \(studentName) !")
                    .font(.system(size: 14))
                    .foregroundColor(Color("textSecondary"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 28)

            // Explication
            VStack(alignment: .leading, spacing: 10) {
                BonusFeatureRow(emoji: "🏆", text: "Quiz chronométré ultra-gamifié — 20 questions en 60 secondes")
                BonusFeatureRow(emoji: "🎯", text: "Toutes matières mélangées — révision express")
                BonusFeatureRow(emoji: "⭐️", text: "Multiplicateur x3 si réponse rapide")
                BonusFeatureRow(emoji: "🔓", text: "Débloqué définitivement une fois offert")
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 14)
                .fill(Color("accentPurple").opacity(0.06)))
            .padding(.horizontal, 24).padding(.top, 20)

            if bonusUnlocked {
                // Déjà débloqué
                VStack(spacing: 10) {
                    Text("✅ Exercice bonus déjà débloqué !").font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentGreen"))
                    Button("Jouer maintenant") { isPresented = false }
                        .font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .background(Color("accentGreen")).cornerRadius(16)
                }
                .padding(.horizontal, 24).padding(.top, 24)
            } else {
                // Demande d'avis
                VStack(spacing: 14) {
                    Text("Comment débloquer :")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color("textSecondary"))
                    Text("Laissez un avis ⭐️⭐️⭐️⭐️⭐️ sur l'App Store\n(10 secondes suffit !)")
                        .font(.system(size: 14)).foregroundColor(Color("textPrimary"))
                        .multilineTextAlignment(.center).lineSpacing(4)

                    if !timerStarted {
                        Button {
                            requestReviewAndStartTimer()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text("Laisser un avis maintenant")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 52)
                            .background(LinearGradient(colors: [Color("accentPurple"), Color("accentBlue")],
                                                       startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(16)
                        }
                    } else if countdown > 0 {
                        VStack(spacing: 8) {
                            ProgressView(value: Double(10 - countdown), total: 10)
                                .tint(Color("accentPurple")).padding(.horizontal, 4)
                            Text("Déblocage dans \(countdown)s…")
                                .font(.system(size: 13)).foregroundColor(Color("textSecondary"))
                        }
                    } else {
                        VStack(spacing: 10) {
                            Text("🎉 Merci ! Exercice bonus débloqué !").font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("accentGreen"))
                            Button("Jouer maintenant") {
                                CollegeReviewService.isBonusUnlocked = true
                                bonusUnlocked = true
                                isPresented = false
                            }
                            .font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Color("accentGreen")).cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 24).padding(.top, 20)
            }

            Button("Plus tard") { isPresented = false }
                .font(.system(size: 14)).foregroundColor(Color("textSecondary"))
                .padding(.top, 16).padding(.bottom, 32)
        }
        .background(Color("backgroundSoft"))
        .presentationDetents([.medium, .large])
        .onDisappear { timer?.invalidate() }
    }

    private func requestReviewAndStartTimer() {
        // Demande d'avis StoreKit natif
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
        timerStarted = true
        countdown = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if countdown > 0 {
                countdown -= 1
            } else {
                t.invalidate()
            }
        }
    }
}

private struct BonusFeatureRow: View {
    let emoji: String; let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(emoji).font(.system(size: 16))
            Text(text).font(.system(size: 13)).foregroundColor(Color("textPrimary")).lineSpacing(3)
        }
    }
}

// MARK: - Exercice bonus "Champions Quiz"
struct CollegeChampionsQuizView: View {
    let student: CollegeProfile
    @Environment(\.dismiss) private var dismiss
    @State private var exercises: [CollegeExercise] = []
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var timeLeft: Double = 60
    @State private var isFinished = false
    @State private var timer: Timer? = nil
    @State private var lastAnswerCorrect: Bool? = nil

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("accentPurple"), Color("accentBlue").opacity(0.8)],
                           startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()

            if isFinished || exercises.isEmpty {
                quizResultView
            } else {
                quizView
            }
        }
        .onAppear { setupQuiz() }
        .onDisappear { timer?.invalidate() }
    }

    private var quizView: some View {
        let ex = exercises[currentIndex]
        return VStack(spacing: 0) {
            // Timer + score
            HStack {
                Text("⏱️ \(Int(timeLeft))s")
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                Spacer()
                Text("⭐️ \(score)")
                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.yellow)
                Spacer()
                Text("\(currentIndex+1)/\(exercises.count)")
                    .font(.system(size: 14)).foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 24).padding(.top, 16)

            ProgressView(value: timeLeft, total: 60)
                .tint(.yellow).padding(.horizontal, 24).padding(.top, 8)

            Spacer()

            Text(ex.emoji).font(.system(size: 56)).padding(.bottom, 8)

            Text(ex.question)
                .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                .multilineTextAlignment(.center).lineSpacing(4)
                .padding(.horizontal, 28)

            Spacer()

            VStack(spacing: 10) {
                ForEach(ex.choices, id: \.self) { choice in
                    Button {
                        answerTapped(choice: choice, ex: ex)
                    } label: {
                        Text(choice)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("accentPurple"))
                            .frame(maxWidth: .infinity).frame(height: 48)
                            .background(.white).cornerRadius(14)
                    }
                }
            }
            .padding(.horizontal, 24).padding(.bottom, 32)
        }
    }

    private var quizResultView: some View {
        VStack(spacing: 24) {
            Text(score >= 15 ? "🏆" : score >= 8 ? "🎉" : "💪")
                .font(.system(size: 72))
            Text(score >= 15 ? "Champion !" : score >= 8 ? "Excellent !" : "Bonne tentative !")
                .font(.system(size: 26, weight: .bold)).foregroundColor(.white)
            Text("Score : \(score) points")
                .font(.system(size: 20)).foregroundColor(.white.opacity(0.9))
            Button("Retour") { dismiss() }
                .font(.system(size: 16, weight: .medium)).foregroundColor(Color("accentPurple"))
                .frame(width: 160, height: 48).background(.white).cornerRadius(14)
        }
    }

    private func setupQuiz() {
        var pool: [CollegeExercise] = []
        for subject in CollegeSubject.allCases {
            let exs = CollegeContentLibrary.exercises(for: subject, level: student.level,
                                                      language: student.language, count: 4)
            pool += exs.filter { !$0.choices.isEmpty }
        }
        exercises = Array(pool.shuffled().prefix(20))
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            if timeLeft > 0 {
                timeLeft -= 0.1
            } else {
                t.invalidate()
                isFinished = true
            }
        }
    }

    private func answerTapped(choice: String, ex: CollegeExercise) {
        let correct = choice.trimmingCharacters(in: .whitespaces).lowercased()
                   == ex.correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()
        if correct {
            // Bonus temps restant
            let timeBonus = Int(timeLeft / 10)
            score += ex.difficulty + timeBonus
        }
        if currentIndex < exercises.count - 1 {
            currentIndex += 1
        } else {
            isFinished = true
            timer?.invalidate()
        }
    }
}
