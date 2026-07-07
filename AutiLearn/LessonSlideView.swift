import SwiftUI

// MARK: - Slide de cours illustré (phase "Cours" avant les exercices)
struct LessonSlideView: View {
    @ObservedObject var vm: LearningSessionVM
    let exercise: CurriculumExercise
    @State private var revealed = false
    @State private var bodyOpacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            // Badge "COURS"
            HStack {
                Label("Cours", systemImage: "book.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color("accentPurple"))
                    .cornerRadius(20)
                Spacer()
                // Réécouter
                Button { vm.speak(exercise.characterSays) } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color("accentPurple"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 20) {
                    // Grande image illustrative
                    Text(exercise.emoji)
                        .font(.system(size: 96))
                        .scaleEffect(revealed ? 1.0 : 0.4)
                        .opacity(revealed ? 1.0 : 0)
                        .animation(.spring(response: 0.55, dampingFraction: 0.65), value: revealed)
                        .padding(.bottom, 8)

                    // Titre du cours
                    if !exercise.lessonTitle.isEmpty {
                        Text(exercise.lessonTitle)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.center)
                            .opacity(revealed ? 1 : 0)
                            .offset(y: revealed ? 0 : 10)
                            .animation(.easeOut(duration: 0.4).delay(0.2), value: revealed)
                    }

                    // Corps explicatif avec surlignage des mots-clés
                    if !exercise.lessonBody.isEmpty {
                        LessonBodyText(text: exercise.lessonBody)
                            .opacity(bodyOpacity)
                            .animation(.easeIn(duration: 0.5).delay(0.4), value: bodyOpacity)
                    }

                    // Tip visuel pour enfants autistes : pictogramme d'action
                    if !exercise.prompt.isEmpty {
                        HStack(spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text(exercise.prompt)
                                .font(.system(size: 15))
                                .foregroundColor(Color("textSecondary"))
                        }
                        .padding(12)
                        .background(Color.yellow.opacity(0.10))
                        .cornerRadius(12)
                        .padding(.horizontal, 4)
                        .opacity(bodyOpacity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            // Bouton "J'ai compris, continuer"
            Button {
                vm.nextExercise()
            } label: {
                HStack(spacing: 8) {
                    Text("J'ai compris !")
                    Image(systemName: "arrow.right.circle.fill")
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color("accentPurple"), Color("accentBlue")],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .cornerRadius(18)
                .shadow(color: Color("accentPurple").opacity(0.35), radius: 8, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .onAppear {
            // Léa narrate le cours
            vm.speak(exercise.characterSays)
            withAnimation { revealed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                bodyOpacity = 1
            }
        }
    }
}

// Texte du cours avec mots importants en gras/couleur
struct LessonBodyText: View {
    let text: String

    var body: some View {
        Text(parseText())
            .font(.system(size: 17))
            .foregroundColor(Color("textPrimary"))
            .lineSpacing(5)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
    }

    private func parseText() -> AttributedString {
        var result = AttributedString(text)
        // Mots entre ** sont mis en gras couleur
        let pattern = /\*\*(.+?)\*\*/
        for match in text.matches(of: pattern) {
            let word = String(match.output.1)
            if let range = result.range(of: "**\(word)**") {
                result.replaceSubrange(range, with: {
                    var s = AttributedString(word)
                    s.font = .system(size: 17, weight: .bold)
                    s.foregroundColor = UIColor(named: "accentPurple").map { Color($0) } ?? .purple
                    return s
                }())
            }
        }
        return result
    }
}

// MARK: - Vue exercice écriture progressive
struct WriteWordView: View {
    @ObservedObject var vm: LearningSessionVM
    let exercise: CurriculumExercise

    @State private var showLetterHints = false
    @State private var revealedLetters = 0
    @FocusState private var focused: Bool

    var target: String { exercise.expectedAnswer }
    var letters: [Character] { Array(target) }

    var body: some View {
        VStack(spacing: 20) {
            // Emoji + question
            Text(exercise.emoji)
                .font(.system(size: 72))

            Text(exercise.characterSays)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textPrimary"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            // Cases de lettres (si hints activés)
            if showLetterHints && revealedLetters > 0 {
                HStack(spacing: 6) {
                    ForEach(0..<letters.count, id: \.self) { i in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("accentPurple").opacity(0.4), lineWidth: 1.5)
                                .frame(width: 36, height: 44)
                            if i < revealedLetters {
                                Text(String(letters[i]).uppercased())
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("accentPurple"))
                            } else {
                                Rectangle()
                                    .fill(Color("borderLight").opacity(0.3))
                                    .frame(width: 20, height: 2)
                            }
                        }
                    }
                }
            }

            // Champ de saisie
            TextField(exercise.writingPrompt.isEmpty ? "Écris le mot ici..." : exercise.writingPrompt,
                      text: $vm.userInput)
                .font(.system(size: 22, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(14)
                .background(Color("cardBackground"))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("accentPurple").opacity(0.3), lineWidth: 1.5))
                .focused($focused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onAppear { focused = true }

            // Boutons d'aide progressive
            HStack(spacing: 12) {
                if !vm.hasAnswered && !showLetterHints {
                    Button {
                        showLetterHints = true
                        revealedLetters = 1
                        vm.totalPromptsUsed += 1
                        vm.leo.speakText("Regarde la première lettre : \(String(letters[0]))")
                    } label: {
                        Label("Indice", systemImage: "lightbulb")
                            .font(.system(size: 14))
                            .foregroundColor(Color("accentOrange"))
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .background(Color("accentOrange").opacity(0.10))
                            .cornerRadius(10)
                    }
                } else if showLetterHints && revealedLetters < letters.count && !vm.hasAnswered {
                    Button {
                        revealedLetters = min(revealedLetters + 1, letters.count - 1)
                        vm.totalPromptsUsed += 1
                        let shown = String(letters.prefix(revealedLetters))
                        vm.leo.speakText("Voilà : \(shown)...")
                    } label: {
                        Label("Encore un indice", systemImage: "lightbulb.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color("accentOrange"))
                            .padding(.horizontal, 14).padding(.vertical, 8)
                            .background(Color("accentOrange").opacity(0.10))
                            .cornerRadius(10)
                    }
                }

                if !vm.hasAnswered {
                    Button { vm.submitAnswer() } label: {
                        Text("Valider")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24).padding(.vertical, 10)
                            .background(vm.userInput.isEmpty ? Color.gray : Color("accentGreen"))
                            .cornerRadius(12)
                    }
                    .disabled(vm.userInput.isEmpty)
                }
            }

            if vm.hasAnswered {
                FeedbackCard(correct: vm.lastAnswerCorrect, expected: exercise.expectedAnswer)
                Button { vm.nextExercise() } label: {
                    Text("Exercice suivant →")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("accentGreen"))
                        .cornerRadius(14)
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear { vm.speak(exercise.characterSays) }
    }
}

// MARK: - Vue compléter un trou
struct FillBlankView: View {
    @ObservedObject var vm: LearningSessionVM
    let exercise: CurriculumExercise

    @State private var userWord = ""
    @FocusState private var focused: Bool

    // "Le ___ mange une pomme" → parts avant et après le trou
    var sentence: String { exercise.blankSentence.isEmpty ? exercise.prompt : exercise.blankSentence }
    var parts: [String] { sentence.components(separatedBy: "___") }

    var body: some View {
        VStack(spacing: 24) {
            Text(exercise.emoji)
                .font(.system(size: 72))

            // Phrase avec trou
            VStack(spacing: 12) {
                Text("Complète la phrase :")
                    .font(.system(size: 16))
                    .foregroundColor(Color("textSecondary"))

                // Affichage de la phrase avec le champ au milieu
                Group {
                    if parts.count >= 2 {
                        (Text(parts[0]).bold() +
                         Text(" [\(userWord.isEmpty ? "   ?   " : userWord)] ").foregroundColor(Color("accentPurple")).bold() +
                         Text(parts[1]).bold())
                    } else {
                        Text(sentence)
                    }
                }
                .font(.system(size: 20))
                .foregroundColor(Color("textPrimary"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            }

            // Champ de saisie
            if !vm.hasAnswered {
                TextField("Écris le mot manquant...", text: $userWord)
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .background(Color("cardBackground"))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("accentPurple").opacity(0.3), lineWidth: 1.5))
                    .focused($focused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onAppear { focused = true }
                    .onChange(of: userWord) { vm.userInput = userWord }

                Button {
                    vm.userInput = userWord
                    vm.submitAnswer()
                } label: {
                    Text("Valider ✓")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(userWord.isEmpty ? Color.gray : Color("accentGreen"))
                        .cornerRadius(14)
                }
                .disabled(userWord.isEmpty)
            }

            if vm.hasAnswered {
                FeedbackCard(correct: vm.lastAnswerCorrect, expected: exercise.expectedAnswer)
                Button { vm.nextExercise() } label: {
                    Text("Exercice suivant →")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("accentGreen"))
                        .cornerRadius(14)
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear { vm.speak(exercise.characterSays) }
    }
}

// MARK: - Vue QCM enrichie
struct MultipleChoiceView: View {
    @ObservedObject var vm: LearningSessionVM
    let exercise: CurriculumExercise
    @State private var selected: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text(exercise.emoji)
                .font(.system(size: 72))

            Text(exercise.characterSays)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textPrimary"))
                .multilineTextAlignment(.center)

            // 4 options en grille 2×2
            let cols = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: cols, spacing: 12) {
                ForEach(exercise.choices, id: \.self) { choice in
                    ChoiceButton(
                        text: choice,
                        state: buttonState(for: choice),
                        action: {
                            guard !vm.hasAnswered else { return }
                            selected = choice
                            vm.userInput = choice
                            vm.submitAnswer()
                        }
                    )
                }
            }

            if vm.hasAnswered {
                FeedbackCard(correct: vm.lastAnswerCorrect, expected: exercise.expectedAnswer)
                Button { vm.nextExercise() } label: {
                    Text("Exercice suivant →")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color("accentGreen"))
                        .cornerRadius(14)
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear { vm.speak(exercise.characterSays) }
    }

    enum ButtonState { case idle, correct, wrong }

    func buttonState(for choice: String) -> ButtonState {
        guard vm.hasAnswered else { return .idle }
        if choice == exercise.expectedAnswer { return .correct }
        if choice == selected { return .wrong }
        return .idle
    }
}

struct ChoiceButton: View {
    let text: String
    let state: MultipleChoiceView.ButtonState
    let action: () -> Void

    var bg: Color {
        switch state {
        case .idle:    return Color("cardBackground")
        case .correct: return Color("accentGreen").opacity(0.15)
        case .wrong:   return Color("accentRed").opacity(0.12)
        }
    }
    var border: Color {
        switch state {
        case .idle:    return Color("borderLight")
        case .correct: return Color("accentGreen")
        case .wrong:   return Color("accentRed")
        }
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if state == .correct { Image(systemName: "checkmark.circle.fill").foregroundColor(Color("accentGreen")) }
                if state == .wrong   { Image(systemName: "xmark.circle.fill").foregroundColor(Color("accentRed")) }
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(14)
            .background(bg)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(border, lineWidth: 1.5))
        }
    }
}
