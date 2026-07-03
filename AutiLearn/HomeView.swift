import SwiftUI
import SwiftData

// MARK: - Seuil d'étoiles pour la récompense
private let rewardStarThreshold = 10

struct HomeView: View {
    let child: ChildProfile
    @Environment(\.modelContext) private var modelContext

    @State private var showEmotionCheck = true
    @State private var selectedEmotion: EmotionState?
    @State private var showBreathing = false
    @State private var currentTime = Date()
    @State private var showLevelPicker = false
    @State private var showReward = false
    @State private var lastRewardAt: Int = 0
    @State private var completedScheduleSteps: Set<Int> = []
    @AppStorage("scheduleDate") private var scheduleDateString: String = ""

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 6..<12:  return "Bonjour"
        case 12..<18: return "Bon après-midi"
        default:      return "Bonsoir"
        }
    }

    var starsUntilReward: Int {
        let starsThisCycle = child.totalStars % rewardStarThreshold
        return rewardStarThreshold - starsThisCycle
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    HomeHeader(child: child, greeting: greeting,
                               onLevelTap: { showLevelPicker = true })

                    if showEmotionCheck && selectedEmotion == nil {
                        EmotionCheckCard(child: child) { emotion in
                            withAnimation(.spring()) {
                                selectedEmotion = emotion
                                showEmotionCheck = false
                                if emotion.needsRegulation { showBreathing = true }
                            }
                        }
                    }

                    if let emotion = selectedEmotion, emotion.needsRegulation {
                        BreathingBanner(onTap: { showBreathing = true })
                    }

                    // Compagnon pair — encouragement
                    PeerCompanionCard(child: child, starsUntilReward: starsUntilReward)

                    // Planning visuel du jour (style PECS)
                    DailyScheduleCard(
                        child: child,
                        completedSteps: completedScheduleSteps,
                        onComplete: { idx in
                            withAnimation(.spring(response: 0.3)) {
                                completedScheduleSteps.insert(idx)
                            }
                        }
                    )

                    StatsRow(child: child, onRewardTap: { showReward = true })

                    SpacingReviewBanner(child: child)

                    // Modules — Parole en PREMIER
                    Text("Par où commencer ?")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    ModuleGrid(child: child)

                    DailyStoryTeaser(child: child)

                    // Accès espace parents (protégé par PIN)
                    NavigationLink {
                        ParentPINView(child: child)
                    } label: {
                        HStack(spacing: 12) {
                            Text("📊").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Espace Parents")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                                Text("Suivi des progrès, compétences ABA, rapport")
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

                    Spacer(minLength: 20)
                }
                .padding(.vertical, 16)
            }
            .background(Color("backgroundSoft"))
            .navigationBarHidden(true)
            .sheet(isPresented: $showBreathing) {
                BreathingExerciseView()
            }
            .sheet(isPresented: $showLevelPicker) {
                LevelPickerSheet(child: child)
            }
            .fullScreenCover(isPresented: $showReward) {
                RewardBreakView(child: child, onDismiss: { showReward = false })
            }
        }
        .onAppear {
            let today = ISO8601DateFormatter().string(from: Calendar.current.startOfDay(for: Date()))
            if scheduleDateString != today {
                scheduleDateString = today
                completedScheduleSteps = []
            }
        }
        .onReceive(timer) { time in
            currentTime = time
        }
        .onChange(of: child.totalStars) { _, newValue in
            let cycle = newValue / rewardStarThreshold
            if cycle > lastRewardAt && newValue >= rewardStarThreshold {
                lastRewardAt = cycle
                withAnimation { showReward = true }
            }
        }
    }
}

// MARK: - Header avec changement de niveau
struct HomeHeader: View {
    let child: ChildProfile
    let greeting: String
    let onLevelTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting + " \(child.firstName) !")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("textPrimary"))

                // Bouton niveau — tap pour changer
                Button(action: onLevelTap) {
                    HStack(spacing: 6) {
                        Text(child.schoolLevel.emoji)
                            .font(.system(size: 14))
                        Text(child.schoolLevel.displayName)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color("accentPurple"))
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Color("accentPurple").opacity(0.7))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("accentPurple").opacity(0.1))
                    .cornerRadius(20)
                }
            }
            Spacer()
            AvatarCircle(name: child.avatarName, size: 56, isSelected: false)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Sélecteur de niveau (sheet)
struct LevelPickerSheet: View {
    let child: ChildProfile
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Choisir le niveau")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .padding(.top, 8)

                ForEach(SchoolLevel.allCases.filter { $0 != .level3 }, id: \.self) { level in
                    Button {
                        child.schoolLevel = level
                        try? modelContext.save()
                        dismiss()
                    } label: {
                        HStack(spacing: 14) {
                            Text(level.emoji)
                                .font(.system(size: 28))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(level.displayName)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                                Text(level.description)
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("textSecondary"))
                            }
                            Spacer()
                            if child.schoolLevel == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("accentPurple"))
                                    .font(.system(size: 22))
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(child.schoolLevel == level
                                      ? Color("accentPurple").opacity(0.08)
                                      : Color("cardBackground"))
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(child.schoolLevel == level
                                            ? Color("accentPurple")
                                            : Color("borderLight"),
                                            lineWidth: child.schoolLevel == level ? 1.5 : 0.5))
                        )
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color("backgroundSoft").ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Color("accentPurple"))
                }
            }
        }
    }
}

// MARK: - Compagnon pair (encouragement)
struct PeerCompanionCard: View {
    let child: ChildProfile
    let starsUntilReward: Int

    private let messages = [
        "On apprend ensemble aujourd'hui !",
        "Tu vas y arriver, je suis là !",
        "Chaque mot appris est une victoire !",
        "Prêt(e) ? Moi j'y suis !",
        "On forme une super équipe !"
    ]

    private var message: String {
        messages[abs(child.firstName.hashValue) % messages.count]
    }

    var body: some View {
        HStack(spacing: 14) {
            // Avatar compagnon
            ZStack {
                Circle()
                    .fill(Color("accentGreen").opacity(0.15))
                    .frame(width: 52, height: 52)
                Text("🧒")
                    .font(.system(size: 28))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Ton compagnon Léo")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color("accentGreen"))
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(Color("textPrimary"))
                    .lineLimit(2)

                // Barre de progression vers la récompense
                HStack(spacing: 6) {
                    Text("⭐️")
                        .font(.system(size: 11))
                    Text("Encore \(starsUntilReward) étoile\(starsUntilReward > 1 ? "s" : "") → pause jeu !")
                        .font(.system(size: 11))
                        .foregroundColor(Color("textSecondary"))
                }
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("accentGreen").opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("accentGreen").opacity(0.2), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Vérification émotion
struct EmotionCheckCard: View {
    let child: ChildProfile
    let onSelect: (EmotionState) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Comment tu te sens \(child.firstName) ?")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3),
                      spacing: 12) {
                ForEach(EmotionState.allCases, id: \.self) { emotion in
                    EmotionButton(emotion: emotion, onSelect: onSelect)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

struct EmotionButton: View {
    let emotion: EmotionState
    let onSelect: (EmotionState) -> Void
    @State private var isPressed = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                onSelect(emotion)
            }
        } label: {
            VStack(spacing: 6) {
                Text(emotion.emoji)
                    .font(.system(size: 36))
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                Text(emotion.displayName)
                    .font(.system(size: 12))
                    .foregroundColor(Color("textSecondary"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color("backgroundSoft"))
            .cornerRadius(12)
        }
    }
}

// MARK: - Bannière respiration
struct BreathingBanner: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text("🌬️").font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Exercice de respiration")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentBlue"))
                    Text("3 minutes pour se calmer avant d'apprendre")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("textSecondary")).font(.system(size: 13))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("accentBlue").opacity(0.08))
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("accentBlue").opacity(0.3), lineWidth: 0.5))
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Stats streak / étoiles
struct StatsRow: View {
    let child: ChildProfile
    let onRewardTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(child.currentStreak)",
                     label: "jours consécutifs", emoji: "🔥")
            Button(action: onRewardTap) {
                StatCard(value: "\(child.totalStars)",
                         label: "étoiles — voir récompenses", emoji: "⭐️")
            }
        }
        .padding(.horizontal, 20)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let emoji: String

    var body: some View {
        HStack(spacing: 10) {
            Text(emoji).font(.system(size: 28))
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(Color("textSecondary"))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Bannière retest spacing
struct SpacingReviewBanner: View {
    let child: ChildProfile

    var wordsToReview: Int {
        let today = Date()
        return child.wordProgresses.filter { wp in
            guard let nextReview = wp.nextReviewDate else { return false }
            return nextReview <= today && wp.masteryLevel != .mastered
        }.count
    }

    var body: some View {
        if wordsToReview > 0 {
            HStack(spacing: 12) {
                Text("🔄").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(wordsToReview) mots à réviser aujourd'hui")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentOrange"))
                    Text("Révision rapide — 3 minutes !")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(Color("textSecondary"))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("accentOrange").opacity(0.08))
                    .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("accentOrange").opacity(0.3), lineWidth: 0.5))
            )
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Grille des modules (Parole en premier)
struct ModuleGrid: View {
    let child: ChildProfile
    @EnvironmentObject private var appState: AppState

    let modules: [(String, String, String, ModuleType)] = [
        ("🗣️", "Parole",      "accentOrange", .diction),
        ("🎵", "Chanson",     "accentPink",   .karaoke),
        ("📖", "Histoire",    "accentPurple", .story),
        ("🔤", "Vocabulaire", "accentBlue",   .vocabulary),
        ("🔢", "Chiffres",    "accentGreen",  .numbers),
        ("✏️", "Dessin",      "accentYellow", .drawing)
    ]

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2),
                  spacing: 12) {
            ForEach(Array(modules.enumerated()), id: \.offset) { index, module in
                let (emoji, title, color, moduleType) = module
                NavigationLink {
                    LearningSessionView(child: child, moduleType: moduleType,
                                        language: appState.currentLanguage)
                } label: {
                    ModuleCard(emoji: emoji, title: title, colorName: color,
                               isPrimary: index == 0)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ModuleCard: View {
    let emoji: String
    let title: String
    let colorName: String
    var isPrimary: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(emoji).font(.system(size: isPrimary ? 42 : 36))
            Text(title)
                .font(.system(size: isPrimary ? 18 : 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            if isPrimary {
                Text("Commence ici !")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(colorName))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color(colorName).opacity(0.15))
                    .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(colorName).opacity(isPrimary ? 0.15 : 0.08))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(colorName).opacity(isPrimary ? 0.4 : 0.2),
                            lineWidth: isPrimary ? 1.5 : 0.5))
        )
    }
}

// MARK: - Teaser histoire du jour
struct DailyStoryTeaser: View {
    let child: ChildProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 Histoire du jour")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            Text("Aujourd'hui, \(child.firstName) part à l'aventure dans la forêt magique des mots...")
                .font(.system(size: 14))
                .foregroundColor(Color("textSecondary"))
                .lineSpacing(4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("accentPurple").opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("accentPurple").opacity(0.15), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Planning visuel journalier (style PECS)
struct DailyScheduleCard: View {
    let child: ChildProfile
    let completedSteps: Set<Int>
    let onComplete: (Int) -> Void

    struct ScheduleStep {
        let emoji: String
        let title: String
        let subtitle: String
        let color: String
    }

    private var steps: [ScheduleStep] {
        let hour = Calendar.current.component(.hour, from: Date())
        var list: [ScheduleStep] = [
            ScheduleStep(emoji: "😊", title: "Comment tu te sens ?",   subtitle: "Émotion du matin", color: "accentYellow"),
            ScheduleStep(emoji: "🗣️", title: "Exercice de parole",     subtitle: "5 min – 8 exercices", color: "accentOrange"),
            ScheduleStep(emoji: "🔤", title: "Vocabulaire",             subtitle: "Nouveaux mots", color: "accentBlue"),
            ScheduleStep(emoji: "🧮", title: "Chiffres & maths",        subtitle: "Compter et calculer", color: "accentGreen"),
            ScheduleStep(emoji: "🎉", title: "Récompense !",            subtitle: "Pause de 5 minutes", color: "accentPink"),
        ]
        if hour >= 14 {
            list[1] = ScheduleStep(emoji: "📖", title: "Histoire", subtitle: "Lecture du jour", color: "accentPurple")
        }
        return list
    }

    var doneCount: Int { completedSteps.count }
    var totalCount: Int { steps.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("📅 Programme du jour")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Text("\(doneCount) / \(totalCount) étapes terminées")
                        .font(.system(size: 12))
                        .foregroundColor(Color("textSecondary"))
                }
                Spacer()
                // Mini barre de progression globale
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3).fill(Color("borderLight")).frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color("accentGreen"))
                            .frame(width: totalCount > 0
                                   ? geo.size.width * CGFloat(doneCount) / CGFloat(totalCount)
                                   : 0, height: 6)
                            .animation(.spring(response: 0.4), value: doneCount)
                    }
                }
                .frame(width: 80, height: 6)
            }

            // Étapes horizontales — scrollable
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                        ScheduleStepCard(
                            step: step,
                            index: idx,
                            isDone: completedSteps.contains(idx),
                            isNext: !completedSteps.contains(idx) && idx == (0..<steps.count).first(where: { !completedSteps.contains($0) }),
                            onTap: { onComplete(idx) }
                        )
                    }
                }
                .padding(.horizontal, 2)
                .padding(.bottom, 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

struct ScheduleStepCard: View {
    let step: DailyScheduleCard.ScheduleStep
    let index: Int
    let isDone: Bool
    let isNext: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isDone
                              ? Color("accentGreen").opacity(0.15)
                              : isNext
                                  ? Color(step.color).opacity(0.18)
                                  : Color("backgroundSoft"))
                        .frame(width: 68, height: 68)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isDone ? Color("accentGreen")
                                        : isNext ? Color(step.color)
                                        : Color("borderLight"),
                                        lineWidth: isDone || isNext ? 2 : 0.5)
                        )

                    if isDone {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color("accentGreen"))
                    } else {
                        Text(step.emoji)
                            .font(.system(size: 32))
                            .opacity(isNext ? 1.0 : 0.45)
                    }
                }

                Text(step.title)
                    .font(.system(size: 10, weight: isNext ? .medium : .regular))
                    .foregroundColor(isDone ? Color("accentGreen")
                                     : isNext ? Color(step.color)
                                     : Color("textSecondary"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 70)
            }
        }
        .scaleEffect(isNext ? 1.05 : 1.0)
        .animation(.spring(response: 0.3), value: isNext)
    }
}

// MARK: - Récompense 5 minutes
struct RewardBreakView: View {
    let child: ChildProfile
    let onDismiss: () -> Void

    @State private var selectedActivity: RewardActivity?
    @State private var timeRemaining = 300 // 5 minutes
    @State private var timerActive = false
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    enum RewardActivity: String, CaseIterable {
        case game1   = "Jeu des bulles"
        case game2   = "Jeu des couleurs"
        case video1  = "Les animaux du monde"
        case video2  = "Comment poussent les plantes ?"
        case video3  = "L'espace et les étoiles"

        var emoji: String {
            switch self {
            case .game1:  return "🫧"
            case .game2:  return "🎨"
            case .video1: return "🐘"
            case .video2: return "🌱"
            case .video3: return "🚀"
            }
        }
        var isVideo: Bool {
            switch self {
            case .video1, .video2, .video3: return true
            default: return false
            }
        }
    }

    var timeLabel: String {
        let m = timeRemaining / 60
        let s = timeRemaining % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        ZStack {
            Color("accentYellow").opacity(0.15).ignoresSafeArea()

            VStack(spacing: 28) {
                // Célébration
                VStack(spacing: 12) {
                    Text("🎉")
                        .font(.system(size: 72))
                    Text("Bravo \(child.firstName) !")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Text("Tu as gagné \(rewardStarThreshold) étoiles !\nC'est ta pause de 5 minutes !")
                        .font(.system(size: 16))
                        .foregroundColor(Color("textSecondary"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                if let activity = selectedActivity {
                    // Activité en cours
                    VStack(spacing: 16) {
                        Text(activity.emoji).font(.system(size: 56))
                        Text(activity.rawValue)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                        Text(activity.isVideo ? "🎬 Mini-film éducatif" : "🎮 Jeu")
                            .font(.system(size: 14))
                            .foregroundColor(Color("textSecondary"))

                        // Compte à rebours
                        Text(timeLabel)
                            .font(.system(size: 48, weight: .light, design: .rounded))
                            .foregroundColor(Color("accentOrange"))

                        Text("Il reste ce temps pour ta pause")
                            .font(.system(size: 13))
                            .foregroundColor(Color("textSecondary"))
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color("cardBackground"))
                    )
                    .padding(.horizontal, 24)

                } else {
                    // Choix de l'activité
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choisis ton activité :")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .padding(.horizontal, 4)

                        ForEach(RewardBreakView.RewardActivity.allCases, id: \.self) { activity in
                            Button {
                                selectedActivity = activity
                                timerActive = true
                            } label: {
                                HStack(spacing: 14) {
                                    Text(activity.emoji).font(.system(size: 28))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(activity.rawValue)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(Color("textPrimary"))
                                        Text(activity.isVideo ? "Mini-film éducatif" : "Jeu interactif")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("textSecondary"))
                                    }
                                    Spacer()
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(Color("accentPurple"))
                                        .font(.system(size: 22))
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color("cardBackground"))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()

                Button {
                    onDismiss()
                } label: {
                    Text(selectedActivity == nil ? "Pas maintenant" : "Terminer la pause")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color("accentPurple"))
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                }
            }
            .padding(.top, 48)
            .padding(.bottom, 32)
        }
        .onReceive(countdown) { _ in
            if timerActive && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                timerActive = false
                onDismiss()
            }
        }
    }
}
