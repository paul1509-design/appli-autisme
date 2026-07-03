import SwiftUI

struct CollegeSplashView: View {
    let onGetStarted: () -> Void
    @State private var logoScale: CGFloat = 0.7
    @State private var contentOpacity: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("accentPurple").opacity(0.10), Color("backgroundSoft")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // Hero
                    VStack(spacing: 20) {
                        Spacer().frame(height: 52)
                        ZStack {
                            Circle().fill(Color("accentPurple").opacity(0.12)).frame(width: 110, height: 110)
                            Text("🎓").font(.system(size: 58))
                        }
                        .scaleEffect(logoScale)
                        .animation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1), value: logoScale)

                        VStack(spacing: 10) {
                            Text("ABA Collège")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(Color("textPrimary"))
                            Text("Le programme collège & lycée\nà la maison pour votre ado autiste")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Color("accentPurple"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                    }
                    .opacity(contentOpacity)

                    // Problème / solution
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("Votre ado n'est plus scolarisé ?")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color("textPrimary"))
                                .multilineTextAlignment(.center)
                            Text("Des milliers d'adolescents autistes quittent le système scolaire au collège ou au lycée, sans solution adaptée à leurs besoins.")
                                .font(.system(size: 14))
                                .foregroundColor(Color("textSecondary"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color("accentPurple").opacity(0.5))
                        Text("ABA Collège est la réponse")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("accentPurple"))
                        Text("Français, Maths, Anglais, Histoire, Sciences et Communication sociale — le programme officiel, structuré ABA, sans le stress de la classe.")
                            .font(.system(size: 14))
                            .foregroundColor(Color("textSecondary"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 32)
                    .opacity(contentOpacity)

                    // Badges
                    HStack(spacing: 10) {
                        CollegeTrustBadge(emoji: "🎓", text: "6ème →\nTerminale")
                        CollegeTrustBadge(emoji: "📚", text: "6\nmatières")
                        CollegeTrustBadge(emoji: "🧠", text: "Méthode\nABA")
                        CollegeTrustBadge(emoji: "📊", text: "Suivi\nparents")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .opacity(contentOpacity)

                    // Arguments
                    VStack(spacing: 12) {
                        CollegeSplashFeature(emoji: "📝", title: "Programme officiel collège & lycée",
                            desc: "De la 6ème à la Terminale : Français, Maths, Anglais, Histoire-Géo, Sciences, Communication sociale.",
                            color: "accentPurple")
                        CollegeSplashFeature(emoji: "🗣️", title: "Communication sociale — module TSA",
                            desc: "Des exercices spécifiques pour comprendre les codes sociaux, exprimer ses besoins et naviguer les interactions.",
                            color: "accentOrange")
                        CollegeSplashFeature(emoji: "🧠", title: "Stratégies ABA pour ados",
                            desc: "Hiérarchie de prompts adaptée à l'adolescence, renforcement positif, explications pédagogiques après chaque réponse.",
                            color: "accentBlue")
                        CollegeSplashFeature(emoji: "⏱️", title: "Sessions adaptées — 15 à 20 min",
                            desc: "8 questions par matière, timer visible, pause récompense. Conçu pour les profils qui ont du mal à rester concentrés.",
                            color: "accentGreen")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .opacity(contentOpacity)

                    // Témoignage
                    VStack(alignment: .leading, spacing: 10) {
                        Text("❝").font(.system(size: 36)).foregroundColor(Color("accentPurple").opacity(0.4))
                        Text("Lucas a décroché en 5ème. Avec ABA Collège, il suit les maths et l'anglais à son rythme. Il n'est plus en décrochage total — il apprend de nouveau.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("textPrimary")).lineSpacing(4)
                        Text("— Isabelle, maman de Lucas (14 ans, TSA niveau 1)")
                            .font(.system(size: 13)).foregroundColor(Color("textSecondary"))
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

                    // CTA
                    VStack(spacing: 14) {
                        Button(action: onGetStarted) {
                            HStack(spacing: 10) {
                                Text("Commencer le programme gratuitement")
                                    .font(.system(size: 17, weight: .medium))
                                Image(systemName: "arrow.right").font(.system(size: 15, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(colors: [Color("accentPurple"), Color("accentPurple").opacity(0.82)],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(18)
                            .shadow(color: Color("accentPurple").opacity(0.3), radius: 12, y: 4)
                        }
                        Text("7 jours gratuits · Sans carte bancaire · 149 € accès à vie")
                            .font(.system(size: 12)).foregroundColor(Color("textSecondary")).multilineTextAlignment(.center)
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
        }
    }
}

struct CollegeTrustBadge: View {
    let emoji: String; let text: String
    var body: some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 26))
            Text(text).font(.system(size: 10, weight: .medium)).foregroundColor(Color("textSecondary"))
                .multilineTextAlignment(.center).lineSpacing(2)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color("cardBackground"))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("borderLight"), lineWidth: 0.5)))
    }
}

struct CollegeSplashFeature: View {
    let emoji: String; let title: String; let desc: String; let color: String
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(Color(color).opacity(0.12)).frame(width: 48, height: 48)
                Text(emoji).font(.system(size: 24))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 15, weight: .medium)).foregroundColor(Color("textPrimary"))
                Text(desc).font(.system(size: 13)).foregroundColor(Color("textSecondary"))
                    .lineSpacing(3).fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color("cardBackground"))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("borderLight"), lineWidth: 0.5)))
    }
}
