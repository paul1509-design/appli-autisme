import SwiftUI
import Combine

// MARK: - Service abonnement (même logique que l'app primaire)
class CollegeSubscriptionService: ObservableObject {
    @Published var isSubscribed: Bool = false
    @Published var trialDaysRemaining: Int = 21
    @Published var trialExpired: Bool = false

    private let trialStartKey = "collegeTrialStartDate"
    private let subscriptionKey = "collegeIsSubscribed"

    func checkSubscriptionStatus() {
        isSubscribed = UserDefaults.standard.bool(forKey: subscriptionKey)
        if isSubscribed { return }

        if let startDate = UserDefaults.standard.object(forKey: trialStartKey) as? Date {
            let daysPassed = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
            trialDaysRemaining = max(0, 21 - daysPassed)
            trialExpired = trialDaysRemaining <= 0
        } else {
            UserDefaults.standard.set(Date(), forKey: trialStartKey)
            trialDaysRemaining = 21
        }
    }

    func purchaseLifetime() async {
        await MainActor.run {
            isSubscribed = true
            UserDefaults.standard.set(true, forKey: subscriptionKey)
        }
    }

    func restorePurchases() async {
        await MainActor.run {
            isSubscribed = UserDefaults.standard.bool(forKey: subscriptionKey)
        }
    }
}

// MARK: - Paywall ABA Homeschooling Ado
struct CollegePaywallView: View {
    @EnvironmentObject var sub: CollegeSubscriptionService
    @EnvironmentObject var appState: CollegeAppState
    @State private var isPurchasing = false
    @State private var showRestoreConfirm = false

    var isTrialActive: Bool { !sub.trialExpired }
    var daysLeft: Int { sub.trialDaysRemaining }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // Bandeau
                if isTrialActive {
                    HStack(spacing: 8) {
                        Text("⏳")
                        Text("Essai gratuit — encore \(daysLeft) jour\(daysLeft > 1 ? "s" : "")")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                        Button("Continuer gratuitement") { appState.screen = .home }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                            .underline()
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                    .background(Color("accentOrange"))
                } else {
                    HStack(spacing: 8) {
                        Text("🔒")
                        Text("Votre essai de 21 jours est terminé")
                            .font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                    .background(Color.red.opacity(0.85))
                }

                // Hero
                VStack(spacing: 14) {
                    Text("🎓").font(.system(size: 52)).padding(.top, 36)
                    Text("ABA Homeschooling Ado")
                        .font(.system(size: 24, weight: .medium)).foregroundColor(Color("textPrimary"))
                    Text(isTrialActive
                         ? "Débloquez l'accès complet 11-18 ans à vie."
                         : "Votre ado a besoin de continuer son programme.")
                        .font(.system(size: 15)).foregroundColor(Color("textSecondary"))
                        .multilineTextAlignment(.center).lineSpacing(4)
                }
                .padding(.horizontal, 32)

                // Prix
                VStack(spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("149 €").font(.system(size: 44, weight: .medium)).foregroundColor(Color("textPrimary"))
                        Text("une fois").font(.system(size: 16)).foregroundColor(Color("textSecondary"))
                    }
                    Text("Accès à vie — aucun abonnement — 6ème à Terminale")
                        .font(.system(size: 13, weight: .medium)).foregroundColor(Color("accentGreen"))
                        .multilineTextAlignment(.center)
                    HStack(spacing: 8) {
                        CollegeComparisonPill(label: "vs cours particuliers 30 €/h")
                        CollegeComparisonPill(label: "vs AESH 800 €/an")
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24).padding(.top, 24)

                // Bloc valeur pédagogique
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pourquoi 149 € est un investissement rationnel")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(Color("textPrimary"))
                    VStack(alignment: .leading, spacing: 7) {
                        CollegeValueRow(icon: "eurosign.circle", text: "1 heure de cours particuliers = 30 €. ABA Ado = 5 heures d'équivalent.")
                        CollegeValueRow(icon: "graduationcap", text: "Programme 6ème → Terminale : 7 années scolaires couvertes (français, maths, anglais, histoire, sciences).")
                        CollegeValueRow(icon: "brain.head.profile", text: "Méthode ABA adaptée à l'adolescent TSA — progression par renforcement positif, sans pression scolaire.")
                        CollegeValueRow(icon: "chart.line.uptrend.xyaxis", text: "Communication sociale TSA intégrée : module unique introuvable dans les programmes standards.")
                        CollegeValueRow(icon: "arrow.clockwise", text: "Accès à vie — votre investissement suit votre ado jusqu'au bac.")
                    }
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color("accentGreen").opacity(0.07))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("accentGreen").opacity(0.2), lineWidth: 0.5)))
                .padding(.horizontal, 20).padding(.top, 16)

                // Bouton
                Button {
                    isPurchasing = true
                    Task {
                        await sub.purchaseLifetime()
                        isPurchasing = false
                        if sub.isSubscribed { appState.screen = .home }
                    }
                } label: {
                    HStack(spacing: 10) {
                        if isPurchasing { ProgressView().tint(.white) }
                        else {
                            Image(systemName: "lock.open.fill").font(.system(size: 16))
                            Text("Débloquer — 149 €").font(.system(size: 18, weight: .medium))
                        }
                    }
                    .foregroundColor(.white).frame(maxWidth: .infinity).frame(height: 58)
                    .background(LinearGradient(colors: [Color("accentPurple"), Color("accentPurple").opacity(0.82)],
                                               startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(18)
                    .shadow(color: Color("accentPurple").opacity(0.35), radius: 12, y: 4)
                }
                .disabled(isPurchasing)
                .padding(.horizontal, 24).padding(.top, 20)

                Button {
                    Task {
                        await sub.restorePurchases()
                        showRestoreConfirm = true
                    }
                } label: {
                    Text("Restaurer un achat").font(.system(size: 14))
                        .foregroundColor(Color("textSecondary")).underline()
                }
                .padding(.top, 12)
                .alert("Achat restauré", isPresented: $showRestoreConfirm) {
                    Button("OK") { if sub.isSubscribed { appState.screen = .home } }
                } message: {
                    Text(sub.isSubscribed ? "Accès restauré avec succès." : "Aucun achat trouvé sur ce compte.")
                }

                // Inclus
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ce qui est inclus")
                        .font(.system(size: 15, weight: .medium)).foregroundColor(Color("textPrimary"))
                        .padding(.bottom, 12)
                    VStack(spacing: 10) {
                        CollegePaywallFeature(emoji: "🎓", text: "6ème → Terminale — 7 niveaux")
                        CollegePaywallFeature(emoji: "📚", text: "6 matières dont Communication sociale TSA")
                        CollegePaywallFeature(emoji: "🧠", text: "Méthode ABA adaptée à l'adolescent")
                        CollegePaywallFeature(emoji: "📊", text: "Dashboard parents avec suivi par matière")
                        CollegePaywallFeature(emoji: "⏱️", text: "Sessions 15-20 min avec timer visible")
                        CollegePaywallFeature(emoji: "🔄", text: "Mises à jour incluses à vie")
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color("cardBackground"))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color("borderLight"), lineWidth: 0.5)))
                .padding(.horizontal, 20).padding(.top, 28)

                // Témoignage
                VStack(alignment: .leading, spacing: 8) {
                    Text("❝").font(.system(size: 28)).foregroundColor(Color("accentPurple").opacity(0.4))
                    Text("Lucas a décroché en 5ème. ABA Homeschooling Ado lui permet de garder le contact avec les maths et l'anglais. Il n'est plus en décrochage total.")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(Color("textPrimary")).lineSpacing(4)
                    Text("— Isabelle, maman de Lucas (14 ans, TSA niveau 1)")
                        .font(.system(size: 12)).foregroundColor(Color("textSecondary"))
                }
                .padding(18)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color("accentPurple").opacity(0.06)))
                .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 48)
            }
        }
        .background(Color("backgroundSoft").ignoresSafeArea())
    }
}

struct CollegeComparisonPill: View {
    let label: String
    var body: some View {
        Text(label).font(.system(size: 10, weight: .medium))
            .strikethrough().foregroundColor(Color("textSecondary"))
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color("cardBackground")).cornerRadius(20)
    }
}

struct CollegePaywallFeature: View {
    let emoji: String; let text: String
    var body: some View {
        HStack(spacing: 12) {
            Text(emoji).font(.system(size: 18))
            Text(text).font(.system(size: 14)).foregroundColor(Color("textPrimary"))
            Spacer()
            Image(systemName: "checkmark").font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("accentGreen"))
        }
    }
}

struct CollegeValueRow: View {
    let icon: String; let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.system(size: 13)).foregroundColor(Color("accentGreen")).frame(width: 18)
            Text(text).font(.system(size: 12)).foregroundColor(Color("textSecondary")).lineSpacing(3)
        }
    }
}

// MARK: - Bannière trial (dans CollegeHomeView)
struct CollegeTrialBanner: View {
    let daysLeft: Int
    let onUpgrade: () -> Void

    var body: some View {
        Button(action: onUpgrade) {
            HStack(spacing: 10) {
                Text(daysLeft <= 2 ? "🔴" : "🟡")
                Text(daysLeft == 0
                     ? "Essai expiré aujourd'hui !"
                     : "Essai : encore \(daysLeft) jour\(daysLeft > 1 ? "s" : "")")
                    .font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                Spacer()
                Text("Débloquer").font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white).padding(.horizontal, 10).padding(.vertical, 4)
                    .background(.white.opacity(0.25)).cornerRadius(8)
            }
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(daysLeft <= 2 ? Color.red.opacity(0.85) : Color("accentOrange"))
        }
        .padding(.horizontal, 20)
    }
}
