import AVFoundation
import SwiftUI
import SwiftData
import Combine

// MARK: - Service synthèse vocale (orthophoniste)
class SpeechService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    nonisolated(unsafe) private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking: Bool = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, language: String = "fr-FR", rate: Float = 0.45) {
        // Arrêter si déjà en train de parler
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate         // lent pour TSA
        utterance.pitchMultiplier = 1.1
        utterance.volume = 0.9
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func speakSlowly(_ text: String, language: String = "fr-FR") {
        speak(text, language: language, rate: 0.35)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                            didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

// MARK: - Service abonnements StoreKit 2
import StoreKit

@MainActor
class SubscriptionService: ObservableObject {
    static let productID = "com.abalearning.autilearn.lifetime"

    @Published var isSubscribed: Bool = false
    @Published var trialDaysRemaining: Int = 21
    @Published var trialExpired: Bool = false
    @Published var product: Product? = nil
    @Published var isPurchasing: Bool = false
    @Published var purchaseError: String? = nil

    private let trialStartKey = "trialStartDate"
    private let subscriptionKey = "isSubscribed"
    private var transactionListenerTask: Task<Void, Never>?

    init() {
        transactionListenerTask = listenForTransactions()
        Task { await loadProduct() }
    }

    deinit { transactionListenerTask?.cancel() }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            self.product = products.first
        } catch { }
    }

    func checkSubscriptionStatus() {
        if UserDefaults.standard.bool(forKey: subscriptionKey) {
            isSubscribed = true; return
        }
        if let startDate = UserDefaults.standard.object(forKey: trialStartKey) as? Date {
            let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
            trialDaysRemaining = max(0, 21 - daysPassed)
            trialExpired = trialDaysRemaining <= 0
        } else {
            UserDefaults.standard.set(Date(), forKey: trialStartKey)
            trialDaysRemaining = 21
        }
        Task { await verifyEntitlement() }
    }

    func verifyEntitlement() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result, tx.productID == Self.productID,
               tx.revocationDate == nil {
                isSubscribed = true
                UserDefaults.standard.set(true, forKey: subscriptionKey)
                return
            }
        }
    }

    func purchaseLifetime() async {
        guard let product else {
            purchaseError = "Produit non disponible. Vérifiez votre connexion."
            return
        }
        isPurchasing = true
        purchaseError = nil
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                guard case .verified(let transaction) = verification else {
                    purchaseError = "Transaction non vérifiée."; return
                }
                await transaction.finish()
                isSubscribed = true
                UserDefaults.standard.set(true, forKey: subscriptionKey)
            case .userCancelled: break
            case .pending:
                purchaseError = "Achat en attente (contrôle parental activé)."
            @unknown default: break
            }
        } catch StoreKitError.userCancelled {
        } catch {
            purchaseError = "Erreur : \(error.localizedDescription)"
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await verifyEntitlement()
        } catch {
            purchaseError = "Restauration échouée : \(error.localizedDescription)"
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let tx) = result {
                    await tx.finish()
                    await self?.verifyEntitlement()
                }
            }
        }
    }

    var formattedPrice: String { product?.displayPrice ?? "199,99 €" }
}

// MARK: - Exercice de respiration (cohérence cardiaque)
struct BreathingExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var phase: BreathingPhase = .inhale
    @State private var circleScale: CGFloat = 0.6
    @State private var progress: Double = 0
    @State private var cycles: Int = 0
    @State private var isRunning: Bool = false

    let totalCycles = 5  // 5 cycles = ~3 minutes

    enum BreathingPhase: String {
        case inhale  = "Inspire..."
        case hold    = "Retiens..."
        case exhale  = "Expire..."
        case pause   = "Pause..."
    }

    var body: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Text("🌬️")
                    .font(.system(size: 48))

                Text("Respirons ensemble")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("textPrimary"))

                // Cercle animé
                ZStack {
                    Circle()
                        .fill(Color("accentBlue").opacity(0.08))
                        .frame(width: 200, height: 200)
                    Circle()
                        .fill(Color("accentBlue").opacity(0.15))
                        .frame(width: 200, height: 200)
                        .scaleEffect(circleScale)
                        .animation(.easeInOut(duration: phaseDuration), value: circleScale)

                    Text(phase.rawValue)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color("accentBlue"))
                }

                // Progression
                Text("\(cycles) / \(totalCycles) cycles")
                    .font(.system(size: 15))
                    .foregroundColor(Color("textSecondary"))

                if !isRunning {
                    Button {
                        isRunning = true
                        startBreathing()
                    } label: {
                        Text("Commencer")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color("accentBlue"))
                            .cornerRadius(14)
                    }
                }

                Spacer()

                Button("Terminer") { dismiss() }
                    .font(.system(size: 15))
                    .foregroundColor(Color("textSecondary"))
                    .padding(.bottom, 32)
            }
        }
    }

    private var phaseDuration: Double {
        switch phase {
        case .inhale:  return 4.0
        case .hold:    return 2.0
        case .exhale:  return 6.0
        case .pause:   return 2.0
        }
    }

    private func startBreathing() {
        runCycle()
    }

    private func runCycle() {
        guard cycles < totalCycles else {
            isRunning = false
            return
        }

        // Inspire (4s)
        phase = .inhale
        circleScale = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            // Retiens (2s)
            phase = .hold
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Expire (6s)
                phase = .exhale
                circleScale = 0.6
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    // Pause (2s)
                    phase = .pause
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        cycles += 1
                        runCycle()
                    }
                }
            }
        }
    }
}

// MARK: - Sélecteur d'enfant
struct ChildSelectorView: View {
    @Query var children: [ChildProfile]
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Qui apprend aujourd'hui ?")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .padding(.top, 32)

                    ForEach(children) { child in
                        ChildCard(child: child)
                            .onTapGesture {
                                appState.selectChild(child)
                            }
                    }

                    // Ajouter un enfant
                    Button {
                        appState.currentScreen = .onboarding
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color("accentPurple"))
                            Text("Ajouter un enfant")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("accentPurple"))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("accentPurple").opacity(0.4),
                                        style: StrokeStyle(lineWidth: 1, dash: [6]))
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color("backgroundSoft"))
            .navigationBarHidden(true)
        }
    }
}

struct ChildCard: View {
    let child: ChildProfile

    var body: some View {
        HStack(spacing: 16) {
            AvatarCircle(name: child.avatarName, size: 56, isSelected: false)

            VStack(alignment: .leading, spacing: 4) {
                Text(child.firstName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                HStack(spacing: 6) {
                    Text(child.schoolLevel.emoji)
                    Text(child.schoolLevel.displayName)
                        .font(.system(size: 14))
                        .foregroundColor(Color("textSecondary"))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("⭐️ \(child.totalStars)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("accentOrange"))
                Text("🔥 \(child.currentStreak)j")
                    .font(.system(size: 13))
                    .foregroundColor(Color("textSecondary"))
            }

            Image(systemName: "chevron.right")
                .foregroundColor(Color("textSecondary"))
                .font(.system(size: 13))
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Service de notifications quotidiennes
import UserNotifications

struct ABANotificationService {

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    static func scheduleDailyReminder(childName: String, hour: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["aba_daily_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "C'est l'heure de la session de \(childName) ! 🌟"
        content.body  = "15 minutes par jour font toute la différence. Bonne séance ! 💪"
        content.sound = .default
        content.badge = 1

        var components = DateComponents()
        components.hour   = hour
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "aba_daily_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    static func cancelReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["aba_daily_reminder"])
    }
}

// MARK: - Génération rapport PDF (app primaire)
import PDFKit

struct ABAProgressPDFReport {

    static func generate(for child: ChildProfile) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { ctx in
            ctx.beginPage()
            draw(ctx: ctx.cgContext, rect: pageRect, child: child)
        }
    }

    private static func draw(ctx: CGContext, rect: CGRect, child: ChildProfile) {
        let margin: CGFloat = 48
        var y: CGFloat = margin

        // En-tête
        ctx.setFillColor(UIColor(red: 0.30, green: 0.47, blue: 0.90, alpha: 1).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: rect.width, height: 100))

        let titleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.white
        ]
        "ABA Homeschooling — Rapport de progression".draw(at: CGPoint(x: margin, y: 20), withAttributes: titleAttr)
        let subAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white.withAlphaComponent(0.85)
        ]
        let dateStr = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        "Enfant : \(child.firstName)  •  Niveau : \(child.schoolLevel.displayName)  •  \(dateStr)".draw(
            at: CGPoint(x: margin, y: 52), withAttributes: subAttr)

        y = 120

        // Résumé
        y = drawSection(ctx: ctx, title: "Résumé global", y: y, margin: margin, pageWidth: rect.width)

        let totalSessions = child.sessions.count
        let totalMinutes  = child.sessions.reduce(0) { $0 + $1.durationSeconds } / 60
        let avgSuccess    = child.sessions.isEmpty ? 0.0 :
            child.sessions.reduce(0.0) { $0 + $1.successRate } / Double(child.sessions.count)
        let mastered  = child.wordProgresses.filter { $0.masteryLevel == .mastered }.count
        let inProgress = child.wordProgresses.filter { $0.masteryLevel == .learning || $0.masteryLevel == .reviewing }.count

        for (label, value) in [
            ("Sessions totales", "\(totalSessions)"),
            ("Temps total", "\(totalMinutes) min"),
            ("Taux de réussite moyen", "\(Int(avgSuccess * 100)) %"),
            ("Étoiles gagnées", "\(child.totalStars) ⭐️"),
            ("Série actuelle", "\(child.currentStreak) jours 🔥"),
            ("Mots maîtrisés", "\(mastered) ⭐️"),
            ("Mots en cours", "\(inProgress) 📚"),
        ] {
            y = drawRow(ctx: ctx, label: label, value: value, y: y, margin: margin, pageWidth: rect.width)
        }

        // Pied de page
        let footerAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.gray
        ]
        "Rapport généré par ABA Homeschooling — Méthode ABA adaptée TSA".draw(
            at: CGPoint(x: margin, y: 810), withAttributes: footerAttr)
    }

    @discardableResult
    private static func drawSection(ctx: CGContext, title: String, y: CGFloat, margin: CGFloat, pageWidth: CGFloat) -> CGFloat {
        ctx.setFillColor(UIColor(red: 0.93, green: 0.95, blue: 1.0, alpha: 1).cgColor)
        ctx.fill(CGRect(x: margin - 8, y: y, width: pageWidth - margin * 2 + 16, height: 26))
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: UIColor(red: 0.30, green: 0.47, blue: 0.90, alpha: 1)
        ]
        title.draw(at: CGPoint(x: margin, y: y + 6), withAttributes: attr)
        return y + 36
    }

    @discardableResult
    private static func drawRow(ctx: CGContext, label: String, value: String, y: CGFloat, margin: CGFloat, pageWidth: CGFloat) -> CGFloat {
        let lAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.darkGray]
        let vAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.black]
        label.draw(at: CGPoint(x: margin, y: y), withAttributes: lAttr)
        let vx = pageWidth - margin - CGFloat(value.count) * 6.5
        value.draw(at: CGPoint(x: max(vx, margin + 200), y: y), withAttributes: vAttr)
        ctx.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.4).cgColor)
        ctx.setLineWidth(0.4)
        ctx.move(to: CGPoint(x: margin, y: y + 18))
        ctx.addLine(to: CGPoint(x: pageWidth - margin, y: y + 18))
        ctx.strokePath()
        return y + 24
    }
}

// MARK: - Bouton export PDF (app primaire)
struct ABAPDFShareButton: View {
    let child: ChildProfile

    private var pdfURL: URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("rapport_\(child.firstName).pdf")
        let data = ABAProgressPDFReport.generate(for: child)
        try? data.write(to: url)
        return url
    }

    var body: some View {
        ShareLink(item: pdfURL) {
            HStack(spacing: 10) {
                Image(systemName: "doc.richtext").font(.system(size: 16))
                Text("Exporter rapport PDF").font(.system(size: 15, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity).frame(height: 48)
            .background(Color("accentBlue")).cornerRadius(14)
        }
    }
}

// MARK: - Avis App Store + Exercice bonus
import StoreKit

struct ABAReviewService {
    private static let reviewRequestedKey = "abaReviewRequested"
    static let bonusUnlockedKey = "abaBonusUnlocked"

    static func checkAndRequestReview(totalSessions: Int, scene: UIWindowScene?) {
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

// MARK: - Modal déblocage exercice bonus (app primaire)
struct ABABonusUnlockView: View {
    @Binding var isPresented: Bool
    let childName: String
    @State private var bonusUnlocked = ABAReviewService.isBonusUnlocked
    @State private var countdown: Int = 10
    @State private var timerStarted = false
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 0) {
            Text("🎁").font(.system(size: 56)).padding(.top, 36)
            Text("Jeu bonus spécial")
                .font(.system(size: 22, weight: .semibold)).foregroundColor(Color("textPrimary"))
            Text("Débloquez le Mot Mystère pour \(childName) !")
                .font(.system(size: 14)).foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center).padding(.horizontal, 28).padding(.top, 6)

            VStack(alignment: .leading, spacing: 10) {
                BonusRowPrimary(emoji: "🔤", text: "Mot mystère — retrouvez le mot lettre par lettre")
                BonusRowPrimary(emoji: "🌟", text: "Adapté au niveau de l'enfant automatiquement")
                BonusRowPrimary(emoji: "🎵", text: "Chaque bonne lettre = animation + son joyeux")
                BonusRowPrimary(emoji: "🔓", text: "Débloqué définitivement après votre avis")
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color("accentBlue").opacity(0.07)))
            .padding(.horizontal, 24).padding(.top, 20)

            if bonusUnlocked {
                VStack(spacing: 10) {
                    Text("✅ Jeu bonus déjà débloqué !").font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentGreen"))
                    Button("Jouer") { isPresented = false }
                        .font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .background(Color("accentGreen")).cornerRadius(16)
                }
                .padding(.horizontal, 24).padding(.top, 20)
            } else {
                VStack(spacing: 12) {
                    Text("Laissez un avis ⭐️⭐️⭐️⭐️⭐️\n(10 secondes !)")
                        .font(.system(size: 14)).foregroundColor(Color("textPrimary"))
                        .multilineTextAlignment(.center).lineSpacing(4).padding(.top, 16)

                    if !timerStarted {
                        Button {
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                            timerStarted = true
                            countdown = 10
                            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
                                if countdown > 0 { countdown -= 1 } else { t.invalidate() }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                Text("Laisser un avis").font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 52)
                            .background(Color("accentBlue")).cornerRadius(16)
                        }
                    } else if countdown > 0 {
                        ProgressView(value: Double(10 - countdown), total: 10).tint(Color("accentBlue"))
                        Text("Déblocage dans \(countdown)s…").font(.system(size: 13))
                            .foregroundColor(Color("textSecondary"))
                    } else {
                        VStack(spacing: 10) {
                            Text("🎉 Merci ! Jeu bonus débloqué !").font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("accentGreen"))
                            Button("Jouer") {
                                ABAReviewService.isBonusUnlocked = true
                                bonusUnlocked = true
                                isPresented = false
                            }
                            .font(.system(size: 17, weight: .medium)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .background(Color("accentGreen")).cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            Button("Plus tard") { isPresented = false }
                .font(.system(size: 14)).foregroundColor(Color("textSecondary"))
                .padding(.top, 16).padding(.bottom, 32)
        }
        .background(Color("backgroundSoft"))
        .presentationDetents([.medium, .large])
        .onDisappear { timer?.invalidate() }
    }
}

private struct BonusRowPrimary: View {
    let emoji: String; let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(emoji).font(.system(size: 16))
            Text(text).font(.system(size: 13)).foregroundColor(Color("textPrimary")).lineSpacing(3)
        }
    }
}
