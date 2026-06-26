import SwiftUI
import SwiftData

struct HomeView: View {
    let child: ChildProfile
    @State private var showEmotionCheck = true
    @State private var selectedEmotion: EmotionState?
    @State private var showBreathing = false
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 6..<12:  return "Bonjour"
        case 12..<18:  return "Bon après-midi"
        default:       return "Bonsoir"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HomeHeader(child: child, greeting: greeting)

                    // Check émotion du jour
                    if showEmotionCheck && selectedEmotion == nil {
                        EmotionCheckCard(child: child) { emotion in
                            withAnimation(.spring()) {
                                selectedEmotion = emotion
                                showEmotionCheck = false
                                if emotion.needsRegulation {
                                    showBreathing = true
                                }
                            }
                        }
                    }

                    // Bannière si état difficile
                    if let emotion = selectedEmotion, emotion.needsRegulation {
                        BreathingBanner(onTap: { showBreathing = true })
                    }

                    // Streak et étoiles
                    StatsRow(child: child)

                    // Retest spacing effect (si mots à revoir aujourd'hui)
                    SpacingReviewBanner(child: child)

                    // Modules du jour
                    Text("Que veux-tu faire aujourd'hui ?")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    ModuleGrid(child: child)

                    // Conseil du jour (pour l'enfant)
                    DailyStoryTeaser(child: child)

                    Spacer(minLength: 20)
                }
                .padding(.vertical, 16)
            }
            .background(Color("backgroundSoft"))
            .navigationBarHidden(true)
            .sheet(isPresented: $showBreathing) {
                BreathingExerciseView()
            }
        }
        .onReceive(timer) { time in
            currentTime = time
        }
    }
}

// MARK: - Header
struct HomeHeader: View {
    let child: ChildProfile
    let greeting: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting + " \(child.firstName) !")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Text(child.schoolLevel.displayName)
                    .font(.system(size: 14))
                    .foregroundColor(Color("textSecondary"))
            }
            Spacer()
            AvatarCircle(name: child.avatarName, size: 56, isSelected: false)
        }
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
                Text("🌬️")
                    .font(.system(size: 24))
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
                    .foregroundColor(Color("textSecondary"))
                    .font(.system(size: 13))
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

    var body: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(child.currentStreak)",
                     label: "jours consécutifs", emoji: "🔥")
            StatCard(value: "\(child.totalStars)",
                     label: "étoiles gagnées", emoji: "⭐️")
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
            Text(emoji)
                .font(.system(size: 28))
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
                Text("🔄")
                    .font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(wordsToReview) mots à réviser aujourd'hui")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("accentOrange"))
                    Text("Révision rapide — 3 minutes !")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("textSecondary"))
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

// MARK: - Grille des modules
struct ModuleGrid: View {
    let child: ChildProfile

    let modules: [(String, String, String, ModuleType)] = [
        ("📖", "Histoire du jour", "accentPurple", .story),
        ("🔤", "Vocabulaire", "accentBlue", .vocabulary),
        ("🔢", "Chiffres", "accentGreen", .numbers),
        ("🎤", "Diction", "accentOrange", .diction),
        ("🎵", "Karaoké", "accentPink", .karaoke),
        ("✏️", "Dessin", "accentYellow", .drawing)
    ]

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2),
                  spacing: 12) {
            ForEach(modules, id: \.0) { (emoji, title, color, moduleType) in
                NavigationLink {
                    LearningSessionView(child: child, moduleType: moduleType)
                } label: {
                    ModuleCard(emoji: emoji, title: title, colorName: color)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(emoji)
                .font(.system(size: 36))
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(colorName).opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(colorName).opacity(0.2), lineWidth: 0.5))
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
