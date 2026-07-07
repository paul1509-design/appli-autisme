import SwiftUI
import AVFoundation

struct LearningSessionView: View {
    let child: ChildProfile
    let moduleType: ModuleType
    let language: AppLanguage

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm: LearningSessionVM
    @State private var sessionComplete = false
    @State private var timeRemaining: Int = 30
    @State private var timerActive = false
    let exerciseTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(child: ChildProfile, moduleType: ModuleType, language: AppLanguage = .french, leo: LeoPrimary? = nil) {
        self.child = child
        self.moduleType = moduleType
        self.language = language
        _vm = StateObject(wrappedValue: LearningSessionVM(child: child, moduleType: moduleType, language: language, leo: leo))
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
            } else if let exercise = vm.currentExercise {
                VStack(spacing: 0) {
                    SessionProgressBar(value: vm.progress)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    HStack {
                        HStack(spacing: 4) {
                            Text("⭐️")
                            Text("\(vm.starsEarned)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("textPrimary"))
                        }
                        Spacer()
                        CountdownTimer(timeRemaining: timeRemaining, total: 30)
                        Spacer()
                        Button {
                            vm.saveSession(modelContext: modelContext)
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(Color("textSecondary"))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    exerciseContent(exercise: exercise)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            vm.startSession()
            resetTimer()
        }
        .onDisappear { vm.saveSession(modelContext: modelContext) }
        .onReceive(exerciseTimer) { _ in
            guard timerActive && !vm.hasAnswered else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                vm.requestHint()
            }
        }
        .onChange(of: vm.currentIndex) { _, _ in
            resetTimer()
            if vm.isSessionComplete {
                vm.saveSession(modelContext: modelContext)
                sessionComplete = true
            }
        }
        .onChange(of: vm.hasAnswered) { _, answered in
            if answered { timerActive = false }
        }
    }

    private func resetTimer() {
        timeRemaining = 30
        timerActive = true
    }

    @ViewBuilder
    private func exerciseContent(exercise: CurriculumExercise) -> some View {
        switch exercise.type {
        case .lesson:
            LessonSlideView(vm: vm, exercise: exercise)
                .padding(.top, 8)

        case .diction:
            ScrollView {
                VStack(spacing: 16) {
                    LeoPrimaryBubble(leo: vm.leo).padding(.top, 12)
                    DictionView(vm: vm, exercise: exercise)
                    Spacer(minLength: 40)
                }
            }

        case .writeWord:
            ScrollView {
                VStack(spacing: 16) {
                    LeoPrimaryBubble(leo: vm.leo).padding(.top, 12)
                    WriteWordView(vm: vm, exercise: exercise)
                    Spacer(minLength: 40)
                }
            }

        case .fillBlank:
            ScrollView {
                VStack(spacing: 16) {
                    LeoPrimaryBubble(leo: vm.leo).padding(.top, 12)
                    FillBlankView(vm: vm, exercise: exercise)
                    Spacer(minLength: 40)
                }
            }

        case .multipleChoice:
            ScrollView {
                VStack(spacing: 16) {
                    LeoPrimaryBubble(leo: vm.leo).padding(.top, 12)
                    CharacterBubble(exercise: exercise,
                                    isSpeaking: vm.isSpeaking,
                                    onReplay: { vm.speakCurrentExercise() })
                    MultipleChoiceView(vm: vm, exercise: exercise)
                    Spacer(minLength: 40)
                }
            }

        default:
            ScrollView {
                VStack(spacing: 24) {
                    LeoPrimaryBubble(leo: vm.leo).padding(.top, 12)
                    CharacterBubble(exercise: exercise,
                                    isSpeaking: vm.isSpeaking,
                                    onReplay: { vm.speakCurrentExercise() })
                        .padding(.top, 8)

                    if !vm.hasAnswered {
                        switch exercise.type {
                        case .repeatAfterMe:
                            RepeatResponseView(vm: vm)
                        default:
                            WriteResponseView(vm: vm)
                        }
                    }

                    if vm.hasAnswered {
                        FeedbackCard(correct: vm.lastAnswerCorrect,
                                     expected: exercise.expectedAnswer)
                        nextButton
                    }
                    Spacer(minLength: 40)
                }
            }
        }
    }

    @ViewBuilder
    private var nextButton: some View {
        if vm.hasAnswered {
            Button {
                if vm.currentIndex + 1 >= vm.exercises.count {
                    vm.saveSession(modelContext: modelContext)
                    sessionComplete = true
                } else {
                    vm.nextExercise()
                }
            } label: {
                Text(vm.currentIndex + 1 >= vm.exercises.count
                     ? "Voir mon résultat !" : "Exercice suivant →")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("accentPurple"))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Compte à rebours circulaire
struct CountdownTimer: View {
    let timeRemaining: Int
    let total: Int

    var progress: Double { Double(timeRemaining) / Double(total) }
    var color: Color {
        if timeRemaining > 15 { return Color("accentGreen") }
        if timeRemaining > 8  { return Color("accentOrange") }
        return .red
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 3)
                .frame(width: 36, height: 36)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 36, height: 36)
                .animation(.linear(duration: 1), value: timeRemaining)
            Text("\(timeRemaining)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
        }
    }
}

// MARK: - Personnage + bulle de dialogue
struct CharacterBubble: View {
    let exercise: CurriculumExercise
    let isSpeaking: Bool
    let onReplay: () -> Void

    var characterEmoji: String { exercise.useGirl ? "👧" : "🧒" }
    var characterName: String  { exercise.useGirl ? "Léa" : "Léo" }

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Text(characterName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color("accentPurple"))
                    Text("dit :")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                Text(exercise.characterSays)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                // Grand visuel TSA — support pictographique
                HStack {
                    Spacer()
                    Text(exercise.emoji)
                        .font(.system(size: 72))
                        .padding(14)
                        .background(Color("accentPurple").opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("cardBackground"))
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("accentPurple").opacity(0.2), lineWidth: 1))
            )

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color("accentPurple").opacity(0.1))
                        .frame(width: 70, height: 70)
                    Text(characterEmoji)
                        .font(.system(size: 40))
                        .scaleEffect(isSpeaking ? 1.15 : 1.0)
                        .animation(isSpeaking
                            ? .easeInOut(duration: 0.4).repeatForever(autoreverses: true)
                            : .default, value: isSpeaking)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(characterName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Button(action: onReplay) {
                        HStack(spacing: 6) {
                            Image(systemName: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .font(.system(size: 14))
                            Text(isSpeaking ? "En train de parler..." : "Réécouter")
                                .font(.system(size: 14))
                        }
                        .foregroundColor(Color("accentPurple"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color("accentPurple").opacity(0.1))
                        .cornerRadius(10)
                    }
                    .disabled(isSpeaking)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Mode répétition orale
struct RepeatResponseView: View {
    @ObservedObject var vm: LearningSessionVM
    @State private var hasPressed = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Répète à voix haute !")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            Text("Écoute bien, puis dis la phrase.")
                .font(.system(size: 14))
                .foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center)

            // Indice ABA si demandé
            if vm.showHint, let ex = vm.currentExercise {
                HintBubble(text: vm.hintText(for: ex))
            }

            Button {
                hasPressed = true
                vm.confirmRepeated()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: hasPressed ? "checkmark.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 28))
                    Text(hasPressed ? "Bien dit !" : "J'ai répété à voix haute ✓")
                        .font(.system(size: 17, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(hasPressed ? Color("accentGreen") : Color("accentOrange"))
                .cornerRadius(16)
                .animation(.spring(response: 0.3), value: hasPressed)
            }
            .padding(.horizontal, 20)
            .disabled(hasPressed)

            // Bouton indice (hiérarchie de prompts ABA)
            if !hasPressed && vm.currentPromptLevel != .full {
                Button {
                    vm.requestHint()
                } label: {
                    Text(vm.currentPromptLevel.hintButtonLabel)
                        .font(.system(size: 14))
                        .foregroundColor(Color("accentPurple"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("accentPurple").opacity(0.08))
                        .cornerRadius(10)
                }
            }

            Text("Si tu n'y arrives pas, réécoute et réessaie !")
                .font(.system(size: 12))
                .foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Mode réponse écrite
struct WriteResponseView: View {
    @ObservedObject var vm: LearningSessionVM
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            if let ex = vm.currentExercise {
                Text(ex.prompt)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .multilineTextAlignment(.center)

                // Indice ABA si demandé
                if vm.showHint {
                    HintBubble(text: vm.hintText(for: ex))
                }
            }

            TextField("Écris ta réponse ici...", text: $vm.userInput, axis: .vertical)
                .font(.system(size: 17))
                .padding(14)
                .background(Color("cardBackground"))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(isFocused ? Color("accentPurple") : Color("borderLight"),
                            lineWidth: isFocused ? 1.5 : 0.5))
                .focused($isFocused)
                .lineLimit(3)
                .padding(.horizontal, 20)
                .onAppear { isFocused = true }

            // Bouton indice (hiérarchie de prompts ABA)
            if vm.currentPromptLevel != .full {
                Button {
                    isFocused = false
                    vm.requestHint()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 13))
                        Text(vm.currentPromptLevel.hintButtonLabel)
                            .font(.system(size: 14))
                    }
                    .foregroundColor(Color("accentOrange"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color("accentOrange").opacity(0.08))
                    .cornerRadius(10)
                }
            }

            Button {
                isFocused = false
                vm.submitAnswer()
            } label: {
                Text("Valider ma réponse")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(vm.userInput.trimmingCharacters(in: .whitespaces).isEmpty
                                ? Color("textSecondary").opacity(0.4)
                                : Color("accentPurple"))
                    .cornerRadius(16)
            }
            .disabled(vm.userInput.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Bulle d'indice ABA
struct HintBubble: View {
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Text("💡")
                .font(.system(size: 20))
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("accentOrange"))
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("accentOrange").opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("accentOrange").opacity(0.25), lineWidth: 1))
        )
        .padding(.horizontal, 20)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// MARK: - Feedback
struct FeedbackCard: View {
    let correct: Bool
    let expected: String

    var body: some View {
        VStack(spacing: 12) {
            Text(correct ? "🎉 Excellent !" : "💪 Presque !")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(correct ? Color("accentGreen") : Color("accentOrange"))

            if !correct {
                VStack(spacing: 4) {
                    Text("La bonne réponse :")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                    Text(expected)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(correct ? Color("accentGreen").opacity(0.08) : Color("accentOrange").opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(correct ? Color("accentGreen").opacity(0.3) : Color("accentOrange").opacity(0.3),
                            lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Barre de progression session
struct SessionProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4).fill(Color("borderLight")).frame(height: 6)
                RoundedRectangle(cornerRadius: 4).fill(Color("accentPurple"))
                    .frame(width: geo.size.width * max(0, min(1, value)), height: 6)
                    .animation(.spring(response: 0.4), value: value)
            }
        }
        .frame(height: 6)
    }
}

// MARK: - Fin de session
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
            Text(successRate >= 75 ? "🎉" : "💪").font(.system(size: 80))
            VStack(spacing: 8) {
                Text(successRate >= 75 ? "Bravo !" : "Continue comme ça !")
                    .font(.system(size: 28, weight: .medium)).foregroundColor(Color("textPrimary"))
                Text("Tu as gagné \(starsEarned) étoile\(starsEarned > 1 ? "s" : "") !")
                    .font(.system(size: 18)).foregroundColor(Color("accentOrange"))
            }
            HStack(spacing: 16) {
                ResultStat(value: "\(successRate)%", label: "Réussite", emoji: "🎯")
                ResultStat(value: "\(starsEarned)", label: "Étoiles", emoji: "⭐️")
                ResultStat(value: "\(correctAnswers)/\(total)", label: "Correct", emoji: "✅")
            }
            .padding(.horizontal, 20)
            Spacer()
            Button(action: onContinue) {
                Text("Retour à l'accueil")
                    .font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Color("accentPurple")).cornerRadius(16)
            }
            .padding(.horizontal, 24).padding(.bottom, 32)
        }
        .background(Color("backgroundSoft").ignoresSafeArea())
    }
}

struct ResultStat: View {
    let value: String; let label: String; let emoji: String
    var body: some View {
        VStack(spacing: 4) {
            Text(emoji).font(.system(size: 28))
            Text(value).font(.system(size: 20, weight: .medium)).foregroundColor(Color("textPrimary"))
            Text(label).font(.system(size: 12)).foregroundColor(Color("textSecondary"))
        }
        .frame(maxWidth: .infinity).padding(14)
        .background(Color("cardBackground")).cornerRadius(14)
    }
}
