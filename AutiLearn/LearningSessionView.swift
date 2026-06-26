import SwiftUI
import AVFoundation

struct LearningSessionView: View {
    let child: ChildProfile
    let moduleType: ModuleType

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm: LearningSessionVM
    @State private var showTeacherHint = false
    @State private var showReward = false
    @State private var sessionComplete = false

    init(child: ChildProfile, moduleType: ModuleType) {
        self.child = child
        self.moduleType = moduleType
        _vm = StateObject(wrappedValue: LearningSessionVM(
            child: child, moduleType: moduleType))
    }

    var body: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()

            if sessionComplete {
                SessionCompleteView(
                    starsEarned: vm.starsEarned,
                    correctAnswers: vm.correctAnswers,
                    total: vm.totalAnswers,
                    onContinue: { dismiss() }
                )
            } else {
                VStack(spacing: 0) {
                    // Header session
                    SessionHeader(
                        moduleType: moduleType,
                        progress: vm.progress,
                        starsEarned: vm.starsEarned,
                        onClose: { dismiss() }
                    )

                    ScrollView {
                        VStack(spacing: 24) {
                            // Timer visuel
                            if vm.timerActive {
                                CircularTimer(
                                    progress: vm.timerProgress,
                                    secondsLeft: vm.secondsLeft
                                )
                                .padding(.top, 16)
                            }

                            // Carte question / mot
                            if let question = vm.currentQuestion {
                                QuestionCard(question: question,
                                             childName: child.firstName)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing),
                                        removal: .move(edge: .leading)
                                    ))
                            }

                            // Réponses
                            if let question = vm.currentQuestion {
                                AnswerGrid(
                                    choices: question.choices,
                                    selectedAnswer: vm.selectedAnswer,
                                    correctAnswer: question.correctAnswer,
                                    hasAnswered: vm.hasAnswered,
                                    onSelect: { answer in
                                        vm.submitAnswer(answer)
                                        if vm.shouldShowTeacherHint {
                                            withAnimation { showTeacherHint = true }
                                        }
                                    }
                                )
                            }

                            // Aide syllabique (si 2e erreur)
                            if vm.showSyllableHint, let hint = vm.syllableHint {
                                SyllableHintBanner(hint: hint)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }

                            // Bouton suivant
                            if vm.hasAnswered {
                                NextButton(
                                    isCorrect: vm.lastAnswerCorrect,
                                    onNext: {
                                        showTeacherHint = false
                                        if vm.isSessionComplete {
                                            withAnimation { sessionComplete = true }
                                        } else {
                                            vm.nextQuestion()
                                        }
                                    }
                                )
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                        .animation(.spring(), value: vm.hasAnswered)
                        .animation(.spring(), value: vm.showSyllableHint)
                    }
                }

                // Overlay professeur ABA
                if showTeacherHint {
                    TeacherOverlay(
                        teacherName: child.teacherAvatarName,
                        message: vm.teacherMessage,
                        isCorrect: vm.lastAnswerCorrect,
                        onDismiss: { showTeacherHint = false }
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { vm.startSession() }
        .onDisappear { vm.saveSession(modelContext: modelContext) }
    }
}

// MARK: - Header Session
struct SessionHeader: View {
    let moduleType: ModuleType
    let progress: Double
    let starsEarned: Int
    let onClose: () -> Void

    var moduleName: String {
        switch moduleType {
        case .vocabulary: return "Vocabulaire"
        case .reading:    return "Lecture"
        case .numbers:    return "Chiffres"
        case .diction:    return "Diction"
        case .story:      return "Histoire"
        case .karaoke:    return "Karaoké"
        case .drawing:    return "Dessin"
        default:          return "Apprentissage"
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("textSecondary"))
                        .frame(width: 36, height: 36)
                        .background(Color("cardBackground"))
                        .cornerRadius(10)
                }

                Spacer()

                Text(moduleName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("textPrimary"))

                Spacer()

                // Étoiles gagnées
                HStack(spacing: 4) {
                    Text("⭐️")
                        .font(.system(size: 14))
                    Text("\(starsEarned)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("accentOrange"))
                }
            }

            // Barre de progression
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("borderLight"))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("accentPurple"))
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(Color("backgroundSoft"))
    }
}

// MARK: - Timer circulaire
struct CircularTimer: View {
    let progress: Double  // 0..1 (1 = temps plein)
    let secondsLeft: Int

    var timerColor: Color {
        if progress > 0.5 { return Color("accentGreen") }
        if progress > 0.25 { return Color("accentOrange") }
        return Color("accentRed")
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("borderLight"), lineWidth: 5)
                .frame(width: 60, height: 60)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(timerColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
            Text("\(secondsLeft)")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textPrimary"))
        }
    }
}

// MARK: - Carte question
struct QuestionCard: View {
    let question: Question
    let childName: String
    @StateObject private var speechService = SpeechService()

    var body: some View {
        VStack(spacing: 16) {
            // Instruction
            Text(question.instruction)
                .font(.system(size: 16))
                .foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center)

            // Mot / image principale
            VStack(spacing: 12) {
                if !question.imageEmoji.isEmpty {
                    Text(question.imageEmoji)
                        .font(.system(size: 64))
                }
                Text(question.word)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .multilineTextAlignment(.center)

                // Bouton écouter
                Button {
                    speechService.speak(question.word)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Écouter")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("accentPurple"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color("accentPurple").opacity(0.08))
                    .cornerRadius(20)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("cardBackground"))
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("borderLight"), lineWidth: 0.5))
            )
        }
    }
}

// MARK: - Grille de réponses
struct AnswerGrid: View {
    let choices: [String]
    let selectedAnswer: String?
    let correctAnswer: String
    let hasAnswered: Bool
    let onSelect: (String) -> Void

    var body: some View {
        VStack(spacing: 10) {
            ForEach(choices, id: \.self) { choice in
                AnswerButton(
                    text: choice,
                    state: buttonState(for: choice),
                    onTap: {
                        if !hasAnswered { onSelect(choice) }
                    }
                )
            }
        }
    }

    private func buttonState(for choice: String) -> AnswerButtonState {
        guard hasAnswered else { return .idle }
        if choice == correctAnswer { return .correct }
        if choice == selectedAnswer { return .incorrect }
        return .idle
    }
}

enum AnswerButtonState {
    case idle, correct, incorrect
}

struct AnswerButton: View {
    let text: String
    let state: AnswerButtonState
    let onTap: () -> Void

    var backgroundColor: Color {
        switch state {
        case .idle:      return Color("cardBackground")
        case .correct:   return Color("accentGreen").opacity(0.12)
        case .incorrect: return Color("accentRed").opacity(0.12)
        }
    }

    var borderColor: Color {
        switch state {
        case .idle:      return Color("borderLight")
        case .correct:   return Color("accentGreen")
        case .incorrect: return Color("accentRed")
        }
    }

    var icon: String? {
        switch state {
        case .correct:   return "checkmark.circle.fill"
        case .incorrect: return "xmark.circle.fill"
        case .idle:      return nil
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(text)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Spacer()
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(state == .correct ?
                                         Color("accentGreen") : Color("accentRed"))
                        .font(.system(size: 20))
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(backgroundColor)
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(borderColor,
                                lineWidth: state == .idle ? 0.5 : 1.5))
            )
        }
        .disabled(state != .idle)
        .animation(.spring(response: 0.3), value: state)
    }
}

// MARK: - Aide syllabique
struct SyllableHintBanner: View {
    let hint: String

    var body: some View {
        HStack(spacing: 10) {
            Text("💡")
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 2) {
                Text("Indice")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("accentOrange"))
                Text("Le mot commence par : \(hint)...")
                    .font(.system(size: 15))
                    .foregroundColor(Color("textPrimary"))
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("accentOrange").opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("accentOrange").opacity(0.3), lineWidth: 0.5))
        )
    }
}

// MARK: - Bouton suivant
struct NextButton: View {
    let isCorrect: Bool
    let onNext: () -> Void

    var body: some View {
        Button(action: onNext) {
            HStack(spacing: 8) {
                Text(isCorrect ? "Super ! Continuer" : "Continuer")
                    .font(.system(size: 17, weight: .medium))
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(isCorrect ? Color("accentGreen") : Color("accentPurple"))
            .cornerRadius(14)
        }
    }
}

// MARK: - Overlay professeur ABA
struct TeacherOverlay: View {
    let teacherName: String
    let message: String
    let isCorrect: Bool
    let onDismiss: () -> Void

    var teacherEmoji: String {
        let map = ["teacher_luna": "👩‍🏫", "teacher_leo": "👨‍🏫",
                   "teacher_maya": "🧑‍🎓", "teacher_sam": "🧑‍🏫"]
        return map[teacherName] ?? "👩‍🏫"
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 16) {
                Text(teacherEmoji)
                    .font(.system(size: 56))

                Text(message)
                    .font(.system(size: 17))
                    .foregroundColor(Color("textPrimary"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Button(action: onDismiss) {
                    Text("OK !")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(isCorrect ? Color("accentGreen") : Color("accentPurple"))
                        .cornerRadius(12)
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("cardBackground"))
            )
            .padding(.horizontal, 40)
            .shadow(color: .black.opacity(0.1), radius: 20)
        }
        .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Session terminée
struct SessionCompleteView: View {
    let starsEarned: Int
    let correctAnswers: Int
    let total: Int
    let onContinue: () -> Void

    var successRate: Int {
        guard total > 0 else { return 0 }
        return Int(Double(correctAnswers) / Double(total) * 100)
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text(successRate >= 80 ? "🎉" : "💪")
                .font(.system(size: 80))
                .scaleEffect(1.0)

            Text(successRate >= 80 ? "Excellent !" : "Bien joué !")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            // Stats
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("⭐️ \(starsEarned)")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("accentOrange"))
                    Text("étoiles")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                VStack(spacing: 4) {
                    Text("\(successRate)%")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("accentGreen"))
                    Text("réussite")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                VStack(spacing: 4) {
                    Text("\(correctAnswers)/\(total)")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("accentPurple"))
                    Text("bonnes réponses")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("cardBackground"))
            )

            Spacer()

            Button(action: onContinue) {
                Text("Retour à l'accueil")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color("accentPurple"))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color("backgroundSoft").ignoresSafeArea())
    }
}
