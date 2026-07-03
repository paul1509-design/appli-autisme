import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState

    @State private var currentStep: Int = 0
    @State private var childName: String = ""
    @State private var selectedLevel: SchoolLevel = .level0
    @State private var selectedComm: CommunicationLevel = .emerging
    @State private var selectedAvatar: String = "avatar_star"
    @State private var selectedTeacher: String = "teacher_luna"
    @State private var selectedLanguage: AppLanguage = .french

    private let totalSteps = 5

    var body: some View {
        ZStack {
            // Fond doux TSA-friendly
            Color("backgroundSoft")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Barre de progression
                ProgressBar(current: currentStep + 1, total: totalSteps)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                // Contenu de l'étape
                TabView(selection: $currentStep) {
                    WelcomeStep().tag(0)
                    LanguageStep(selectedLanguage: $selectedLanguage).tag(1)
                    ChildNameStep(childName: $childName).tag(2)
                    LevelStep(selectedLevel: $selectedLevel,
                              selectedComm: $selectedComm).tag(3)
                    AvatarStep(selectedAvatar: $selectedAvatar,
                               selectedTeacher: $selectedTeacher).tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)

                // Bouton navigation
                NavigationButtons(
                    currentStep: currentStep,
                    totalSteps: totalSteps,
                    canAdvance: canAdvanceFromCurrentStep,
                    onBack: { withAnimation { currentStep -= 1 } },
                    onNext: handleNext
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }

    private var canAdvanceFromCurrentStep: Bool {
        switch currentStep {
        case 2: return !childName.trimmingCharacters(in: .whitespaces).isEmpty
        default: return true
        }
    }

    private func handleNext() {
        if currentStep < totalSteps - 1 {
            withAnimation { currentStep += 1 }
        } else {
            createProfile()
        }
    }

    private func createProfile() {
        let child = ChildProfile(
            firstName: childName.trimmingCharacters(in: .whitespaces),
            avatarName: selectedAvatar,
            schoolLevel: selectedLevel,
            communicationLevel: selectedComm
        )
        child.teacherAvatarName = selectedTeacher
        appState.currentLanguage = selectedLanguage
        modelContext.insert(child)
        try? modelContext.save()
        appState.selectChild(child)
        appState.completeOnboarding()
    }
}

// MARK: - Étape 1 : Bienvenue
struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🌟")
                .font(.system(size: 80))
            Text("Bienvenue dans\nAutiLearn")
                .font(.system(size: 28, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("textPrimary"))
            Text("L'école à la maison,\nadaptée à votre enfant")
                .font(.system(size: 17))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("textSecondary"))
                .lineSpacing(4)
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

// MARK: - Étape 2 : Langue
struct LanguageStep: View {
    @Binding var selectedLanguage: AppLanguage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Choisissez la langue")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            VStack(spacing: 12) {
                ForEach(AppLanguage.allCases, id: \.self) { lang in
                    LanguageCard(language: lang,
                                 isSelected: selectedLanguage == lang)
                        .onTapGesture { selectedLanguage = lang }
                }
            }
            .padding(.horizontal, 24)
            Spacer()
            Spacer()
        }
    }
}

struct LanguageCard: View {
    let language: AppLanguage
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            Text(language.flag)
                .font(.system(size: 32))
            Text(language.displayName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("accentPurple"))
                    .font(.system(size: 22))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color("accentPurple").opacity(0.1) : Color("cardBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color("accentPurple") : Color("borderLight"),
                                lineWidth: isSelected ? 2 : 0.5)
                )
        )
    }
}

// MARK: - Étape 3 : Prénom
struct ChildNameStep: View {
    @Binding var childName: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Comment s'appelle\nvotre enfant ?")
                .font(.system(size: 22, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("textPrimary"))

            TextField("Prénom", text: $childName)
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color("cardBackground"))
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("accentPurple").opacity(0.5), lineWidth: 1))
                )
                .padding(.horizontal, 32)
                .focused($isFocused)

            Spacer()
            Spacer()
        }
        .onAppear { isFocused = true }
    }
}

// MARK: - Étape 4 : Niveau scolaire
struct LevelStep: View {
    @Binding var selectedLevel: SchoolLevel
    @Binding var selectedComm: CommunicationLevel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Niveau scolaire")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 10) {
                    ForEach(SchoolLevel.allCases.filter { $0 != .level3 }, id: \.self) { level in
                        LevelCard(level: level, isSelected: selectedLevel == level)
                            .onTapGesture { selectedLevel = level }
                    }
                }

                Text("Niveau de communication")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                VStack(spacing: 10) {
                    ForEach(CommunicationLevel.allCases, id: \.self) { comm in
                        CommCard(comm: comm, isSelected: selectedComm == comm)
                            .onTapGesture { selectedComm = comm }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
}

struct LevelCard: View {
    let level: SchoolLevel
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(level.emoji)
                .font(.system(size: 28))
            Text(level.displayName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("accentPurple"))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color("accentPurple").opacity(0.08) : Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("accentPurple") : Color("borderLight"),
                            lineWidth: isSelected ? 1.5 : 0.5))
        )
    }
}

struct CommCard: View {
    let comm: CommunicationLevel
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(comm.displayName)
                .font(.system(size: 15))
                .foregroundColor(Color("textPrimary"))
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("accentGreen"))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color("accentGreen").opacity(0.08) : Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("accentGreen") : Color("borderLight"),
                            lineWidth: isSelected ? 1.5 : 0.5))
        )
    }
}

// MARK: - Étape 5 : Choix avatar
struct AvatarStep: View {
    @Binding var selectedAvatar: String
    @Binding var selectedTeacher: String

    let avatars = ["avatar_star", "avatar_rocket", "avatar_lion",
                   "avatar_butterfly", "avatar_robot", "avatar_cat"]
    let teachers = ["teacher_luna", "teacher_leo", "teacher_maya", "teacher_sam"]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    Text("L'avatar de \nvotre enfant")
                        .font(.system(size: 20, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("textPrimary"))

                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3),
                              spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            AvatarCircle(name: avatar, size: 72,
                                         isSelected: selectedAvatar == avatar)
                                .onTapGesture { selectedAvatar = avatar }
                        }
                    }
                }

                Divider().opacity(0.3)

                VStack(spacing: 16) {
                    Text("Le professeur ABA")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Text("Il guidera votre enfant avec bienveillance")
                        .font(.system(size: 14))
                        .foregroundColor(Color("textSecondary"))

                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2),
                              spacing: 12) {
                        ForEach(teachers, id: \.self) { teacher in
                            TeacherCard(name: teacher,
                                        isSelected: selectedTeacher == teacher)
                                .onTapGesture { selectedTeacher = teacher }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
}

struct AvatarCircle: View {
    let name: String
    let size: CGFloat
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(Color("accentPurple").opacity(isSelected ? 0.15 : 0.05))
                .frame(width: size, height: size)
                .overlay(Circle().stroke(
                    isSelected ? Color("accentPurple") : Color.clear,
                    lineWidth: 2.5))
            // Placeholder emoji — remplacé par Image(avatar) en prod
            Text(avatarEmoji(name))
                .font(.system(size: size * 0.45))
        }
    }

    private func avatarEmoji(_ name: String) -> String {
        let map = ["avatar_star": "⭐️", "avatar_rocket": "🚀",
                   "avatar_lion": "🦁", "avatar_butterfly": "🦋",
                   "avatar_robot": "🤖", "avatar_cat": "🐱"]
        return map[name] ?? "⭐️"
    }
}

struct TeacherCard: View {
    let name: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color("accentGreen").opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(Text(teacherEmoji(name)).font(.system(size: 28)))
            Text(teacherDisplayName(name))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color("textPrimary"))
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color("accentGreen").opacity(0.08) : Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color("accentGreen") : Color("borderLight"),
                            lineWidth: isSelected ? 1.5 : 0.5))
        )
    }

    private func teacherEmoji(_ name: String) -> String {
        let map = ["teacher_luna": "👩‍🏫", "teacher_leo": "👨‍🏫",
                   "teacher_maya": "🧑‍🎓", "teacher_sam": "🧑‍🏫"]
        return map[name] ?? "👩‍🏫"
    }

    private func teacherDisplayName(_ name: String) -> String {
        let map = ["teacher_luna": "Luna", "teacher_leo": "Léo",
                   "teacher_maya": "Maya", "teacher_sam": "Sam"]
        return map[name] ?? name
    }
}

// MARK: - Composants réutilisables
struct ProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("borderLight"))
                    .frame(height: 6)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("accentPurple"))
                    .frame(width: geo.size.width * CGFloat(current) / CGFloat(total),
                           height: 6)
                    .animation(.spring(), value: current)
            }
        }
        .frame(height: 6)
    }
}

struct NavigationButtons: View {
    let currentStep: Int
    let totalSteps: Int
    let canAdvance: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if currentStep > 0 {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 50, height: 54)
                        .background(Color("cardBackground"))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("borderLight"), lineWidth: 0.5))
                }
                .foregroundColor(Color("textSecondary"))
            }

            Button(action: onNext) {
                HStack {
                    Text(currentStep == totalSteps - 1 ? "Commencer !" : "Continuer")
                        .font(.system(size: 17, weight: .medium))
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(canAdvance ? Color("accentPurple") : Color("textSecondary").opacity(0.3))
                .cornerRadius(14)
            }
            .disabled(!canAdvance)
        }
    }
}
