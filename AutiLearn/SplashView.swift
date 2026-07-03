import SwiftUI

// MARK: - Premier écran marketing (parents)
struct SplashView: View {
    let onGetStarted: () -> Void
    @State private var logoScale: CGFloat = 0.7
    @State private var contentOpacity: Double = 0
    @State private var badgesOpacity: Double = 0

    var body: some View {
        ZStack {
            // Gradient fond doux
            LinearGradient(
                colors: [Color("accentPurple").opacity(0.12), Color("backgroundSoft")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Hero
                    VStack(spacing: 20) {
                        Spacer().frame(height: 48)

                        // Logo + titre
                        ZStack {
                            Circle()
                                .fill(Color("accentPurple").opacity(0.12))
                                .frame(width: 110, height: 110)
                            Text("🌟")
                                .font(.system(size: 64))
                        }
                        .scaleEffect(logoScale)
                        .animation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1),
                                   value: logoScale)

                        VStack(spacing: 8) {
                            Text("ABA Kids")
                                .font(.system(size: 34, weight: .medium))
                                .foregroundColor(Color("textPrimary"))

                            Text("Créée par des spécialistes de l'autisme")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("accentPurple"))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .opacity(contentOpacity)

                    // MARK: Accroche principale
                    VStack(spacing: 16) {
                        Text("L'application qui s'adapte\nau rythme de votre enfant")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        Text("Votre enfant autiste mérite un parcours académique pensé pour lui — sans pression, sans jugement, avec les meilleurs outils éducatifs de la méthode ABA.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("textSecondary"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 32)
                    .opacity(contentOpacity)

                    // MARK: Badges de confiance
                    HStack(spacing: 10) {
                        TrustBadge(emoji: "🔬", text: "Validé\nABA")
                        TrustBadge(emoji: "🌍", text: "8\nlangues")
                        TrustBadge(emoji: "🎯", text: "Adapté\nTSA")
                        TrustBadge(emoji: "📊", text: "Suivi\nparents")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .opacity(badgesOpacity)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: badgesOpacity)

                    // MARK: Points forts
                    VStack(spacing: 12) {
                        SplashFeature(
                            emoji: "🗣️",
                            title: "Parole en priorité",
                            description: "Le personnage Léo parle avec votre enfant. Il répète, il répond — à son rythme.",
                            color: "accentOrange"
                        )
                        SplashFeature(
                            emoji: "📐",
                            title: "Programme scolaire complet",
                            description: "De la maternelle au CM2 : lecture, écriture, maths, sciences — tout le curriculum national.",
                            color: "accentPurple"
                        )
                        SplashFeature(
                            emoji: "🧠",
                            title: "Méthode ABA structurée",
                            description: "Hiérarchie de prompts, renforcement positif, révision espacée — comme avec un thérapeute.",
                            color: "accentBlue"
                        )
                        SplashFeature(
                            emoji: "📊",
                            title: "Tableau de bord parents",
                            description: "Suivez chaque compétence acquise, les taux de réussite et les mots maîtrisés semaine après semaine.",
                            color: "accentGreen"
                        )
                        SplashFeature(
                            emoji: "⭐️",
                            title: "Récompenses & motivation",
                            description: "Après 10 étoiles : une pause de 5 minutes avec des jeux et mini-films éducatifs.",
                            color: "accentYellow"
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .opacity(contentOpacity)

                    // MARK: Témoignage fictif (à remplacer en prod)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("❝")
                            .font(.system(size: 36))
                            .foregroundColor(Color("accentPurple").opacity(0.4))
                        Text("Mon fils ne répétait aucun mot. En 3 semaines avec ABA Kids, il dit bonjour et merci chaque jour.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .lineSpacing(4)
                        Text("— Marie, maman de Lucas (5 ans)")
                            .font(.system(size: 13))
                            .foregroundColor(Color("textSecondary"))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("accentPurple").opacity(0.07))
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("accentPurple").opacity(0.15), lineWidth: 0.5))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .opacity(contentOpacity)

                    // MARK: CTA
                    VStack(spacing: 14) {
                        Button(action: onGetStarted) {
                            HStack(spacing: 10) {
                                Text("Commencer gratuitement")
                                    .font(.system(size: 18, weight: .medium))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color("accentPurple"), Color("accentPurple").opacity(0.8)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .cornerRadius(18)
                            .shadow(color: Color("accentPurple").opacity(0.3), radius: 12, y: 4)
                        }

                        Text("7 jours gratuits · Pas de carte bancaire")
                            .font(.system(size: 13))
                            .foregroundColor(Color("textSecondary"))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 48)
                    .opacity(contentOpacity)
                }
            }
        }
        .onAppear {
            withAnimation { logoScale = 1.0 }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) { contentOpacity = 1 }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) { badgesOpacity = 1 }
        }
    }
}

// MARK: - Badge de confiance
struct TrustBadge: View {
    let emoji: String
    let text: String

    var body: some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 26))
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Feature item
struct SplashFeature: View {
    let emoji: String
    let title: String
    let description: String
    let color: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(color).opacity(0.12))
                    .frame(width: 48, height: 48)
                Text(emoji)
                    .font(.system(size: 24))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color("textSecondary"))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}
