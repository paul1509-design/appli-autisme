import SwiftUI
import SwiftData

struct CollegeParentDashboard: View {
    let student: CollegeProfile
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Résumé général
                    OverallSummaryCard(student: student)

                    // Progression par matière
                    Text("Progression par matière")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    SubjectProgressGrid(student: student)

                    // Historique des 7 derniers jours
                    WeekHistoryCard(student: student)

                    // Conseils ABA parents
                    ParentAdviceCard(student: student)

                    Spacer(minLength: 24)
                }
                .padding(.vertical, 16)
            }
            .background(Color("backgroundSoft"))
            .navigationTitle("Espace Parents")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }.foregroundColor(Color("accentPurple"))
                }
            }
        }
    }
}

// MARK: - Résumé global
struct OverallSummaryCard: View {
    let student: CollegeProfile

    var totalSessions: Int { student.sessions.count }
    var avgRate: Double {
        guard !student.sessions.isEmpty else { return 0 }
        return student.sessions.map { $0.successRate }.reduce(0, +) / Double(student.sessions.count)
    }
    var totalMinutes: Int {
        student.sessions.reduce(0) { $0 + $1.durationSeconds } / 60
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("📊 \(student.firstName) — \(student.level.rawValue)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            HStack(spacing: 12) {
                DashStat(value: "\(totalSessions)", label: "sessions", emoji: "📅")
                DashStat(value: "\(Int(avgRate * 100))%", label: "réussite moy.", emoji: "🎯")
                DashStat(value: "\(totalMinutes) min", label: "temps total", emoji: "⏱️")
                DashStat(value: "\(student.totalStars)", label: "étoiles", emoji: "⭐️")
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

struct DashStat: View {
    let value: String; let label: String; let emoji: String
    var body: some View {
        VStack(spacing: 3) {
            Text(emoji).font(.system(size: 20))
            Text(value).font(.system(size: 16, weight: .medium)).foregroundColor(Color("textPrimary"))
            Text(label).font(.system(size: 9)).foregroundColor(Color("textSecondary")).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Grille de progression par matière
struct SubjectProgressGrid: View {
    let student: CollegeProfile

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 12) {
            ForEach(CollegeSubject.allCases, id: \.self) { subject in
                SubjectProgressCard(subject: subject, student: student)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SubjectProgressCard: View {
    let subject: CollegeSubject
    let student: CollegeProfile

    var sessions: [CollegeSession] { student.sessions.filter { $0.subject == subject.rawValue } }
    var avgRate: Double {
        guard !sessions.isEmpty else { return -1 }
        return sessions.map { $0.successRate }.reduce(0, +) / Double(sessions.count)
    }
    var trend: String {
        guard sessions.count >= 2 else { return "" }
        let last = sessions.last!.successRate
        let prev = sessions[sessions.count - 2].successRate
        return last > prev ? "↗️" : last < prev ? "↘️" : "→"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(subject.emoji).font(.system(size: 24))
                Spacer()
                Text(trend).font(.system(size: 14))
            }
            Text(subject.rawValue)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            if avgRate >= 0 {
                VStack(alignment: .leading, spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3).fill(Color("borderLight")).frame(height: 5)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(subject.color))
                                .frame(width: geo.size.width * avgRate, height: 5)
                        }
                    }
                    .frame(height: 5)
                    Text("\(Int(avgRate * 100))% de réussite • \(sessions.count) session\(sessions.count > 1 ? "s" : "")")
                        .font(.system(size: 10))
                        .foregroundColor(Color("textSecondary"))
                }
            } else {
                Text("Non commencé")
                    .font(.system(size: 11))
                    .foregroundColor(Color("textSecondary"))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(subject.color).opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(subject.color).opacity(0.2), lineWidth: 0.5))
        )
    }
}

// MARK: - Historique 7 jours
struct WeekHistoryCard: View {
    let student: CollegeProfile

    var last7Days: [(String, Double)] {
        let cal = Calendar.current
        return (0..<7).reversed().map { offset -> (String, Double) in
            let date = cal.date(byAdding: .day, value: -offset, to: Date())!
            let dayLabel = DateFormatter().apply {
                $0.dateFormat = "EE"
                $0.locale = Locale(identifier: "fr_FR")
            }.string(from: date).prefix(2).capitalized
            let daySessions = student.sessions.filter { cal.isDate($0.date, inSameDayAs: date) }
            let rate = daySessions.isEmpty ? 0.0 : daySessions.map { $0.successRate }.reduce(0, +) / Double(daySessions.count)
            return (dayLabel, rate)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("📅 7 derniers jours")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(last7Days, id: \.0) { day, rate in
                    VStack(spacing: 4) {
                        if rate > 0 {
                            Text("\(Int(rate * 100))%")
                                .font(.system(size: 9))
                                .foregroundColor(Color("textSecondary"))
                        }
                        RoundedRectangle(cornerRadius: 4)
                            .fill(rate > 0 ? Color("accentPurple") : Color("borderLight"))
                            .frame(height: max(6, 80 * rate))
                        Text(day)
                            .font(.system(size: 10))
                            .foregroundColor(Color("textSecondary"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 100)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Conseils ABA pour parents d'ado
struct ParentAdviceCard: View {
    let student: CollegeProfile

    var avgRate: Double {
        guard !student.sessions.isEmpty else { return 0 }
        return student.sessions.suffix(5).map { $0.successRate }.reduce(0, +) / Double(min(5, student.sessions.count))
    }

    var advice: (String, String) {
        if student.sessions.isEmpty {
            return ("Démarrer", "Commencez par la matière préférée de \(student.firstName) pour créer une routine positive. La régularité (15-20 min/jour) est plus efficace que de longues sessions.")
        } else if avgRate >= 0.8 {
            return ("Excellent niveau !", "Le taux de réussite de \(student.firstName) est très bon. Augmentez la difficulté ou explorez de nouvelles matières pour maintenir la motivation.")
        } else if avgRate >= 0.6 {
            return ("Bon progrès", "Encouragez \(student.firstName) à utiliser les indices ABA (💡) sans honte — ils sont là pour aider. Célébrez chaque étoile gagnée.")
        } else {
            return ("Besoin de soutien", "Si le taux de réussite est faible, réduisez la session à 4 exercices et alternez matières difficiles et matières aimées. Le renforcement positif prime.")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text("🧠").font(.system(size: 22))
                Text("Conseil ABA — \(advice.0)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("accentPurple"))
            }
            Text(advice.1)
                .font(.system(size: 13))
                .foregroundColor(Color("textSecondary"))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("accentPurple").opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("accentPurple").opacity(0.15), lineWidth: 0.5))
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Extension utilitaire
extension DateFormatter {
    func apply(_ configure: (DateFormatter) -> Void) -> DateFormatter {
        configure(self); return self
    }
}
