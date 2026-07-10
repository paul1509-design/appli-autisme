import SwiftUI

struct CollegeSessionView: View {
    let student: CollegeProfile
    let subject: CollegeSubject

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: CollegeSessionVM
    @State private var sessionComplete = false
    @State private var timeRemaining: Int = 45
    @State private var timerActive = false
    let exerciseTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(student: CollegeProfile, subject: CollegeSubject) {
        self.student = student
        self.subject = subject
        _vm = StateObject(wrappedValue: CollegeSessionVM(student: student, subject: subject))
    }

    var body: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()

            if sessionComplete {
                CollegeSessionCompleteView(vm: vm, onContinue: { dismiss() })
            } else if let exercise = vm.currentExercise {
                VStack(spacing: 0) {
                    // Barre du haut
                    VStack(spacing: 12) {
                        SessionProgressBar(value: vm.progress)
                            .padding(.horizontal, 20)

                        HStack {
                            // Avatar Léa animé permanent
                            LeoAvatarView(isSpeaking: vm.leo.isSpeaking,
                                          accentColor: Color(subject.color))
                                .frame(width: 48, height: 56)

                            HStack(spacing: 6) {
                                Text(subject.emoji)
                                Text(subject.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(subject.color))
                            }
                            Spacer()
                            CollegeCountdownTimer(timeRemaining: timeRemaining, total: 45)
                            Spacer()
                            HStack(spacing: 4) {
                                Text("⭐️")
                                Text("\(vm.starsEarned)")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                            }
                            Button {
                                vm.saveSession(modelContext: modelContext)
                                dismiss()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color("textSecondary"))
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)

                    if exercise.mode == .lesson {
                        CollegeLessonSlideView(vm: vm, exercise: exercise)
                            .padding(.top, 8)
                    } else {
                        ScrollView(.vertical) {
                            VStack(spacing: 20) {
                                QuestionCard(exercise: exercise, vm: vm)
                                    .padding(.top, 16)

                                if !vm.hasAnswered {
                                    switch exercise.mode {
                                    case .multipleChoice, .trueFalse:
                                        MultipleChoiceView(exercise: exercise, vm: vm)
                                    case .fillBlank, .shortAnswer:
                                        ShortAnswerView(vm: vm)
                                    case .oral:
                                        OralResponseView(vm: vm)
                                    case .lesson:
                                        EmptyView()
                                    }
                                }

                                if vm.hasAnswered {
                                    ExplanationCard(exercise: exercise, correct: vm.lastAnswerCorrect)

                                    Button {
                                        if vm.currentIndex + 1 >= vm.exercises.count {
                                            vm.saveSession(modelContext: modelContext)
                                            sessionComplete = true
                                        } else {
                                            vm.nextExercise()
                                        }
                                    } label: {
                                        Text(vm.currentIndex + 1 >= vm.exercises.count
                                             ? "Voir mes résultats" : "Question suivante →")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .background(Color(subject.color))
                                            .cornerRadius(16)
                                    }
                                    .padding(.horizontal, 20)
                                }

                                Spacer(minLength: 120)
                            }
                        }
                    }
                }
            }

            // Léo — bulle de dialogue flottante en bas
            VStack {
                Spacer()
                LeoBubbleView(leo: vm.leo)
                    .padding(.bottom, 16)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            vm.startSession()
            timeRemaining = 45
            timerActive = true
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
            timeRemaining = 45; timerActive = true
            if vm.isSessionComplete {
                vm.saveSession(modelContext: modelContext)
                sessionComplete = true
            }
        }
        .onChange(of: vm.hasAnswered) { _, answered in
            if answered { timerActive = false }
        }
    }
}

// MARK: - Carte question
struct QuestionCard: View {
    let exercise: CollegeExercise
    @ObservedObject var vm: CollegeSessionVM

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Visuel principal — grand emoji pour support TSA
            HStack {
                Spacer()
                Text(exercise.emoji)
                    .font(.system(size: 64))
                    .padding(12)
                    .background(Color(exercise.subject.color).opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Spacer()
            }

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Difficulté " + String(repeating: "★", count: exercise.difficulty) + String(repeating: "☆", count: 3 - exercise.difficulty))
                        .font(.system(size: 11))
                        .foregroundColor(Color("textSecondary"))
                    Text(exercise.subject.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(exercise.subject.color))
                }
                Spacer()
                Button { vm.speak(exercise.question) } label: {
                    Image(systemName: vm.leo.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                        .font(.system(size: 18))
                        .foregroundColor(Color(exercise.subject.color))
                }
                .disabled(vm.leo.isSpeaking)
            }

            Text(exercise.question)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textPrimary"))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            if vm.showHint, let ex = vm.currentExercise {
                CollegeHintBubble(text: vm.hintText(for: ex))
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(exercise.subject.color).opacity(0.25), lineWidth: 1))
        )
        .padding(.horizontal, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                if !vm.leo.isSpeaking { vm.speak(exercise.question) }
            }
        }
    }
}

// MARK: - Choix multiples / Vrai-Faux
struct MultipleChoiceView: View {
    let exercise: CollegeExercise
    @ObservedObject var vm: CollegeSessionVM

    var body: some View {
        VStack(spacing: 10) {
            ForEach(exercise.choices, id: \.self) { choice in
                Button { vm.submitChoice(choice) } label: {
                    HStack {
                        Text(choice)
                            .font(.system(size: 16))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(vm.selectedChoice == choice
                                  ? Color(exercise.subject.color).opacity(0.15)
                                  : Color("cardBackground"))
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(vm.selectedChoice == choice
                                        ? Color(exercise.subject.color)
                                        : Color("borderLight"),
                                        lineWidth: vm.selectedChoice == choice ? 1.5 : 0.5))
                    )
                }
            }

            if vm.promptLevel != .full {
                Button { vm.requestHint() } label: {
                    Text(vm.promptLevel.buttonLabel)
                        .font(.system(size: 13))
                        .foregroundColor(Color("accentOrange"))
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(Color("accentOrange").opacity(0.08))
                        .cornerRadius(10)
                }
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Réponse courte / compléter
struct ShortAnswerView: View {
    @ObservedObject var vm: CollegeSessionVM
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 12) {
            TextField("Ta réponse...", text: $vm.userInput, axis: .vertical)
                .font(.system(size: 16))
                .padding(14)
                .background(Color("cardBackground"))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(focused ? Color("accentPurple") : Color("borderLight"),
                            lineWidth: focused ? 1.5 : 0.5))
                .focused($focused)
                .lineLimit(3)
                .onAppear { focused = true }

            HStack(spacing: 12) {
                if vm.promptLevel != .full {
                    Button { focused = false; vm.requestHint() } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "lightbulb.fill").font(.system(size: 12))
                            Text(vm.promptLevel.buttonLabel).font(.system(size: 13))
                        }
                        .foregroundColor(Color("accentOrange"))
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(Color("accentOrange").opacity(0.08))
                        .cornerRadius(10)
                    }
                }
                Spacer()
                Button {
                    focused = false
                    vm.submitShortAnswer()
                } label: {
                    Text("Valider")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24).padding(.vertical, 12)
                        .background(vm.userInput.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? Color("textSecondary").opacity(0.4) : Color("accentPurple"))
                        .cornerRadius(12)
                }
                .disabled(vm.userInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Réponse orale
struct OralResponseView: View {
    @ObservedObject var vm: CollegeSessionVM
    @State private var hasSpoken = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Réponds à voix haute")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            Text("Prends le temps de formuler ta réponse en une ou deux phrases complètes.")
                .font(.system(size: 13))
                .foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 12)

            Button {
                hasSpoken = true
                vm.confirmOral()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: hasSpoken ? "checkmark.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 24))
                    Text(hasSpoken ? "Réponse enregistrée ✓" : "J'ai répondu à voix haute")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(hasSpoken ? Color("accentGreen") : Color("accentOrange"))
                .cornerRadius(16)
                .animation(.spring(response: 0.3), value: hasSpoken)
            }
            .padding(.horizontal, 20)
            .disabled(hasSpoken)

            if vm.promptLevel != .full {
                Button { vm.requestHint() } label: {
                    Text(vm.promptLevel.buttonLabel)
                        .font(.system(size: 13))
                        .foregroundColor(Color("accentPurple"))
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(Color("accentPurple").opacity(0.08))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Explication pédagogique
struct ExplanationCard: View {
    let exercise: CollegeExercise
    let correct: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(correct ? "✅" : "💡").font(.system(size: 22))
                Text(correct ? "Bonne réponse !" : "La bonne réponse était :")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(correct ? Color("accentGreen") : Color("accentOrange"))
            }

            if !correct {
                Text(exercise.correctAnswer)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
            }

            Divider()

            Text(exercise.explanation)
                .font(.system(size: 14))
                .foregroundColor(Color("textSecondary"))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(correct ? Color("accentGreen").opacity(0.07) : Color("accentOrange").opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(correct ? Color("accentGreen").opacity(0.3) : Color("accentOrange").opacity(0.3),
                            lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Bulle d'indice
struct CollegeHintBubble: View {
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Text("💡").font(.system(size: 18))
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("accentOrange"))
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("accentOrange").opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("accentOrange").opacity(0.25), lineWidth: 1))
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// MARK: - Timer circulaire (45s)
struct CollegeCountdownTimer: View {
    let timeRemaining: Int
    let total: Int
    var progress: Double { Double(timeRemaining) / Double(total) }
    var color: Color {
        if timeRemaining > 20 { return Color("accentGreen") }
        if timeRemaining > 10 { return Color("accentOrange") }
        return .red
    }
    var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.2), lineWidth: 3).frame(width: 36, height: 36)
            Circle().trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 36, height: 36)
                .animation(.linear(duration: 1), value: timeRemaining)
            Text("\(timeRemaining)").font(.system(size: 11, weight: .medium)).foregroundColor(color)
        }
    }
}

// MARK: - Fin de session
struct CollegeSessionCompleteView: View {
    @ObservedObject var vm: CollegeSessionVM
    let onContinue: () -> Void

    var successRate: Int {
        guard vm.totalAnswers > 0 else { return 0 }
        return Int(Double(vm.correctAnswers) / Double(vm.totalAnswers) * 100)
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text(successRate >= 75 ? "🎉" : "💪").font(.system(size: 72))
            VStack(spacing: 8) {
                Text(successRate >= 75 ? "Excellent travail !" : "Continue tes efforts !")
                    .font(.system(size: 26, weight: .medium)).foregroundColor(Color("textPrimary"))
                Text("Tu as gagné \(vm.starsEarned) étoile\(vm.starsEarned > 1 ? "s" : "") !")
                    .font(.system(size: 17)).foregroundColor(Color("accentOrange"))
            }
            HStack(spacing: 16) {
                CollegeResultStat(value: "\(successRate)%", label: "Réussite", emoji: "🎯")
                CollegeResultStat(value: "\(vm.starsEarned)", label: "Étoiles", emoji: "⭐️")
                CollegeResultStat(value: "\(vm.correctAnswers)/\(vm.totalAnswers)", label: "Correct", emoji: "✅")
            }
            .padding(.horizontal, 20)
            Spacer()
            Button(action: onContinue) {
                Text("Retour aux matières")
                    .font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Color("accentPurple")).cornerRadius(16)
            }
            .padding(.horizontal, 24).padding(.bottom, 32)
        }
        .background(Color("backgroundSoft").ignoresSafeArea())
    }
}

struct CollegeResultStat: View {
    let value: String; let label: String; let emoji: String
    var body: some View {
        VStack(spacing: 4) {
            Text(emoji).font(.system(size: 26))
            Text(value).font(.system(size: 18, weight: .medium)).foregroundColor(Color("textPrimary"))
            Text(label).font(.system(size: 11)).foregroundColor(Color("textSecondary"))
        }
        .frame(maxWidth: .infinity).padding(12)
        .background(Color("cardBackground")).cornerRadius(12)
    }
}

// MARK: - Réutilisé de l'app primaire
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
