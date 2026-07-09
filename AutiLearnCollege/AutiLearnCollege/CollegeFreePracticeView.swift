import SwiftUI

// MARK: - Jeux libres : exploration sans évaluation
struct CollegeFreePracticeView: View {
    let student: CollegeProfile
    @State private var selectedSubject: CollegeSubject? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Explore les matières à ton rythme,\nsans pression, sans score.")
                        .font(.system(size: 15))
                        .foregroundColor(Color("textSecondary"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 14) {
                        ForEach(CollegeSubject.allCases, id: \.self) { subject in
                            NavigationLink {
                                CollegeFreeSubjectView(student: student, subject: subject)
                            } label: {
                                FreeSubjectCard(subject: subject)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer(minLength: 40)
                }
                .padding(.top, 16)
            }
            .background(Color("backgroundSoft"))
            .navigationTitle("🎮 Jeux libres")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Carte matière jeux libres
struct FreeSubjectCard: View {
    let subject: CollegeSubject

    var body: some View {
        VStack(spacing: 10) {
            Text(subject.emoji)
                .font(.system(size: 44))
            Text(subject.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color("textPrimary"))
            Text("Explorer")
                .font(.system(size: 12))
                .foregroundColor(Color(subject.color))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(subject.color).opacity(0.3), lineWidth: 1.5))
        )
        .shadow(color: Color(subject.color).opacity(0.1), radius: 6, y: 3)
    }
}

// MARK: - Exploration libre d'une matière
struct CollegeFreeSubjectView: View {
    let student: CollegeProfile
    let subject: CollegeSubject

    @StateObject private var leo = LeoCompanion()
    @State private var exercises: [CollegeExercise] = []
    @State private var currentIndex = 0
    @State private var revealed = false

    var currentExercise: CollegeExercise? {
        guard currentIndex < exercises.count else { return nil }
        return exercises[currentIndex]
    }

    var body: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()
            VStack(spacing: 0) {
                if let ex = currentExercise {
                    if ex.mode == .lesson {
                        CollegeFreeLessonSlide(exercise: ex, leo: leo) {
                            go(to: currentIndex + 1)
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                // Avatar + compteur
                                HStack {
                                    LeoAvatarView(isSpeaking: leo.isSpeaking,
                                                  accentColor: Color(subject.color))
                                        .frame(width: 48, height: 56)
                                    Spacer()
                                    Text("\(currentIndex + 1) / \(exercises.count)")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("textSecondary"))
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 12)

                                // Emoji + question
                                VStack(spacing: 12) {
                                    Text(ex.emoji)
                                        .font(.system(size: 72))
                                    Text(ex.question)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Color("textPrimary"))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                        .padding(.horizontal, 20)
                                }
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("cardBackground")))
                                .padding(.horizontal, 20)

                                // Bouton "voir la réponse"
                                if !revealed {
                                    Button {
                                        withAnimation(.spring(response: 0.4)) { revealed = true }
                                        leo.speakText(ex.correctAnswer)
                                    } label: {
                                        Label("Voir la réponse", systemImage: "lightbulb.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(Color(subject.color))
                                            .cornerRadius(16)
                                    }
                                    .padding(.horizontal, 20)
                                } else {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("✅ Réponse")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(Color(subject.color))
                                        Text(ex.correctAnswer)
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(Color("textPrimary"))
                                        if !ex.explanation.isEmpty {
                                            Text(ex.explanation)
                                                .font(.system(size: 14))
                                                .foregroundColor(Color("textSecondary"))
                                                .lineSpacing(3)
                                        }
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(subject.color).opacity(0.08)))
                                    .padding(.horizontal, 20)
                                }

                                // Navigation
                                HStack(spacing: 12) {
                                    if currentIndex > 0 {
                                        Button {
                                            go(to: currentIndex - 1)
                                        } label: {
                                            Image(systemName: "arrow.left.circle.fill")
                                                .font(.system(size: 36))
                                                .foregroundColor(Color("textSecondary"))
                                        }
                                    }
                                    Spacer()
                                    if currentIndex + 1 < exercises.count {
                                        Button {
                                            go(to: currentIndex + 1)
                                        } label: {
                                            HStack(spacing: 6) {
                                                Text("Question suivante")
                                                Image(systemName: "arrow.right.circle.fill")
                                            }
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 12)
                                            .background(Color(subject.color))
                                            .cornerRadius(14)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                Spacer(minLength: 40)
                            }
                        }
                    }
                } else {
                    // Fin de l'exploration
                    VStack(spacing: 20) {
                        Text("🎉").font(.system(size: 72))
                        Text("Tu as tout exploré !")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color("textPrimary"))
                        Button { go(to: 0) } label: {
                            Text("Recommencer")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 14)
                                .background(Color(subject.color))
                                .cornerRadius(16)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Bulle Léa
                LeoBubbleView(leo: leo)
                    .padding(.bottom, 16)
            }
        }
        .navigationTitle(subject.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            leo.configure(language: student.language)
            exercises = CollegeContentLibrary.exercises(
                for: subject, level: student.level,
                language: student.language, count: 12).shuffled()
            if let first = exercises.first {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    leo.speak(context: .askQuestion(subject: subject.rawValue))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if first.mode != .lesson { leo.speakText(first.question) }
                }
            }
        }
    }

    private func go(to index: Int) {
        currentIndex = index
        revealed = false
        if let ex = exercises[safe: index], ex.mode != .lesson {
            leo.speakText(ex.question)
        }
    }

}

// MARK: - Slide de cours simplifiée pour jeux libres (sans VM)
struct CollegeFreeLessonSlide: View {
    let exercise: CollegeExercise
    let leo: LeoCompanion
    let onNext: () -> Void

    @State private var revealed = false
    @State private var bodyOpacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label("Cours", systemImage: "book.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(Color(exercise.subject.color))
                    .cornerRadius(20)
                Spacer()
                Button { leo.speakText(exercise.question) } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(exercise.subject.color))
                }
            }
            .padding(.horizontal, 20).padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 20) {
                    Text(exercise.emoji)
                        .font(.system(size: 80))
                        .scaleEffect(revealed ? 1.0 : 0.4)
                        .opacity(revealed ? 1 : 0)
                        .animation(.spring(response: 0.55, dampingFraction: 0.65), value: revealed)

                    if !exercise.lessonTitle.isEmpty {
                        Text(exercise.lessonTitle)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.center)
                            .opacity(revealed ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(0.2), value: revealed)
                    }

                    if !exercise.lessonBody.isEmpty {
                        CollegeLessonBodyText(text: exercise.lessonBody)
                            .opacity(bodyOpacity)
                    }
                }
                .padding(.horizontal, 20).padding(.bottom, 24)
            }

            Button {
                onNext()
            } label: {
                HStack(spacing: 8) {
                    Text("J'ai compris !")
                    Image(systemName: "arrow.right.circle.fill")
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(exercise.subject.color))
                .cornerRadius(18)
            }
            .padding(.horizontal, 20).padding(.bottom, 16)
        }
        .onAppear {
            leo.speakText(exercise.question)
            withAnimation { revealed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { bodyOpacity = 1 }
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
