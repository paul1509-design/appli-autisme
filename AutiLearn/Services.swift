import AVFoundation
import SwiftUI
import Combine

// MARK: - Service synthèse vocale (orthophoniste)
class SpeechService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
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

// MARK: - Service abonnements (RevenueCat stub)
// Remplacer par l'intégration RevenueCat SDK en production
class SubscriptionService: ObservableObject {
    @Published var isSubscribed: Bool = false
    @Published var trialDaysRemaining: Int = 21
    @Published var trialExpired: Bool = false

    private let trialStartKey = "trialStartDate"
    private let subscriptionKey = "isSubscribed"

    func checkSubscriptionStatus() {
        // Vérifier achat (RevenueCat en prod)
        isSubscribed = UserDefaults.standard.bool(forKey: subscriptionKey)
        if isSubscribed { return }

        // Calculer jours de trial restants
        if let startDate = UserDefaults.standard.object(forKey: trialStartKey) as? Date {
            let daysPassed = Calendar.current.dateComponents(
                [.day], from: startDate, to: Date()).day ?? 0
            trialDaysRemaining = max(0, 21 - daysPassed)
            trialExpired = trialDaysRemaining <= 0
        } else {
            // Première ouverture → démarrer trial
            UserDefaults.standard.set(Date(), forKey: trialStartKey)
            trialDaysRemaining = 21
        }
    }

    func purchaseLifetime() async {
        // TODO: Intégrer RevenueCat purchase
        // Packages.lifetime à configurer dans le dashboard RevenueCat
        await MainActor.run {
            isSubscribed = true
            UserDefaults.standard.set(true, forKey: subscriptionKey)
        }
    }

    func restorePurchases() async {
        // TODO: RevenueCat restore
        await MainActor.run {
            isSubscribed = UserDefaults.standard.bool(forKey: subscriptionKey)
        }
    }
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
