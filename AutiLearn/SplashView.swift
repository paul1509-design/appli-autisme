import SwiftUI

// MARK: - Premier écran marketing (parents)
struct SplashView: View {
    let onGetStarted: () -> Void
    @State private var logoScale: CGFloat = 0.7
    @State private var contentOpacity: Double = 0
    @State private var badgesOpacity: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("accentPurple").opacity(0.10), Color("backgroundSoft")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Hero — promesse principale
                    VStack(spacing: 20) {
                        Spacer().frame(height: 52)

                        ZStack {
                            Circle()
                                .fill(Color("accentPurple").opacity(0.12))
                                .frame(width: 110, height: 110)
                            Text("🏠")
                                .font(.system(size: 58))
                        }
                        .scaleEffect(logoScale)
                        .animation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1),
                                   value: logoScale)

                        VStack(spacing: 10) {
                            Text("ABA Homeschooling")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(Color("textPrimary"))
                                .multilineTextAlignment(.center)

                            // Tag line — le vrai différenciateur
                            Text("Le programme scolaire complet\nà la maison pour votre enfant autiste")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Color("accentPurple"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                    }
                    .opacity(contentOpacity)

                    // MARK: Problème que l'app résout
                    VStack(spacing: 0) {
                        ProblemStatement()
                    }
                    .padding(.top, 32)
                    .opacity(contentOpacity)

                    // MARK: Badges de confiance
                    HStack(spacing: 10) {
                        TrustBadge(emoji: "📚", text: "Programme\nscolaire")
                        TrustBadge(emoji: "🧠", text: "Méthode\nABA")
                        TrustBadge(emoji: "🌍", text: "8\nlangues")
                        TrustBadge(emoji: "📊", text: "Suivi\nparents")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .opacity(badgesOpacity)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: badgesOpacity)

                    // MARK: Arguments détaillés
                    VStack(spacing: 12) {
                        SplashFeature(
                            emoji: "🏫",
                            title: "Tout le programme scolaire à la maison",
                            description: "De la maternelle au CM2 : lecture, écriture, maths, sciences, vie sociale — structuré comme à l'école, adapté à l'autisme.",
                            color: "accentPurple"
                        )
                        SplashFeature(
                            emoji: "🗣️",
                            title: "La parole avant tout",
                            description: "Léo, votre compagnon virtuel, parle à votre enfant. Il répète, il répond, il progresse — chaque jour un peu plus.",
                            color: "accentOrange"
                        )
                        SplashFeature(
                            emoji: "🧠",
                            title: "Stratégies ABA intégrées",
                            description: "Hiérarchie de prompts, renforcement positif, révision espacée, suivi des compétences — les meilleures pratiques éducatives pour TSA.",
                            color: "accentBlue"
                        )
                        SplashFeature(
                            emoji: "⏱️",
                            title: "Sessions courtes, adaptées",
                            description: "8 exercices par session, 10 à 15 minutes. Pause récompense toutes les 10 étoiles. Votre enfant ne se fatigue pas.",
                            color: "accentGreen"
                        )
                        SplashFeature(
                            emoji: "📊",
                            title: "Tableau de bord parents complet",
                            description: "Suivez chaque compétence acquise, taux de réussite, mots maîtrisés et progression ABA semaine après semaine.",
                            color: "accentPink"
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .opacity(contentOpacity)

                    // MARK: Témoignage
                    VStack(alignment: .leading, spacing: 10) {
                        Text("❝")
                            .font(.system(size: 36))
                            .foregroundColor(Color("accentPurple").opacity(0.4))
                        Text("Mon fils est déscolarisé depuis ses 6 ans. Avec ABA Homeschooling, il suit enfin un vrai programme à son rythme. En 2 mois, il lit ses premières syllabes.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .lineSpacing(4)
                        Text("— Sophie, maman de Nathan (8 ans, TSA niveau 2)")
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
                                Text("Commencer le programme gratuitement")
                                    .font(.system(size: 17, weight: .medium))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color("accentPurple"), Color("accentPurple").opacity(0.82)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .cornerRadius(18)
                            .shadow(color: Color("accentPurple").opacity(0.3), radius: 12, y: 4)
                        }

                        Text("7 jours gratuits · Sans carte bancaire · 199 € accès à vie")
                            .font(.system(size: 12))
                            .foregroundColor(Color("textSecondary"))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 52)
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

// MARK: - Bloc problème / solution
struct ProblemStatement: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Votre enfant n'est plus à l'école ?")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .multilineTextAlignment(.center)

                Text("Des milliers d'enfants autistes sont déscolarisés ou en inclusion partielle. Ils n'ont pas accès à un vrai suivi académique adapté à leurs besoins.")
                    .font(.system(size: 14))
                    .foregroundColor(Color("textSecondary"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            // Flèche solution
            VStack(spacing: 8) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color("accentPurple").opacity(0.5))

                Text("ABA Homeschooling est la réponse")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("accentPurple"))
                    .multilineTextAlignment(.center)

                Text("Un programme scolaire complet, structuré selon la méthode ABA, que vous pouvez suivre à la maison — sans être spécialiste.")
                    .font(.system(size: 14))
                    .foregroundColor(Color("textSecondary"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.horizontal, 28)
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
                .font(.system(size: 10, weight: .medium))
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
