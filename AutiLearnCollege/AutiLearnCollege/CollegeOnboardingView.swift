import SwiftUI
import SwiftData

struct CollegeOnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    let onComplete: (CollegeProfile) -> Void

    @State private var firstName: String = ""
    @State private var selectedLevel: CollegeLevel = .sixieme
    @State private var selectedAvatar: String = "🧒"
    @State private var step: Int = 0

    let avatars = ["🧒", "👦", "👧", "🧑", "🧑‍🦱", "🧑‍🦰", "🧑‍🦳"]

    var body: some View {
        ZStack {
            Color("backgroundSoft").ignoresSafeArea()

            VStack(spacing: 32) {
                // Indicateur d'étape
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(i <= step ? Color("accentPurple") : Color("borderLight"))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 24)

                Spacer()

                if step == 0 {
                    // Étape 1 : Prénom
                    VStack(spacing: 24) {
                        Text("👋").font(.system(size: 56))
                        VStack(spacing: 8) {
                            Text("Bienvenue sur ABA Collège !")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(Color("textPrimary"))
                                .multilineTextAlignment(.center)
                            Text("Quel est le prénom de votre enfant ?")
                                .font(.system(size: 16))
                                .foregroundColor(Color("textSecondary"))
                        }
                        TextField("Prénom...", text: $firstName)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                            .padding(16)
                            .background(Color("cardBackground"))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color("accentPurple").opacity(0.4), lineWidth: 1))
                    }

                } else if step == 1 {
                    // Étape 2 : Avatar
                    VStack(spacing: 24) {
                        Text("Choisis un avatar pour \(firstName)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.center)
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
                            ForEach(avatars, id: \.self) { avatar in
                                Button {
                                    selectedAvatar = avatar
                                } label: {
                                    Text(avatar).font(.system(size: 36))
                                        .frame(width: 64, height: 64)
                                        .background(
                                            Circle().fill(selectedAvatar == avatar
                                                          ? Color("accentPurple").opacity(0.2)
                                                          : Color("cardBackground"))
                                                .overlay(Circle().stroke(selectedAvatar == avatar
                                                                         ? Color("accentPurple") : Color("borderLight"),
                                                                         lineWidth: selectedAvatar == avatar ? 2 : 0.5))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                } else {
                    // Étape 3 : Niveau
                    VStack(spacing: 20) {
                        Text("Quel est le niveau de \(firstName) ?")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                            .multilineTextAlignment(.center)
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(CollegeLevel.allCases, id: \.self) { level in
                                    Button {
                                        selectedLevel = level
                                    } label: {
                                        HStack(spacing: 14) {
                                            Text(level.emoji).font(.system(size: 24))
                                            VStack(alignment: .leading, spacing: 2) {
                                                HStack(spacing: 8) {
                                                    Text(level.rawValue)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(Color("textPrimary"))
                                                    if level.isLycee {
                                                        Text("Lycée")
                                                            .font(.system(size: 10, weight: .medium))
                                                            .foregroundColor(Color("accentPurple"))
                                                            .padding(.horizontal, 5).padding(.vertical, 2)
                                                            .background(Color("accentPurple").opacity(0.1))
                                                            .cornerRadius(4)
                                                    }
                                                }
                                                Text(level.ageRange)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(Color("textSecondary"))
                                            }
                                            Spacer()
                                            if selectedLevel == level {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(Color("accentPurple"))
                                            }
                                        }
                                        .padding(14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedLevel == level
                                                      ? Color("accentPurple").opacity(0.08) : Color("cardBackground"))
                                                .overlay(RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedLevel == level
                                                            ? Color("accentPurple") : Color("borderLight"),
                                                            lineWidth: selectedLevel == level ? 1.5 : 0.5))
                                        )
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer()

                Button {
                    if step < 2 {
                        withAnimation { step += 1 }
                    } else {
                        let profile = CollegeProfile(firstName: firstName.isEmpty ? "Élève" : firstName,
                                                     avatarName: selectedAvatar,
                                                     level: selectedLevel)
                        modelContext.insert(profile)
                        try? modelContext.save()
                        onComplete(profile)
                    }
                } label: {
                    Text(step < 2 ? "Continuer →" : "Commencer !")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(step == 0 && firstName.trimmingCharacters(in: .whitespaces).isEmpty
                                    ? Color("textSecondary").opacity(0.4) : Color("accentPurple"))
                        .cornerRadius(16)
                }
                .disabled(step == 0 && firstName.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}
