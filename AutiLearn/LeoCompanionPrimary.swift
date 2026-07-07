import AVFoundation
import SwiftUI

// MARK: - Léo compagnon interactif (app primaire, 3-10 ans)
@MainActor
class LeoPrimary: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    @Published var isSpeaking = false
    @Published var currentMessage = ""
    @Published var emotion: LeoEmotionP = .neutral
    @Published var showBubble = false

    private let synthesizer = AVSpeechSynthesizer()
    private var correctStreak = 0

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Contextes
    enum Context {
        case welcome(firstName: String)
        case returnAfterDays(firstName: String, days: Int)
        case moduleStart(module: String, firstName: String)
        case correct(streak: Int)
        case wrong(attempt: Int)
        case hint
        case sessionEnd(correct: Int, total: Int, firstName: String)
        case streakCelebration(days: Int, firstName: String)
        case encouragement(firstName: String)
    }

    func speak(context: Context) {
        let (msg, emo) = resolve(context)
        display(msg, emotion: emo)
        say(msg)
    }

    func recordAnswer(correct: Bool) {
        if correct { correctStreak += 1 } else { correctStreak = 0 }
        speak(context: correct ? .correct(streak: correctStreak) : .wrong(attempt: 1))
    }

    func stop() { synthesizer.stopSpeaking(at: .immediate) }

    private func say(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        isSpeaking = true
        for (i, sentence) in sentences.enumerated() {
            let utt = AVSpeechUtterance(string: sentence)
            utt.voice = AVSpeechSynthesisVoice(language: "fr-FR")
            utt.rate = 0.42          // naturel et clair pour 3-10 ans
            utt.pitchMultiplier = 1.2
            utt.volume = 0.95
            utt.preUtteranceDelay = i == 0 ? 0 : 0.22
            utt.postUtteranceDelay = 0.06
            synthesizer.speak(utt)
        }
    }

    private func display(_ message: String, emotion: LeoEmotionP) {
        currentMessage = message
        self.emotion = emotion
        withAnimation(.spring(response: 0.3)) { showBubble = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            withAnimation { self.showBubble = false }
        }
    }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish u: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }

    // MARK: - Banque de messages (français, adapté 3-10 ans)
    private func resolve(_ ctx: Context) -> (String, LeoEmotionP) {
        switch ctx {

        case .welcome(let fn): return (pick([
            "Bonjour \(fn) ! Je suis tellement content de te voir !",
            "Salut \(fn) ! On va apprendre plein de choses ensemble !",
            "\(fn) ! Tu es là ! C'est super !"
        ]), .excited)

        case .returnAfterDays(let fn, let d):
            if d == 1 { return ("Tu m'as manqué hier \(fn) ! Contente que tu sois là !", .caring) }
            return ("Ça fait \(d) jours \(fn) ! J'avais vraiment hâte de te revoir !", .caring)

        case .moduleStart(let module, let fn): return (pick([
            "On va faire \(module) ! Tu vas adorer \(fn) !",
            "\(module) aujourd'hui \(fn) ! On y va ensemble !",
            "Prêt(e) pour \(module) ? Moi oui \(fn) !"
        ]), .excited)

        case .correct(let streak):
            if streak >= 3 { return (pick([
                "\(streak) bonnes réponses ! Tu es une star !",
                "Wow \(streak) d'affilée ! T'es incroyable !",
                "\(streak) ! Super champion !"
            ]), .celebrating) }
            return (pick([
                "Bravo ! C'est exactement ça !",
                "Oui ! Bien joué !",
                "Super ! Tu es très fort(e) !",
                "Excellent ! Continue !",
                "Génial ! T'as tout compris !"
            ]), .happy)

        case .wrong(let attempt):
            if attempt == 1 { return (pick([
                "Presque ! On réessaie ensemble.",
                "Pas grave du tout ! Je t'aide.",
                "C'est difficile. Regarde bien !",
                "Ne t'inquiète pas — on va y arriver !"
            ]), .caring) }
            return (pick([
                "Relis doucement. La réponse est là !",
                "Je suis là avec toi. Essaie encore !",
                "Tu peux demander un indice, c'est normal !"
            ]), .supportive)

        case .hint: return (pick([
            "Je t'aide ! Voilà un indice.",
            "Bien sûr ! On est une équipe.",
            "C'est courageux de demander de l'aide !"
        ]), .helpful)

        case .sessionEnd(let correct, let total, let fn):
            let rate = total > 0 ? correct * 100 / total : 0
            if rate >= 80 { return (pick([
                "\(correct) sur \(total) \(fn) ! Tu es un génie !",
                "Magnifique \(fn) ! \(rate)% ! Je suis si fier de toi !",
                "Wow \(fn) ! Quelle super session !"
            ]), .celebrating) }
            if rate >= 50 { return (pick([
                "\(correct) sur \(total) — bien joué \(fn) !",
                "Bonne session \(fn) ! Tu t'améliores !",
                "Super travail \(fn) ! On continue !"
            ]), .happy) }
            return (pick([
                "\(fn), tu as essayé et c'est ce qui compte !",
                "Bravo pour l'effort \(fn) ! La prochaine sera meilleure.",
                "Tu as travaillé dur \(fn). Je suis fier de toi !"
            ]), .encouraging)

        case .streakCelebration(let days, let fn):
            return (pick([
                "\(days) jours de suite \(fn) ! Tu es fantastique !",
                "Incroyable ! \(days) jours ! \(fn), tu es mon héros !",
                "\(days) jours \(fn) ! On est une super équipe !"
            ]), .celebrating)

        case .encouragement(let fn): return (pick([
            "Allez \(fn), on peut le faire !",
            "\(fn), je crois en toi !",
            "Pas de pression \(fn), on y va doucement."
        ]), .neutral)
        }
    }

    private func pick(_ arr: [String]) -> String { arr.randomElement() ?? arr[0] }
}

// MARK: - Émotion de Léo (app primaire)
enum LeoEmotionP {
    case neutral, happy, excited, celebrating, caring, supportive, helpful, encouraging

    var emoji: String {
        switch self {
        case .neutral:     return "🧒"
        case .happy:       return "😊"
        case .excited:     return "🤩"
        case .celebrating: return "🎉"
        case .caring:      return "🤗"
        case .supportive:  return "💪"
        case .helpful:     return "💡"
        case .encouraging: return "🌟"
        }
    }

    var color: String {
        switch self {
        case .celebrating:             return "accentOrange"
        case .caring, .supportive:     return "accentPink"
        case .helpful:                 return "accentYellow"
        case .excited:                 return "accentPurple"
        default:                       return "accentGreen"
        }
    }
}

// MARK: - Bulle de dialogue Léo (app primaire)
struct LeoPrimaryBubble: View {
    @ObservedObject var leo: LeoPrimary

    var body: some View {
        if leo.showBubble {
            HStack(alignment: .bottom, spacing: 10) {
                // Avatar dessiné
                ZStack {
                    Circle()
                        .fill(Color(leo.emotion.color).opacity(0.12))
                        .frame(width: 56, height: 56)
                    LeoFaceView(isSpeaking: leo.isSpeaking,
                                accentColor: Color(leo.emotion.color))
                        .frame(width: 46, height: 46)
                }
                .scaleEffect(leo.isSpeaking ? 1.08 : 1.0)
                .animation(.easeInOut(duration: 0.45).repeatWhileTrue(leo.isSpeaking), value: leo.isSpeaking)

                // Bulle
                VStack(alignment: .leading, spacing: 4) {
                    Text("Léo")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(leo.emotion.color))
                    Text(leo.currentMessage)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                    if leo.isSpeaking {
                        HStack(spacing: 3) {
                            ForEach(0..<3) { i in
                                Circle().fill(Color(leo.emotion.color)).frame(width: 6, height: 6)
                                    .scaleEffect(leo.isSpeaking ? 1.3 : 0.7)
                                    .animation(.easeInOut(duration: 0.5).repeatForever().delay(Double(i) * 0.15),
                                               value: leo.isSpeaking)
                            }
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("cardBackground"))
                        .shadow(color: .black.opacity(0.07), radius: 8, y: 3)
                )
                Spacer()
            }
            .padding(.horizontal, 16)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .opacity
            ))
        }
    }
}

private extension Animation {
    func repeatWhileTrue(_ condition: Bool) -> Animation {
        condition ? self.repeatForever(autoreverses: true) : self
    }
}

// MARK: - Visage dessiné de Léo (SwiftUI pur, léger)
struct LeoFaceView: View {
    let isSpeaking: Bool
    let accentColor: Color

    @State private var isBlinking = false
    @State private var mouthOpen = false

    var body: some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let cx = w / 2, cy = h / 2

            // Tête — teinte peau chaude
            var headPath = Path()
            headPath.addEllipse(in: CGRect(x: 0, y: 0, width: w, height: h))
            ctx.fill(headPath, with: .color(Color(red: 0.98, green: 0.85, blue: 0.72)))
            ctx.stroke(headPath, with: .color(accentColor.opacity(0.35)), lineWidth: 1.5)

            // Joues légèrement rosées
            for dx: CGFloat in [-w * 0.23, w * 0.23] {
                var cheek = Path()
                cheek.addEllipse(in: CGRect(x: cx + dx - w * 0.10,
                                            y: cy + h * 0.08,
                                            width: w * 0.20, height: h * 0.13))
                ctx.fill(cheek, with: .color(Color(red: 1.0, green: 0.72, blue: 0.72).opacity(0.35)))
            }

            // Yeux (capsule aplatie si clignement)
            let eyeH: CGFloat = isBlinking ? 1.5 : h * 0.12
            for dx: CGFloat in [-w * 0.18, w * 0.18] {
                var eye = Path()
                eye.addRoundedRect(in: CGRect(x: cx + dx - w * 0.06,
                                              y: cy - h * 0.14 - eyeH / 2,
                                              width: w * 0.12, height: eyeH),
                                   cornerSize: CGSize(width: 3, height: 3))
                ctx.fill(eye, with: .color(Color(red: 0.20, green: 0.13, blue: 0.08)))
            }

            // Sourire (arc)
            var smile = Path()
            let smileY = cy + h * 0.12
            smile.move(to: CGPoint(x: cx - w * 0.18, y: smileY - h * 0.02))
            smile.addQuadCurve(to: CGPoint(x: cx + w * 0.18, y: smileY - h * 0.02),
                               control: CGPoint(x: cx, y: smileY + h * 0.10))
            ctx.stroke(smile, with: .color(Color(red: 0.55, green: 0.25, blue: 0.15)),
                       style: StrokeStyle(lineWidth: 1.8, lineCap: .round))

            // Bouche ouverte quand Léo parle
            if mouthOpen {
                var mouth = Path()
                mouth.addEllipse(in: CGRect(x: cx - w * 0.08, y: smileY - h * 0.01,
                                            width: w * 0.16, height: h * 0.10))
                ctx.fill(mouth, with: .color(Color(red: 0.60, green: 0.20, blue: 0.15)))
            }
        }
        .onAppear { scheduleBlink() }
        .onChange(of: isSpeaking) { speaking in
            if speaking { animateMouth() }
            else { withAnimation(.easeOut(duration: 0.15)) { mouthOpen = false } }
        }
    }

    private func scheduleBlink() {
        let delay = Double.random(in: 2.5...4.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: 0.08)) { isBlinking = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.08)) { isBlinking = false }
                scheduleBlink()
            }
        }
    }

    private func animateMouth() {
        guard isSpeaking else { return }
        withAnimation(.easeInOut(duration: 0.22)) { mouthOpen.toggle() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) { animateMouth() }
    }
}
