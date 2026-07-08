import SwiftUI

// MARK: - Slide de cours illustrée (version collège/lycée)
struct CollegeLessonSlideView: View {
    @ObservedObject var vm: CollegeSessionVM
    let exercise: CollegeExercise
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
                    .background(Color(exercise.subject.color))
                    .cornerRadius(20)
                Spacer()
                Button { vm.leo.speakText(exercise.question) } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(exercise.subject.color))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 20) {
                    Text(exercise.emoji)
                        .font(.system(size: 96))
                        .scaleEffect(revealed ? 1.0 : 0.4)
                        .opacity(revealed ? 1.0 : 0)
                        .animation(.spring(response: 0.55, dampingFraction: 0.65), value: revealed)
                        .padding(.bottom, 8)

                    if !exercise.lessonTitle.isEmpty {
                        Text(exercise.lessonTitle)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.center)
                            .opacity(revealed ? 1 : 0)
                            .offset(y: revealed ? 0 : 10)
                            .animation(.easeOut(duration: 0.4).delay(0.2), value: revealed)
                    }

                    if !exercise.lessonBody.isEmpty {
                        CollegeLessonBodyText(text: exercise.lessonBody)
                            .opacity(bodyOpacity)
                            .animation(.easeIn(duration: 0.5).delay(0.4), value: bodyOpacity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            Button { vm.nextExercise() } label: {
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
                .shadow(color: Color(exercise.subject.color).opacity(0.35), radius: 8, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .onAppear {
            vm.leo.speakText(exercise.question)
            withAnimation { revealed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                bodyOpacity = 1
            }
        }
    }
}

// Texte avec **mots** en gras/couleur
struct CollegeLessonBodyText: View {
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
