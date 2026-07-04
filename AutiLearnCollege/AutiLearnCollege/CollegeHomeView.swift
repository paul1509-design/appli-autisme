import SwiftUI
import SwiftData

struct CollegeHomeView: View {
    let student: CollegeProfile
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var sub: CollegeSubscriptionService
    @EnvironmentObject private var appState: CollegeAppState
    @State private var showLevelPicker = false
    @State private var showReward = false
    @State private var showBonusUnlock = false
    @State private var showChampionsQuiz = false
    @State private var lastRewardAt: Int = 0
    @State private var completedSteps: Set<Int> = []
    @AppStorage("collegeScheduleDate") private var scheduleDateString: String = ""
    @StateObject private var leo = LeoCompanion()

    private let rewardThreshold = 10

    var starsUntilReward: Int {
        let cycle = student.totalStars % rewardThreshold
        return rewardThreshold - cycle
    }

    var recentRate: Double {
        let recent = student.sessions.suffix(5)
        guard !recent.isEmpty else { return 0 }
        return recent.map { $0.successRate }.reduce(0, +) / Double(recent.count)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 20) {

                    // Bandeau trial si ≤ 7 jours restants
                    if !sub.isSubscribed && sub.trialDaysRemaining <= 7 {
                        CollegeTrialBanner(daysLeft: sub.trialDaysRemaining) {
                            appState.screen = .paywall
                        }
                    }

                    // En-tête
                    CollegeHeader(student: student, onLevelTap: { showLevelPicker = true })

                    // Stats rapides
                    HStack(spacing: 12) {
                        CollegeStatCard(value: "\(student.currentStreak)", label: "jours streak", emoji: "🔥")
                        CollegeStatCard(value: "\(student.totalStars)", label: "étoiles", emoji: "⭐️")
                        CollegeStatCard(value: "\(Int(recentRate * 100))%", label: "réussite récente", emoji: "🎯")
                    }
                    .padding(.horizontal, 20)

                    // Compagnon pair (Léo ado)
                    AdoPeerCard(student: student, starsUntilReward: starsUntilReward)

                    // Planning visuel journalier
                    CollegeDailySchedule(completedSteps: completedSteps) { idx in
                        withAnimation(.spring(response: 0.3)) { completedSteps.insert(idx) }
                    }

                    // Stats rapides
                    HStack(spacing: 12) {
                        CollegeStatCard(value: "\(student.currentStreak)", label: "jours streak", emoji: "🔥")
                        CollegeStatCard(value: "\(student.totalStars)", label: "étoiles", emoji: "⭐️")
                        CollegeStatCard(value: "\(Int(recentRate * 100))%", label: "réussite récente", emoji: "🎯")
                    }
                    .padding(.horizontal, 20)

                    // Matières
                    Text("Choisir une matière")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(CollegeSubject.allCases, id: \.self) { subject in
                            NavigationLink {
                                CollegeSessionView(student: student, subject: subject)
                            } label: {
                                CollegeSubjectCard(subject: subject, student: student)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Exercice bonus Champions Quiz
                    Button {
                        if CollegeReviewService.isBonusUnlocked {
                            showChampionsQuiz = true
                        } else {
                            showBonusUnlock = true
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Text("🏆").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(CollegeReviewService.isBonusUnlocked ? "Champions Quiz 🎯" : "Débloquer l'exercice bonus 🎁")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                                Text(CollegeReviewService.isBonusUnlocked ? "Quiz chronométré — toutes matières" : "Laisser un avis 5⭐ pour débloquer")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("textSecondary"))
                            }
                            Spacer()
                            Image(systemName: CollegeReviewService.isBonusUnlocked ? "play.circle.fill" : "lock.fill")
                                .font(.system(size: 18))
                                .foregroundColor(CollegeReviewService.isBonusUnlocked ? Color("accentGreen") : Color("accentOrange"))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("cardBackground"))
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color("accentOrange").opacity(0.3), lineWidth: 1))
                        )
                        .padding(.horizontal, 20)
                    }

                    // Espace parents (avec PIN)
                    NavigationLink {
                        CollegeParentPINView(student: student)
                    } label: {
                        HStack(spacing: 12) {
                            Text("📊").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Espace Parents")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                                Text("Suivi des matières, progression, rapport ABA")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("textSecondary"))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                                .foregroundColor(Color("textSecondary"))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("cardBackground"))
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color("borderLight"), lineWidth: 0.5))
                        )
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.vertical, 16)
            }
            .background(Color("backgroundSoft"))
            // Léo flottant en bas
            LeoBubbleView(leo: leo)
                .padding(.bottom, 8)
            } // ZStack
            .navigationBarHidden(true)
            .sheet(isPresented: $showLevelPicker) {
                CollegeLevelPicker(student: student)
            }
            .sheet(isPresented: $showBonusUnlock) {
                CollegeBonusUnlockView(isPresented: $showBonusUnlock, studentName: student.firstName)
            }
            .fullScreenCover(isPresented: $showReward) {
                CollegeRewardBreakView(student: student, onDismiss: { showReward = false })
            }
            .fullScreenCover(isPresented: $showChampionsQuiz) {
                CollegeChampionsQuizView(student: student)
            }
        }
        .onAppear {
            let today = ISO8601DateFormatter().string(from: Calendar.current.startOfDay(for: Date()))
            if scheduleDateString != today {
                scheduleDateString = today
                completedSteps = []
            }
            leo.configure(language: student.language)
            // Léo salue à l'arrivée
            let daysSinceLast: Int = {
                guard let last = student.lastSessionDate else { return 0 }
                return Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0
            }()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if daysSinceLast == 0 {
                    self.leo.speak(context: .encourageStart(firstName: self.student.firstName))
                } else if daysSinceLast >= 2 {
                    self.leo.speak(context: .greetingReturn(firstName: self.student.firstName, daysSince: daysSinceLast))
                } else {
                    self.leo.speak(context: .greetingMorning(firstName: self.student.firstName))
                }
            }
            // Célébration streak si ≥ 3 jours
            if student.currentStreak >= 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.leo.speak(context: .streakCelebration(days: self.student.currentStreak))
                }
            }
        }
        .onChange(of: student.totalStars) { _, newValue in
            let cycle = newValue / rewardThreshold
            if cycle > lastRewardAt && newValue >= rewardThreshold {
                lastRewardAt = cycle
                withAnimation { showReward = true }
            }
        }
    }
}

// MARK: - En-tête
struct CollegeHeader: View {
    let student: CollegeProfile
    let onLevelTap: () -> Void

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:  return "Bonjour"
        case 12..<18: return "Bon après-midi"
        default:      return "Bonsoir"
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(greeting) \(student.firstName) !")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Button(action: onLevelTap) {
                    HStack(spacing: 6) {
                        Text(student.level.emoji).font(.system(size: 14))
                        Text(student.level.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color("accentPurple"))
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Color("accentPurple").opacity(0.7))
                    }
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color("accentPurple").opacity(0.1))
                    .cornerRadius(20)
                }
            }
            Spacer()
            ZStack {
                Circle().fill(Color("accentPurple").opacity(0.12)).frame(width: 52, height: 52)
                Text("🎓").font(.system(size: 28))
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Carte matière
struct CollegeSubjectCard: View {
    let subject: CollegeSubject
    let student: CollegeProfile

    var lastRate: Double {
        let sessions = student.sessions.filter { $0.subject == subject.rawValue }
        guard let last = sessions.last else { return -1 }
        return last.successRate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(subject.emoji).font(.system(size: 38))
            Text(subject.rawValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            if lastRate >= 0 {
                HStack(spacing: 4) {
                    Circle()
                        .fill(lastRate >= 0.8 ? Color("accentGreen")
                              : lastRate >= 0.6 ? Color("accentOrange") : .red)
                        .frame(width: 7, height: 7)
                    Text(lastRate >= 0.8 ? "Maîtrisé" : lastRate >= 0.6 ? "En progrès" : "À travailler")
                        .font(.system(size: 11))
                        .foregroundColor(Color("textSecondary"))
                }
            } else {
                Text("Pas encore commencé")
                    .font(.system(size: 11))
                    .foregroundColor(Color("textSecondary"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(subject.color).opacity(0.09))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(subject.color).opacity(0.25), lineWidth: 0.5))
        )
    }
}

// MARK: - Motivation ABA
struct ABAMotivationCard: View {
    let student: CollegeProfile
    let rate: Double

    var message: String {
        if student.sessions.isEmpty {
            return "Commence ta première session ! Chaque étape compte."
        } else if rate >= 0.8 {
            return "Excellent ! Tu maîtrises bien les matières. Continue à ce rythme !"
        } else if rate >= 0.6 {
            return "Bien ! N'hésite pas à utiliser les indices pour progresser."
        } else {
            return "Chaque exercice t'aide à progresser. Reprends les matières difficiles."
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color("accentGreen").opacity(0.15)).frame(width: 48, height: 48)
                Text("💪").font(.system(size: 26))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Conseil ABA").font(.system(size: 12, weight: .medium)).foregroundColor(Color("accentGreen"))
                Text(message).font(.system(size: 14)).foregroundColor(Color("textPrimary")).lineLimit(3).lineSpacing(3)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("accentGreen").opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("accentGreen").opacity(0.2), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Stat card
struct CollegeStatCard: View {
    let value: String; let label: String; let emoji: String
    var body: some View {
        VStack(spacing: 4) {
            Text(emoji).font(.system(size: 22))
            Text(value).font(.system(size: 18, weight: .medium)).foregroundColor(Color("textPrimary"))
            Text(label).font(.system(size: 10)).foregroundColor(Color("textSecondary")).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(12)
        .background(Color("cardBackground")).cornerRadius(12)
    }
}

// MARK: - Compagnon pair ado (Léo version ado)
struct AdoPeerCard: View {
    let student: CollegeProfile
    let starsUntilReward: Int

    private let messages = [
        "On bosse ensemble aujourd'hui !",
        "Chaque bonne réponse compte — allez !",
        "Tu progresses, c'est ce qui compte.",
        "Une matière à la fois. Tu gères.",
        "Prêt(e) ? Moi aussi !"
    ]
    private var message: String { messages[abs(student.firstName.hashValue) % messages.count] }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color("accentBlue").opacity(0.12)).frame(width: 50, height: 50)
                Text("🧑‍💻").font(.system(size: 26))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Léo, ton compagnon").font(.system(size: 12, weight: .medium)).foregroundColor(Color("accentBlue"))
                Text(message).font(.system(size: 14)).foregroundColor(Color("textPrimary")).lineLimit(2)
                Text("Encore \(starsUntilReward) étoile\(starsUntilReward > 1 ? "s" : "") → pause mérité !")
                    .font(.system(size: 11)).foregroundColor(Color("textSecondary"))
            }
            Spacer()
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color("accentBlue").opacity(0.06))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("accentBlue").opacity(0.2), lineWidth: 0.5)))
        .padding(.horizontal, 20)
    }
}

// MARK: - Planning visuel journalier ado
struct CollegeDailySchedule: View {
    let completedSteps: Set<Int>
    let onComplete: (Int) -> Void

    private let steps: [(String, String, String)] = [
        ("😊", "Comment tu te sens ?", "accentYellow"),
        ("🗣️", "Communication sociale", "accentOrange"),
        ("📝", "Français", "accentPurple"),
        ("🔢", "Maths", "accentBlue"),
        ("🎉", "Pause méritée !", "accentPink"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📅 Programme du jour")
                    .font(.system(size: 15, weight: .medium)).foregroundColor(Color("textPrimary"))
                Spacer()
                Text("\(completedSteps.count)/\(steps.count)")
                    .font(.system(size: 12)).foregroundColor(Color("textSecondary"))
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                        let done = completedSteps.contains(idx)
                        let isNext = !done && idx == (0..<steps.count).first(where: { !completedSteps.contains($0) })
                        Button { onComplete(idx) } label: {
                            VStack(spacing: 6) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(done ? Color("accentGreen").opacity(0.15) : isNext ? Color(step.2).opacity(0.18) : Color("backgroundSoft"))
                                        .frame(width: 62, height: 62)
                                        .overlay(RoundedRectangle(cornerRadius: 12)
                                            .stroke(done ? Color("accentGreen") : isNext ? Color(step.2) : Color("borderLight"),
                                                    lineWidth: done || isNext ? 2 : 0.5))
                                    if done { Image(systemName: "checkmark.circle.fill").font(.system(size: 26)).foregroundColor(Color("accentGreen")) }
                                    else { Text(step.0).font(.system(size: 28)).opacity(isNext ? 1 : 0.4) }
                                }
                                Text(step.1).font(.system(size: 9, weight: isNext ? .medium : .regular))
                                    .foregroundColor(done ? Color("accentGreen") : isNext ? Color(step.2) : Color("textSecondary"))
                                    .multilineTextAlignment(.center).lineLimit(2).frame(width: 64)
                            }
                        }
                        .scaleEffect(isNext ? 1.05 : 1.0).animation(.spring(response: 0.3), value: isNext)
                    }
                }
                .padding(.horizontal, 2).padding(.bottom, 4)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color("cardBackground"))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("borderLight"), lineWidth: 0.5)))
        .padding(.horizontal, 20)
    }
}

// MARK: - Récompense ado (5 min pause)
struct CollegeRewardBreakView: View {
    let student: CollegeProfile
    let onDismiss: () -> Void
    @State private var timeRemaining = 300
    @State private var timerActive = false
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var timeLabel: String { String(format: "%d:%02d", timeRemaining / 60, timeRemaining % 60) }

    var body: some View {
        ZStack {
            Color("accentBlue").opacity(0.08).ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                VStack(spacing: 12) {
                    Text("🎉").font(.system(size: 64))
                    Text("Bien joué \(student.firstName) !").font(.system(size: 26, weight: .medium)).foregroundColor(Color("textPrimary"))
                    Text("Tu as gagné ta pause de 5 minutes.\nChoisis ce que tu veux faire.")
                        .font(.system(size: 15)).foregroundColor(Color("textSecondary")).multilineTextAlignment(.center).lineSpacing(4)
                }
                VStack(spacing: 12) {
                    ForEach([("🎮", "Jeu libre — 5 minutes"), ("🎵", "Musique ou podcast"), ("🚶", "Bouger — 5 min de marche"), ("📱", "Pause écran choisie")], id: \.0) { emoji, label in
                        Button { timerActive = true } label: {
                            HStack(spacing: 12) {
                                Text(emoji).font(.system(size: 24))
                                Text(label).font(.system(size: 15)).foregroundColor(Color("textPrimary"))
                                Spacer()
                            }
                            .padding(14).background(Color("cardBackground")).cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 24)
                if timerActive {
                    Text(timeLabel).font(.system(size: 44, weight: .light, design: .rounded)).foregroundColor(Color("accentBlue"))
                }
                Spacer()
                Button(action: onDismiss) {
                    Text("Terminer la pause").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 16).background(Color("accentPurple")).cornerRadius(16)
                }
                .padding(.horizontal, 24).padding(.bottom, 32)
            }
        }
        .onReceive(countdown) { _ in
            if timerActive && timeRemaining > 0 { timeRemaining -= 1 }
            else if timeRemaining == 0 { onDismiss() }
        }
    }
}

// MARK: - PIN parents (app ado)
struct CollegeParentPINView: View {
    let student: CollegeProfile
    @AppStorage("collegeParentPIN") private var storedPIN: String = ""
    @State private var enteredPIN: String = ""
    @State private var confirmPIN: String = ""
    @State private var wrongAttempt: Bool = false
    @State private var phase: PINPhase = .checking

    enum PINPhase { case checking, setting, confirming, entering, authenticated }

    private var currentPIN: String { phase == .confirming ? confirmPIN : enteredPIN }

    var body: some View {
        Group {
            if phase == .authenticated {
                CollegeParentDashboard(student: student)
            } else {
                pinBody
            }
        }
        .onAppear { phase = storedPIN.isEmpty ? .setting : .entering }
    }

    private var pinBody: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                VStack(spacing: 12) {
                    Text("🔒").font(.system(size: 48))
                    Text(phase == .setting || phase == .confirming ? "Créer un code parents" : "Espace Parents")
                        .font(.system(size: 22, weight: .medium)).foregroundColor(Color("textPrimary"))
                    Text(phase == .setting ? "Code à 4 chiffres pour protéger cet espace."
                         : phase == .confirming ? "Confirmez votre code à 4 chiffres."
                         : "Entrez votre code à 4 chiffres.")
                        .font(.system(size: 14)).foregroundColor(Color("textSecondary")).multilineTextAlignment(.center)
                }
                HStack(spacing: 18) {
                    ForEach(0..<4) { i in
                        Circle().fill(i < currentPIN.count ? Color("accentPurple") : Color("borderLight"))
                            .frame(width: 16, height: 16)
                            .scaleEffect(wrongAttempt ? 1.3 : 1.0).animation(.spring(response: 0.2), value: wrongAttempt)
                    }
                }
                if wrongAttempt { Text("Code incorrect.").font(.system(size: 13)).foregroundColor(.red) }
                VStack(spacing: 12) {
                    ForEach([[1,2,3],[4,5,6],[7,8,9]], id: \.self) { row in
                        HStack(spacing: 20) {
                            ForEach(row, id: \.self) { d in
                                PINKey(label: "\(d)") { appendDigit("\(d)") }
                            }
                        }
                    }
                    HStack(spacing: 20) {
                        PINKey(label: "⌫", isAction: true) { deleteLast() }
                        PINKey(label: "0") { appendDigit("0") }
                        PINKey(label: "✓", isAction: true, disabled: currentPIN.count < 4) { confirm() }
                    }
                }
                Spacer()
                if phase == .entering {
                    Button("Code oublié ? Réinitialiser") { storedPIN = ""; enteredPIN = ""; phase = .setting }
                        .font(.system(size: 13)).foregroundColor(Color("textSecondary")).padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 40)
        }
        .navigationBarHidden(true)
    }

    private func appendDigit(_ d: String) {
        guard (phase == .confirming ? confirmPIN : enteredPIN).count < 4 else { return }
        if phase == .confirming { confirmPIN += d } else { enteredPIN += d }
        if (phase == .confirming ? confirmPIN : enteredPIN).count == 4 { confirm() }
    }
    private func deleteLast() {
        if phase == .confirming { if !confirmPIN.isEmpty { confirmPIN.removeLast() } }
        else { if !enteredPIN.isEmpty { enteredPIN.removeLast() } }
    }
    private func confirm() {
        switch phase {
        case .setting: phase = .confirming
        case .confirming:
            if confirmPIN == enteredPIN { storedPIN = confirmPIN; phase = .authenticated }
            else { wrongAttempt = true; DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { wrongAttempt = false; confirmPIN = "" } }
        case .entering:
            if enteredPIN == storedPIN { phase = .authenticated }
            else { wrongAttempt = true; DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { wrongAttempt = false; enteredPIN = "" } }
        default: break
        }
    }
}

// MARK: - Sélecteur de niveau
struct CollegeLevelPicker: View {
    let student: CollegeProfile
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Text("Changer de niveau").font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary")).padding(.top, 8)

                ForEach(CollegeLevel.allCases, id: \.self) { level in
                    Button {
                        student.level = level
                        try? modelContext.save()
                        dismiss()
                    } label: {
                        HStack(spacing: 14) {
                            Text(level.emoji).font(.system(size: 26))
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 8) {
                                    Text(level.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color("textPrimary"))
                                    if level.isLycee {
                                        Text("Lycée").font(.system(size: 10, weight: .medium))
                                            .foregroundColor(Color("accentPurple"))
                                            .padding(.horizontal, 6).padding(.vertical, 2)
                                            .background(Color("accentPurple").opacity(0.12))
                                            .cornerRadius(4)
                                    }
                                }
                                Text(level.ageRange).font(.system(size: 12)).foregroundColor(Color("textSecondary"))
                            }
                            Spacer()
                            if student.level == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("accentPurple")).font(.system(size: 20))
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(student.level == level
                                      ? Color("accentPurple").opacity(0.08) : Color("cardBackground"))
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(student.level == level
                                            ? Color("accentPurple") : Color("borderLight"),
                                            lineWidth: student.level == level ? 1.5 : 0.5))
                        )
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color("backgroundSoft").ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Color("accentPurple"))
                }
            }
        }
    }
}

// MARK: - Clavier PIN (partagé dans cette app)
private struct PINKey: View {
    let label: String
    var isAction: Bool = false
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: isAction ? 20 : 24, weight: .medium))
                .foregroundColor(disabled ? Color("textSecondary").opacity(0.4) : Color("textPrimary"))
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(Color("cardBackground"))
                        .overlay(Circle().stroke(Color("borderLight"), lineWidth: 0.5))
                )
        }
        .disabled(disabled)
    }
}
