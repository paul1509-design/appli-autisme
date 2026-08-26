import SwiftUI

// MARK: - Seuil d'étoiles pour la récompense
private let rewardStarThreshold = 10

struct HomeView: View {
    let child: ChildProfile
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var subscriptionService: SubscriptionService
    @EnvironmentObject private var appState: AppState

    @State private var showEmotionCheck = true
    @State private var selectedEmotion: EmotionState?
    @State private var showBreathing = false
    @State private var currentTime = Date()
    @State private var showLevelPicker = false
    @State private var showQuickSettings = false
    @State private var showReward = false
    @State private var showBonusUnlock = false
    @State private var lastRewardAt: Int = 0
    @StateObject private var leo = LeoPrimary()
    @State private var completedScheduleSteps: Set<Int> = []
    @AppStorage("scheduleDate") private var scheduleDateString: String = ""

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        let ui = appState.currentLanguage.ui
        switch hour {
        case 6..<12:  return ui.goodMorning
        case 12..<18: return ui.goodAfternoon
        default:      return ui.goodEvening
        }
    }

    var starsUntilReward: Int {
        let starsThisCycle = child.totalStars % rewardStarThreshold
        return rewardStarThreshold - starsThisCycle
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Group {
                        // Bandeau trial si < 7 jours restants
                        if !subscriptionService.isSubscribed && subscriptionService.trialDaysRemaining <= 7 {
                            TrialBanner(daysLeft: subscriptionService.trialDaysRemaining) {
                                appState.currentScreen = .paywall
                            }
                        }

                        HomeHeader(child: child, greeting: greeting,
                                   onLevelTap: { showLevelPicker = true },
                                   onSettingsTap: { showQuickSettings = true })

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

                        PeerCompanionCard(child: child, starsUntilReward: starsUntilReward)

                        DailyScheduleCard(
                            child: child,
                            completedSteps: completedScheduleSteps,
                            onComplete: { idx in
                                withAnimation(.spring(response: 0.3)) {
                                    _ = completedScheduleSteps.insert(idx)
                                }
                            }
                        )

                        StatsRow(child: child, onRewardTap: { showReward = true })
                    }
                    Group {
                        SpacingReviewBanner(child: child)

                        Text(appState.currentLanguage.ui.whereToStart)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        ModuleGrid(child: child)

                        DailyStoryTeaser(child: child)
                    }

                    // Exercice bonus Mot Mystère
                    Button {
                        showBonusUnlock = true
                    } label: {
                        HStack(spacing: 12) {
                            Text("🎁").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ABAReviewService.isBonusUnlocked ? appState.currentLanguage.ui.mysteryWord : appState.currentLanguage.ui.unlockBonus)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                                Text(ABAReviewService.isBonusUnlocked ? appState.currentLanguage.ui.abaGame : appState.currentLanguage.ui.leaveReview)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("textSecondary"))
                            }
                            Spacer()
                            Image(systemName: ABAReviewService.isBonusUnlocked ? "play.circle.fill" : "lock.fill")
                                .font(.system(size: 18))
                                .foregroundColor(ABAReviewService.isBonusUnlocked ? Color("accentGreen") : Color("accentOrange"))
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

                    // Accès espace parents (protégé par PIN)
                    NavigationLink {
                        ParentPINView(child: child)
                    } label: {
                        HStack(spacing: 12) {
                            Text("📊").font(.system(size: 22))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(appState.currentLanguage.ui.parentSpace)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color("textPrimary"))
                                Text(appState.currentLanguage.ui.parentSpaceDesc)
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
            .sheet(isPresented: $showQuickSettings) {
                QuickSettingsSheet(child: child)
                    .environmentObject(appState)
                    .environmentObject(dataStore)
            }
            .sheet(isPresented: $showLevelPicker) {
                LevelPickerSheet(currentLevel: child.schoolLevel) { level in
                    var updated = child
                    updated.schoolLevel = level
                    dataStore.updateChild(updated)
                }
            }
            .fullScreenCover(isPresented: $showReward) {
                RewardBreakView(child: child, onDismiss: { showReward = false })
            }
            .sheet(isPresented: $showBonusUnlock) {
                ABABonusUnlockView(isPresented: $showBonusUnlock, childName: child.firstName)
            }

            LeoPrimaryBubble(leo: leo)
                .padding(.bottom, 16)
                .allowsHitTesting(false)
            } // end ZStack
        }
        .onAppear {
            let today = ISO8601DateFormatter().string(from: Calendar.current.startOfDay(for: Date()))
            if scheduleDateString != today {
                scheduleDateString = today
                completedScheduleSteps = []
            }
            // Léo accueille l'enfant
            let lastActive = child.lastActiveAt
            let daysSince = Calendar.current.dateComponents([.day], from: lastActive, to: Date()).day ?? 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if daysSince >= 2 {
                    self.leo.speak(context: .returnAfterDays(firstName: self.child.firstName, days: daysSince))
                } else {
                    self.leo.speak(context: .welcome(firstName: self.child.firstName))
                }
            }
        }
        .onReceive(timer) { time in
            currentTime = time
        }
        .onDisappear { leo.stop() }
        .onChange(of: child.totalStars) { newValue in
            let cycle = newValue / rewardStarThreshold
            if cycle > lastRewardAt && newValue >= rewardStarThreshold {
                lastRewardAt = cycle
                withAnimation { showReward = true }
            }
        }
    }
}

// MARK: - Bandeau trial
struct TrialBanner: View {
    let daysLeft: Int
    let onUpgrade: () -> Void
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Button(action: onUpgrade) {
            HStack(spacing: 10) {
                Text(daysLeft <= 2 ? "🔴" : "🟡")
                Text(daysLeft == 0
                     ? appState.currentLanguage.ui.trialExpiresToday
                     : appState.currentLanguage.ui.trialDaysLeft(daysLeft))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                Text(appState.currentLanguage.ui.unlock)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(.white.opacity(0.25))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(daysLeft <= 2 ? Color.red.opacity(0.85) : Color("accentOrange"))
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Header avec changement de niveau
struct HomeHeader: View {
    let child: ChildProfile
    let greeting: String
    let onLevelTap: () -> Void
    let onSettingsTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting + " \(child.firstName) !")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("textPrimary"))

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
            // Bouton réglages rapides
            Button(action: onSettingsTap) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color("textSecondary").opacity(0.7))
                    .padding(8)
                    .background(Color("cardBackground"))
                    .clipShape(Circle())
            }
            AvatarCircle(name: child.avatarName, size: 56, isSelected: false)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Réglages rapides (accessible sans PIN)
struct QuickSettingsSheet: View {
    let child: ChildProfile
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("🌍 Langue de l'application") {
                    ForEach(AppLanguage.allCases, id: \.self) { lang in
                        Button {
                            appState.currentLanguage = lang
                        } label: {
                            HStack(spacing: 14) {
                                Text(lang.flag).font(.system(size: 22))
                                Text(lang.displayName)
                                    .foregroundColor(Color("textPrimary"))
                                Spacer()
                                if appState.currentLanguage == lang {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color("accentPurple"))
                                }
                            }
                        }
                    }
                }

                Section("🎓 Niveau scolaire") {
                    ForEach(SchoolLevel.allCases.filter { $0 != .level3 }, id: \.self) { level in
                        Button {
                            var updated = child
                            updated.schoolLevel = level
                            dataStore.updateChild(updated)
                            appState.selectedChild = updated
                        } label: {
                            HStack(spacing: 14) {
                                Text(level.emoji).font(.system(size: 22))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(level.displayName)
                                        .foregroundColor(Color("textPrimary"))
                                    Text(level.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("textSecondary"))
                                }
                                Spacer()
                                if child.schoolLevel == level {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color("accentGreen"))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(appState.currentLanguage.ui.settingsTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(appState.currentLanguage.ui.close) { dismiss() }
                        .foregroundColor(Color("accentPurple"))
                }
            }
        }
    }
}

// MARK: - Sélecteur de niveau (sheet)
struct LevelPickerSheet: View {
    let currentLevel: SchoolLevel
    let onSelect: (SchoolLevel) -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(appState.currentLanguage.ui.chooseLevel)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .padding(.top, 8)

                ForEach(SchoolLevel.allCases.filter { $0 != .level3 }, id: \.self) { level in
                    Button {
                        onSelect(level)
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
                            if currentLevel == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("accentPurple"))
                                    .font(.system(size: 22))
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(currentLevel == level
                                      ? Color("accentPurple").opacity(0.08)
                                      : Color("cardBackground"))
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(currentLevel == level
                                            ? Color("accentPurple")
                                            : Color("borderLight"),
                                            lineWidth: currentLevel == level ? 1.5 : 0.5))
                        )
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color("backgroundSoft").ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(appState.currentLanguage.ui.close) { dismiss() }
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
    @EnvironmentObject private var appState: AppState

    private var message: String {
        let msgs = appState.currentLanguage.ui.encouragementMessages
        return msgs[abs(child.firstName.hashValue) % msgs.count]
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color("accentGreen").opacity(0.15))
                    .frame(width: 52, height: 52)
                Text("🧒")
                    .font(.system(size: 28))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(appState.currentLanguage.ui.leoCompanion)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color("accentGreen"))
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(Color("textPrimary"))
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Text("⭐️")
                        .font(.system(size: 11))
                    Text(appState.currentLanguage.ui.starsUntilBreak(starsUntilReward))
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
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            Text(appState.currentLanguage.ui.howDoYouFeel(child.firstName))
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
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text("🌬️").font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.currentLanguage.ui.breathingExercise)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentBlue"))
                    Text(appState.currentLanguage.ui.breathingDesc)
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
    @EnvironmentObject private var appState: AppState

    var body: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(child.currentStreak)",
                     label: appState.currentLanguage.ui.consecutiveDays, emoji: "🔥")
            Button(action: onRewardTap) {
                StatCard(value: "\(child.totalStars)",
                         label: appState.currentLanguage.ui.starsRewards, emoji: "⭐️")
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
    @EnvironmentObject private var appState: AppState

    var wordsCount: Int {
        let today = Date()
        return child.wordProgresses.filter { wp in
            guard let nextReview = wp.nextReviewDate else { return false }
            return nextReview <= today && wp.masteryLevel != .mastered
        }.count
    }

    var body: some View {
        if wordsCount > 0 {
            HStack(spacing: 12) {
                Text("🔄").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.currentLanguage.ui.wordsToReview(wordsCount))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentOrange"))
                    Text(appState.currentLanguage.ui.quickReview)
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

    var modules: [(String, String, String, ModuleType)] {
        let ui = appState.currentLanguage.ui
        return [
            ("🗣️", ui.moduleSpeech,  "accentOrange", .diction),
            ("🎵", ui.moduleSong,    "accentPink",   .karaoke),
            ("📖", ui.moduleStory,   "accentPurple", .story),
            ("🔤", ui.moduleVocab,   "accentBlue",   .vocabulary),
            ("🔢", ui.moduleNumbers, "accentGreen",  .numbers),
            ("✏️", ui.moduleDrawing, "accentYellow", .drawing)
        ]
    }

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
                               isPrimary: index == 0,
                               startHereLabel: appState.currentLanguage.ui.startHere)
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
    var startHereLabel: String = "Commence ici !"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(emoji).font(.system(size: isPrimary ? 42 : 36))
            Text(title)
                .font(.system(size: isPrimary ? 18 : 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            if isPrimary {
                Text(startHereLabel)
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
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.currentLanguage.ui.storyOfDay)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            Text(appState.currentLanguage.ui.dailyStoryDesc(child.firstName))
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
    @EnvironmentObject private var appState: AppState

    struct ScheduleStep {
        let emoji: String
        let title: String
        let subtitle: String
        let color: String
    }

    private var steps: [ScheduleStep] {
        let hour = Calendar.current.component(.hour, from: Date())
        let raw = appState.currentLanguage.ui.dailySteps
        var list = raw.map { ScheduleStep(emoji: $0.emoji, title: $0.title, subtitle: $0.subtitle, color: $0.color) }
        if hour >= 14 {
            let a = appState.currentLanguage.ui.afternoonStep
            list[1] = ScheduleStep(emoji: a.emoji, title: a.title, subtitle: a.subtitle, color: a.color)
        }
        return list
    }

    var doneCount: Int { completedSteps.count }
    var totalCount: Int { steps.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.currentLanguage.ui.dailySchedule)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Text(appState.currentLanguage.ui.stepsCompleted(doneCount, totalCount))
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
    @EnvironmentObject private var appState: AppState

    @State private var selectedIndex: Int? = nil
    @State private var timeRemaining = 300
    @State private var timerActive = false
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var activities: [(emoji: String, name: String, isVideo: Bool)] {
        appState.currentLanguage.ui.rewardActivities
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
                VStack(spacing: 12) {
                    Text("🎉").font(.system(size: 72))
                    Text(appState.currentLanguage.ui.bravoFull(child.firstName))
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Text(appState.currentLanguage.ui.breakEarned(rewardStarThreshold))
                        .font(.system(size: 16))
                        .foregroundColor(Color("textSecondary"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                if let idx = selectedIndex, idx < activities.count {
                    let activity = activities[idx]
                    VStack(spacing: 16) {
                        Text(activity.emoji).font(.system(size: 56))
                        Text(activity.name)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                        Text(activity.isVideo
                             ? appState.currentLanguage.ui.miniFilm
                             : appState.currentLanguage.ui.interactiveGame)
                            .font(.system(size: 14))
                            .foregroundColor(Color("textSecondary"))
                        Text(timeLabel)
                            .font(.system(size: 48, weight: .light, design: .rounded))
                            .foregroundColor(Color("accentOrange"))
                        Text(appState.currentLanguage.ui.timeRemainingBreak)
                            .font(.system(size: 13))
                            .foregroundColor(Color("textSecondary"))
                    }
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 24).fill(Color("cardBackground")))
                    .padding(.horizontal, 24)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appState.currentLanguage.ui.chooseActivity)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .padding(.horizontal, 4)

                        ForEach(Array(activities.enumerated()), id: \.offset) { idx, activity in
                            Button {
                                selectedIndex = idx
                                timerActive = true
                            } label: {
                                HStack(spacing: 14) {
                                    Text(activity.emoji).font(.system(size: 28))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(activity.name)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(Color("textPrimary"))
                                        Text(activity.isVideo
                                             ? appState.currentLanguage.ui.miniFilmShort
                                             : appState.currentLanguage.ui.interactiveGameShort)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("textSecondary"))
                                    }
                                    Spacer()
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(Color("accentPurple"))
                                        .font(.system(size: 22))
                                }
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color("cardBackground")))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()

                Button { onDismiss() } label: {
                    Text(selectedIndex == nil
                         ? appState.currentLanguage.ui.notNow
                         : appState.currentLanguage.ui.endBreak)
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
