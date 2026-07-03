import SwiftUI
import SwiftData

struct CollegeHomeView: View {
    let student: CollegeProfile
    @Environment(\.modelContext) private var modelContext
    @State private var showLevelPicker = false

    var recentRate: Double {
        let recent = student.sessions.suffix(5)
        guard !recent.isEmpty else { return 0 }
        return recent.map { $0.successRate }.reduce(0, +) / Double(recent.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // En-tête
                    CollegeHeader(student: student, onLevelTap: { showLevelPicker = true })

                    // Stats rapides
                    HStack(spacing: 12) {
                        CollegeStatCard(value: "\(student.currentStreak)", label: "jours streak", emoji: "🔥")
                        CollegeStatCard(value: "\(student.totalStars)", label: "étoiles", emoji: "⭐️")
                        CollegeStatCard(value: "\(Int(recentRate * 100))%", label: "réussite récente", emoji: "🎯")
                    }
                    .padding(.horizontal, 20)

                    // Motivation ABA
                    ABAMotivationCard(student: student, rate: recentRate)

                    // Matières
                    Text("Choisir une matière")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 12) {
                        ForEach(CollegeSubject.allCases, id: \.self) { subject in
                            NavigationLink {
                                CollegeSessionView(student: student, subject: subject)
                            } label: {
                                CollegeSubjectCard(subject: subject, student: student)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Espace parents
                    NavigationLink {
                        CollegeParentDashboard(student: student)
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
            .navigationBarHidden(true)
            .sheet(isPresented: $showLevelPicker) {
                CollegeLevelPicker(student: student)
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
