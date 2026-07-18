import AVFoundation
import SwiftUI

// MARK: - Léo compagnon interactif (app primaire, 3-10 ans)
@MainActor
class LeoPrimary: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    @Published var isSpeaking = false
    @Published var currentMessage = ""
    @Published var emotion: LeoEmotionP = .neutral
    @Published var showBubble = false

    private static let shared = AVSpeechSynthesizer()
    private static weak var activeDelegate: LeoPrimary?
    private var pendingUtterances = 0
    private var currentLocale: String = "fr-FR"
    private var correctStreak = 0
    private var recentPicks: [String] = []

    override init() {
        super.init()
    }

    func configure(locale: String) {
        currentLocale = locale
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

    func stop() {
        Self.shared.stopSpeaking(at: .immediate)
        pendingUtterances = 0
        isSpeaking = false
    }

    func speakText(_ text: String) {
        display(text, emotion: .neutral)
        say(text)
    }

    private func say(_ text: String) {
        Self.activeDelegate?.isSpeaking = false
        Self.activeDelegate = self
        Self.shared.delegate = self
        Self.shared.stopSpeaking(at: .immediate)
        pendingUtterances = 0

        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        guard !sentences.isEmpty else { return }
        isSpeaking = true
        pendingUtterances = sentences.count
        for (i, sentence) in sentences.enumerated() {
            let utt = AVSpeechUtterance(string: sentence)
            utt.voice = Self.preferredVoice(locale: currentLocale)
            utt.rate = 0.42
            utt.pitchMultiplier = 1.15
            utt.volume = 0.95
            utt.preUtteranceDelay = i == 0 ? 0 : 0.22
            utt.postUtteranceDelay = 0.06
            Self.shared.speak(utt)
        }
    }

    private static func preferredVoice(locale: String) -> AVSpeechSynthesisVoice? {
        let langCode = String(locale.prefix(2))
        let all = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix(langCode) }
        let femaleIds = ["marie", "amelie", "aurelie", "audrey", "florence", "ines", "pauline",
                         "juliette", "claire", "monica", "karen", "samantha", "victoria",
                         "alice", "anna", "siri_female", "sirf"]
        for id in femaleIds {
            if let v = all.first(where: { $0.identifier.lowercased().contains(id) }) { return v }
        }
        if let v = all.first(where: { $0.gender == .female }) { return v }
        let maleIds = ["thomas", "nicolas", "pierre", "daniel", "jorge", "diego", "luca", "felix", "romain", "alex"]
        if let v = all.first(where: { v in !maleIds.contains(where: { v.identifier.lowercased().contains($0) }) }) { return v }
        return all.first ?? AVSpeechSynthesisVoice(language: locale)
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
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.pendingUtterances = max(0, self.pendingUtterances - 1)
            if self.pendingUtterances == 0 { self.isSpeaking = false }
        }
    }

    // MARK: - Banque de messages (français, adapté 3-10 ans)
    private func resolve(_ ctx: Context) -> (String, LeoEmotionP) {
        switch ctx {

        case .welcome(let fn): return (pick([
            "Bonjour \(fn) ! Je suis tellement content de te voir !",
            "Salut \(fn) ! On va apprendre plein de choses ensemble !",
            "\(fn) ! Tu es là ! C'est super !",
            "Coucou \(fn) ! J'espère que tu vas bien aujourd'hui !",
            "Oh \(fn) ! Quelle belle journée pour apprendre !",
            "Bonjour bonjour \(fn) ! Je t'attendais avec impatience !",
            "Salut \(fn) ! T'es prêt(e) ? Moi je suis super impatient(e) !",
            "\(fn), tu es arrivé(e) ! La journée va être géniale !",
            "Hey \(fn) ! Ça fait plaisir de te revoir !",
            "Bienvenue \(fn) ! On va passer un super moment ensemble !"
        ]), .excited)

        case .returnAfterDays(let fn, let d):
            if d == 1 { return (pick([
                "Tu m'as manqué hier \(fn) ! Content(e) que tu sois là !",
                "Te revoilà \(fn) ! J'ai pensé à toi hier !",
                "\(fn) ! Contente de te revoir aujourd'hui !"
            ]), .caring) }
            if d <= 3 { return (pick([
                "Ça fait \(d) jours \(fn) ! J'avais vraiment hâte de te revoir !",
                "\(d) jours sans toi \(fn) ! Je suis tellement contente que tu reviennes !"
            ]), .caring) }
            return (pick([
                "Wow \(fn), ça fait longtemps ! \(d) jours ! Je suis si content(e) que tu sois là !",
                "\(fn) ! \(d) jours passés ! On reprend ensemble, pas de pression !"
            ]), .caring)

        case .moduleStart(let module, let fn): return (pick([
            "On va faire \(module) ! Tu vas adorer \(fn) !",
            "\(module) aujourd'hui \(fn) ! On y va ensemble !",
            "Prêt(e) pour \(module) ? Moi oui \(fn) !",
            "C'est l'heure de \(module) \(fn) ! J'adore cette matière !",
            "Allez \(fn), on se lance dans \(module) ! Tu vas voir c'est super !",
            "\(fn) et moi, on fait \(module) — en route !",
            "Oh j'adore \(module) ! On y va \(fn) !",
            "Aujourd'hui \(module) avec \(fn) ! Ça va être fantastique !"
        ]), .excited)

        case .correct(let streak):
            if streak >= 5 { return (pick([
                "\(streak) d'affilée ! \(streak) ! Tu es une LÉGENDE \(streak) !",
                "INCROYABLE ! \(streak) bonnes réponses ! T'es le/la meilleur(e) !",
                "WOAH \(streak) ! Je n'en reviens pas ! Tu es brillant(e) !"
            ]), .celebrating) }
            if streak >= 3 { return (pick([
                "\(streak) bonnes réponses ! Tu es une star !",
                "Wow \(streak) d'affilée ! T'es incroyable !",
                "\(streak) ! Super champion(ne) !",
                "Oh la la, \(streak) de suite ! Tu carttonnes !",
                "Tu vois ? \(streak) bonnes réponses ! Je le savais !"
            ]), .celebrating) }
            return (pick([
                "Bravo ! C'est exactement ça !",
                "Oui ! Bien joué !",
                "Super ! Tu es très fort(e) !",
                "Excellent ! Continue !",
                "Génial ! T'as tout compris !",
                "Parfait ! Tu es trop fort(e) !",
                "Wouhou ! Bonne réponse !",
                "C'est ça ! Je savais que tu pouvais !",
                "Trop bien ! Continue comme ça !",
                "Magnifique ! Tu progresses vraiment !",
                "Oh oui ! Exactement ça !",
                "Super boulot ! Je suis fière de toi !"
            ]), .happy)

        case .wrong(let attempt):
            if attempt == 1 { return (pick([
                "Presque ! On réessaie ensemble.",
                "Pas grave du tout ! Je t'aide.",
                "C'est difficile. Regarde bien !",
                "Ne t'inquiète pas — on va y arriver !",
                "Oh ! Essaie encore, tu es capable !",
                "Hmm, pas tout à fait. Réfléchis encore !",
                "Ce n'est pas grave du tout ! Regarde à nouveau.",
                "Tout le monde fait des erreurs ! Réessaie !",
                "Tu y es presque ! Une autre tentative ?",
                "Pas de panique ! On regarde ensemble."
            ]), .caring) }
            return (pick([
                "Relis doucement. La réponse est là !",
                "Je suis là avec toi. Essaie encore !",
                "Tu peux demander un indice, c'est normal !",
                "Prends ton temps. Je t'attends.",
                "Regarde bien les indices — tu vas trouver !",
                "Je crois en toi ! Une dernière tentative ?"
            ]), .supportive)

        case .hint: return (pick([
            "Je t'aide ! Voilà un indice.",
            "Bien sûr ! On est une équipe.",
            "C'est courageux de demander de l'aide !",
            "Bien sûr \\ ! Voilà un petit coup de pouce.",
            "Pas de problème ! C'est ça apprendre ensemble.",
            "Super d'avoir demandé ! Voici de l'aide.",
            "On est là pour ça ! Tiens, regarde ceci."
        ]), .helpful)

        case .sessionEnd(let correct, let total, let fn):
            let rate = total > 0 ? correct * 100 / total : 0
            if rate >= 80 { return (pick([
                "\(correct) sur \(total) \(fn) ! Tu es un génie !",
                "Magnifique \(fn) ! \(rate)% ! Je suis si fière de toi !",
                "Wow \(fn) ! Quelle super session !",
                "CHAMPION(NE) ! \(correct)/\(total) ! Tu as été fabuleux(se) \(fn) !",
                "Incroyable \(fn) ! \(rate)% — tu es une étoile !",
                "\(fn), tu as brillé aujourd'hui ! \(correct) sur \(total), bravo !"
            ]), .celebrating) }
            if rate >= 50 { return (pick([
                "\(correct) sur \(total) — bien joué \(fn) !",
                "Bonne session \(fn) ! Tu t'améliores !",
                "Super travail \(fn) ! On continue !",
                "\(fn), tu as bien travaillé ! \(correct)/\(total), pas mal du tout !",
                "Bel effort \(fn) ! Chaque session te rend plus fort(e) !",
                "C'est bien \(fn) ! On voit que tu fais des progrès !"
            ]), .happy) }
            return (pick([
                "\(fn), tu as essayé et c'est ce qui compte !",
                "Bravo pour l'effort \(fn) ! La prochaine sera meilleure.",
                "Tu as travaillé dur \(fn). Je suis fière de toi !",
                "\(fn), les erreurs font partie de l'apprentissage. Tu t'en sors !",
                "Courage \(fn) ! Chaque jour on s'améliore un peu !",
                "Ce qui compte c'est d'avoir essayé \(fn) ! Je suis fière de toi !"
            ]), .encouraging)

        case .streakCelebration(let days, let fn):
            return (pick([
                "\(days) jours de suite \(fn) ! Tu es fantastique !",
                "Incroyable ! \(days) jours ! \(fn), tu es mon héros !",
                "\(days) jours \(fn) ! On est une super équipe !",
                "Waouh \(days) jours consécutifs \(fn) ! C'est remarquable !",
                "\(fn) \(days) jours d'affilée ! Tu es si régulier(ère), je suis fière !",
                "\(days) jours sans manquer \(fn) ! Tu es extraordinaire !"
            ]), .celebrating)

        case .encouragement(let fn): return (pick([
            "Allez \(fn), on peut le faire !",
            "\(fn), je crois en toi !",
            "Pas de pression \(fn), on y va doucement.",
            "Tu es capable \(fn) ! Je suis là avec toi.",
            "\(fn), prends ton temps. On n'est pas pressé(e)s.",
            "Respire et concentre-toi \(fn) ! Tu vas y arriver.",
            "Je sais que tu peux \(fn) ! Fais confiance à toi-même.",
            "\(fn), chaque effort compte. Continue !"
        ]), .neutral)
        }
    }

    private func pick(_ arr: [String]) -> String {
        let filtered = arr.filter { !recentPicks.contains($0) }
        let chosen = (filtered.isEmpty ? arr : filtered).randomElement() ?? arr[0]
        recentPicks.append(chosen)
        if recentPicks.count > 5 { recentPicks.removeFirst() }
        return chosen
    }
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
                // Avatar photo
                LeoAvatarView(isSpeaking: leo.isSpeaking,
                              accentColor: Color(leo.emotion.color))

                // Bulle
                VStack(alignment: .leading, spacing: 4) {
                    Text(LeoAvatarView.tutorName)
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

// MARK: - Avatar photo du professeur avec animation de parole
struct LeoAvatarView: View {
    let isSpeaking: Bool
    let accentColor: Color

    /// "female" → Léa  |  "male" → Léo
    static let gender    = "female"
    static let tutorName = gender == "female" ? "Léa" : "Léo"

    private static let assetName   = gender == "female" ? "LeoAvatarFemale" : "LeoAvatarMale"
    private static let loadedImage: UIImage? = UIImage(named: assetName)

    @State private var headOffset: CGFloat = 0
    @State private var headScale: CGFloat = 1.0
    @State private var ringScale: CGFloat = 1.0
    @State private var barHeights: [CGFloat] = [4, 6, 4, 8, 4]

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Anneau pulsant
                Circle()
                    .stroke(accentColor.opacity(isSpeaking ? 0.55 : 0.20),
                            lineWidth: isSpeaking ? 3 : 1.5)
                    .frame(width: 64, height: 64)
                    .scaleEffect(ringScale)
                    .animation(
                        isSpeaking
                            ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                            : .easeOut(duration: 0.3),
                        value: ringScale
                    )

                // Photo avec légère animation de tête
                avatarContent
                    .frame(width: 58, height: 58)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: .black.opacity(0.18), radius: 5, y: 2)
                    .scaleEffect(headScale)
                    .offset(y: headOffset)
                    .animation(
                        isSpeaking
                            ? .easeInOut(duration: 0.38).repeatForever(autoreverses: true)
                            : .easeOut(duration: 0.25),
                        value: headOffset
                    )
                    .animation(
                        isSpeaking
                            ? .easeInOut(duration: 0.45).repeatForever(autoreverses: true)
                            : .easeOut(duration: 0.25),
                        value: headScale
                    )
            }

            // Barres de son animées (visibles uniquement quand il parle)
            if isSpeaking {
                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor.opacity(0.75))
                            .frame(width: 3, height: barHeights[i])
                            .animation(
                                .easeInOut(duration: Double.random(in: 0.18...0.32))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.07),
                                value: barHeights[i]
                            )
                    }
                }
                .frame(height: 12)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .onChange(of: isSpeaking) { speaking in
            if speaking {
                headOffset = -2.5
                headScale  = 1.025
                ringScale  = 1.12
                barHeights = [8, 12, 6, 14, 8]
            } else {
                headOffset = 0
                headScale  = 1.0
                ringScale  = 1.0
                barHeights = [4, 6, 4, 8, 4]
            }
        }
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let img = Self.loadedImage {
            Image(uiImage: img)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.29, green: 0.56, blue: 0.89),
                             Color(red: 0.18, green: 0.38, blue: 0.72)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Text("L")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Visage humain de Léo (prof bienveillant, SwiftUI Canvas) — GARDÉ EN FALLBACK
struct LeoFaceView: View {
    let isSpeaking: Bool
    let accentColor: Color

    @State private var isBlinking = false
    @State private var mouthOpen  = false

    var body: some View {
        Canvas { ctx, size in
            leoFaceDraw(ctx: ctx, size: size,
                        isBlinking: isBlinking, mouthOpen: mouthOpen,
                        accentColor: accentColor)
        }
        .onAppear { scheduleBlink() }
        .onChange(of: isSpeaking) { speaking in
            if speaking { animateMouth() }
            else { withAnimation(.easeOut(duration: 0.15)) { mouthOpen = false } }
        }
    }

    private func scheduleBlink() {
        let delay = Double.random(in: 2.8...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.linear(duration: 0.07)) { isBlinking = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                withAnimation(.linear(duration: 0.07)) { isBlinking = false }
                scheduleBlink()
            }
        }
    }

    private func animateMouth() {
        guard isSpeaking else { return }
        withAnimation(.easeInOut(duration: 0.20)) { mouthOpen.toggle() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) { animateMouth() }
    }
}

// Dessin du visage — fonction pure pour lisibilité
private func leoFaceDraw(ctx: GraphicsContext, size: CGSize,
                          isBlinking: Bool, mouthOpen: Bool, accentColor: Color) {
    let w = size.width, h = size.height
    let cx = w / 2

    // ── Col de chemise (derrière tout) ──
    var shirt = Path()
    shirt.move(to: CGPoint(x: cx - w*0.40, y: h))
    shirt.addLine(to: CGPoint(x: cx - w*0.16, y: h*0.88))
    shirt.addLine(to: CGPoint(x: cx - w*0.05, y: h*0.86))
    shirt.addLine(to: CGPoint(x: cx + w*0.05, y: h*0.86))
    shirt.addLine(to: CGPoint(x: cx + w*0.16, y: h*0.88))
    shirt.addLine(to: CGPoint(x: cx + w*0.40, y: h))
    shirt.closeSubpath()
    ctx.fill(shirt, with: .color(Color(red: 0.88, green: 0.92, blue: 1.0)))

    // Col stroke
    var collarL = Path()
    collarL.move(to: CGPoint(x: cx - w*0.05, y: h*0.86))
    collarL.addLine(to: CGPoint(x: cx - w*0.16, y: h*0.88))
    collarL.addLine(to: CGPoint(x: cx - w*0.40, y: h))
    var collarR = Path()
    collarR.move(to: CGPoint(x: cx + w*0.05, y: h*0.86))
    collarR.addLine(to: CGPoint(x: cx + w*0.16, y: h*0.88))
    collarR.addLine(to: CGPoint(x: cx + w*0.40, y: h))
    let collarStyle = StrokeStyle(lineWidth: max(1, w*0.025), lineCap: .round, lineJoin: .round)
    ctx.stroke(collarL, with: .color(Color(red: 0.60, green: 0.68, blue: 0.85)), style: collarStyle)
    ctx.stroke(collarR, with: .color(Color(red: 0.60, green: 0.68, blue: 0.85)), style: collarStyle)

    // ── Cou ──
    var neck = Path()
    neck.addRoundedRect(in: CGRect(x: cx - w*0.13, y: h*0.76,
                                    width: w*0.26, height: h*0.14),
                        cornerSize: .zero)
    ctx.fill(neck, with: .color(Color(red: 0.95, green: 0.80, blue: 0.66)))

    // ── Tête ──
    let headRect = CGRect(x: w*0.07, y: h*0.03, width: w*0.86, height: h*0.82)
    var head = Path()
    head.addEllipse(in: headRect)
    ctx.fill(head, with: .color(Color(red: 0.97, green: 0.83, blue: 0.68)))

    // ── Cheveux (coiffure soignée, châtain foncé) ──
    // Masse principale
    var hairMass = Path()
    hairMass.addEllipse(in: CGRect(x: w*0.08, y: h*0.03, width: w*0.84, height: h*0.44))
    ctx.fill(hairMass, with: .color(Color(red: 0.28, green: 0.17, blue: 0.07)))

    // Raie légère sur le côté gauche
    var parting = Path()
    parting.move(to: CGPoint(x: cx - w*0.08, y: h*0.03))
    parting.addQuadCurve(to: CGPoint(x: cx - w*0.12, y: h*0.28),
                          control: CGPoint(x: cx - w*0.14, y: h*0.14))
    ctx.stroke(parting, with: .color(Color(red: 0.97, green: 0.83, blue: 0.68).opacity(0.45)),
               style: StrokeStyle(lineWidth: max(1, w*0.025), lineCap: .round))

    // Mèches latérales
    for sign: CGFloat in [-1, 1] {
        var sideHair = Path()
        let sx: CGFloat = sign < 0 ? w*0.07 : w*0.93
        let mx: CGFloat = sign < 0 ? w*0.04 : w*0.96
        sideHair.move(to: CGPoint(x: sx, y: h*0.25))
        sideHair.addQuadCurve(to: CGPoint(x: sx, y: h*0.46),
                               control: CGPoint(x: mx, y: h*0.36))
        ctx.stroke(sideHair, with: .color(Color(red: 0.28, green: 0.17, blue: 0.07)),
                   style: StrokeStyle(lineWidth: max(2, w*0.09), lineCap: .round))
    }

    // ── Joues rosées ──
    for sign: CGFloat in [-1, 1] {
        var cheek = Path()
        cheek.addEllipse(in: CGRect(x: cx + sign*w*0.22 - w*0.11,
                                    y: h*0.54,
                                    width: w*0.22, height: h*0.14))
        ctx.fill(cheek, with: .color(Color(red: 1.0, green: 0.72, blue: 0.68).opacity(0.30)))
    }

    // ── Sourcils (expressifs) ──
    let browY = h * 0.41
    for sign: CGFloat in [-1, 1] {
        let bcx = cx + sign * w*0.22
        var brow = Path()
        brow.move(to: CGPoint(x: bcx - w*0.12, y: browY + h*0.01))
        brow.addQuadCurve(to: CGPoint(x: bcx + w*0.12, y: browY),
                           control: CGPoint(x: bcx, y: browY - h*0.028))
        ctx.stroke(brow, with: .color(Color(red: 0.23, green: 0.14, blue: 0.05)),
                   style: StrokeStyle(lineWidth: max(1.5, w*0.038), lineCap: .round))
    }

    // ── Yeux ──
    let eyeY   = h * 0.52
    let eyeW   = w * 0.20
    let eyeH   : CGFloat = isBlinking ? max(1.0, h*0.015) : h*0.13

    for sign: CGFloat in [-1, 1] {
        let ecx = cx + sign * w*0.22
        let eyeRect = CGRect(x: ecx - eyeW/2, y: eyeY - eyeH/2, width: eyeW, height: eyeH)

        // Blanc de l'œil
        var sclera = Path(); sclera.addEllipse(in: eyeRect)
        ctx.fill(sclera, with: .color(.white))

        if !isBlinking {
            // Iris (marron chaud)
            let ir = min(eyeW, eyeH) * 0.44
            var iris = Path()
            iris.addEllipse(in: CGRect(x: ecx - ir, y: eyeY - ir, width: ir*2, height: ir*2))
            ctx.fill(iris, with: .color(Color(red: 0.42, green: 0.26, blue: 0.10)))

            // Pupille
            let pr = ir * 0.54
            var pupil = Path()
            pupil.addEllipse(in: CGRect(x: ecx - pr, y: eyeY - pr, width: pr*2, height: pr*2))
            ctx.fill(pupil, with: .color(.black))

            // Reflet lumineux
            var glint = Path()
            glint.addEllipse(in: CGRect(x: ecx - ir*0.22, y: eyeY - ir*0.50,
                                         width: ir*0.34, height: ir*0.34))
            ctx.fill(glint, with: .color(.white.opacity(0.90)))
        }

        // Contour paupière
        var lid = Path(); lid.addEllipse(in: eyeRect.insetBy(dx: -0.5, dy: -0.5))
        ctx.stroke(lid, with: .color(Color(red: 0.18, green: 0.10, blue: 0.04)),
                   lineWidth: max(1.0, w*0.030))
    }

    // ── Nez (discret) ──
    let noseBaseY = h * 0.66
    var noseBridge = Path()
    noseBridge.move(to: CGPoint(x: cx + w*0.01, y: eyeY + h*0.07))
    noseBridge.addQuadCurve(to: CGPoint(x: cx - w*0.04, y: noseBaseY),
                             control: CGPoint(x: cx - w*0.07, y: noseBaseY - h*0.04))
    ctx.stroke(noseBridge, with: .color(Color(red: 0.72, green: 0.52, blue: 0.40).opacity(0.55)),
               style: StrokeStyle(lineWidth: 0.9, lineCap: .round))

    for sign: CGFloat in [-1, 1] {
        var nostril = Path()
        nostril.addEllipse(in: CGRect(x: cx + sign*w*0.055 - w*0.025,
                                      y: noseBaseY - h*0.008,
                                      width: w*0.05, height: h*0.028))
        ctx.fill(nostril, with: .color(Color(red: 0.65, green: 0.45, blue: 0.35).opacity(0.50)))
    }

    // ── Bouche ──
    let mouthY = h * 0.77
    let lipColor = Color(red: 0.75, green: 0.38, blue: 0.28)
    let lipStyle = StrokeStyle(lineWidth: max(1.5, w*0.032), lineCap: .round)

    if !mouthOpen {
        // Sourire chaleureux (lèvres fermées)
        var smile = Path()
        smile.move(to: CGPoint(x: cx - w*0.16, y: mouthY))
        smile.addQuadCurve(to: CGPoint(x: cx + w*0.16, y: mouthY),
                            control: CGPoint(x: cx, y: mouthY + h*0.07))
        ctx.stroke(smile, with: .color(lipColor), style: lipStyle)

        // Petites fossettes
        for sign: CGFloat in [-1, 1] {
            var dimple = Path()
            let dx = cx + sign * w*0.175
            dimple.addEllipse(in: CGRect(x: dx - w*0.018, y: mouthY - h*0.005,
                                          width: w*0.036, height: h*0.028))
            ctx.fill(dimple, with: .color(Color(red: 0.85, green: 0.65, blue: 0.55).opacity(0.40)))
        }
    } else {
        // Bouche ouverte en train de parler
        var mouthPath = Path()
        mouthPath.move(to: CGPoint(x: cx - w*0.15, y: mouthY))
        mouthPath.addQuadCurve(to: CGPoint(x: cx + w*0.15, y: mouthY),
                                control: CGPoint(x: cx, y: mouthY + h*0.10))
        mouthPath.addQuadCurve(to: CGPoint(x: cx - w*0.15, y: mouthY),
                                control: CGPoint(x: cx, y: mouthY + h*0.01))
        mouthPath.closeSubpath()
        ctx.fill(mouthPath, with: .color(Color(red: 0.52, green: 0.14, blue: 0.14)))

        // Dents
        var teeth = Path()
        teeth.addRoundedRect(in: CGRect(x: cx - w*0.12, y: mouthY + h*0.004,
                                         width: w*0.24, height: h*0.038),
                             cornerSize: CGSize(width: 2, height: 2))
        ctx.fill(teeth, with: .color(Color(red: 0.97, green: 0.97, blue: 0.97)))

        // Lèvres
        ctx.stroke(mouthPath, with: .color(lipColor), style: lipStyle)
    }
}
