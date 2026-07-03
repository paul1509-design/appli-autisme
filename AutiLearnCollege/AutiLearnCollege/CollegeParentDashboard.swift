import SwiftUI
import SwiftData

struct CollegeParentDashboard: View {
    let student: CollegeProfile
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Onglets
                HStack(spacing: 0) {
                    ForEach([(0, "Suivi"), (1, "Rappels"), (2, "Guide"), (3, "Support")], id: \.0) { idx, label in
                        Button {
                            withAnimation { selectedTab = idx }
                        } label: {
                            Text(label)
                                .font(.system(size: 13, weight: selectedTab == idx ? .medium : .regular))
                                .foregroundColor(selectedTab == idx ? Color("accentPurple") : Color("textSecondary"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                    }
                }
                .background(Color("cardBackground"))
                .overlay(Divider(), alignment: .bottom)

                ScrollView {
                    VStack(spacing: 20) {
                        if selectedTab == 0 {
                            OverallSummaryCard(student: student)
                            Text("Progression par matière")
                                .font(.system(size: 17, weight: .medium)).foregroundColor(Color("textPrimary"))
                                .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                            SubjectProgressGrid(student: student)
                            CollegeExerciseMasteryCard(student: student)
                            WeekHistoryCard(student: student)
                            ParentAdviceCard(student: student)
                            CollegePDFShareButton(student: student)
                                .padding(.horizontal, 20)
                        } else if selectedTab == 1 {
                            CollegeReminderSettingsCard(student: student)
                        } else if selectedTab == 2 {
                            CollegeGuideTab()
                        } else {
                            CollegeSupportTab()
                        }
                        Spacer(minLength: 24)
                    }
                    .padding(.vertical, 16)
                }
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
        .onAppear { CollegeNotificationService.requestPermission() }
    }
}

// MARK: - Card maîtrise des exercices
struct CollegeExerciseMasteryCard: View {
    let student: CollegeProfile

    var mastered: Int  { student.exerciseProgresses.filter { $0.masteryLevel == "mastered" }.count }
    var reviewing: Int { student.exerciseProgresses.filter { $0.masteryLevel == "reviewing" }.count }
    var learning: Int  { student.exerciseProgresses.filter { $0.masteryLevel == "learning" }.count }
    var total: Int     { student.exerciseProgresses.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Maîtrise des exercices")
                .font(.system(size: 15, weight: .medium)).foregroundColor(Color("textPrimary"))
            HStack(spacing: 0) {
                MasteryBar(count: mastered,  total: total, color: Color("accentGreen"),  label: "Maîtrisés")
                MasteryBar(count: reviewing, total: total, color: Color("accentOrange"), label: "Révision")
                MasteryBar(count: learning,  total: total, color: Color("accentBlue"),   label: "En cours")
            }
            .frame(height: 12).clipShape(RoundedRectangle(cornerRadius: 6))
            HStack(spacing: 16) {
                MasteryLegend(emoji: "⭐️", label: "Maîtrisés", count: mastered)
                MasteryLegend(emoji: "🔄", label: "Révision",  count: reviewing)
                MasteryLegend(emoji: "📚", label: "En cours",  count: learning)
                MasteryLegend(emoji: "🆕", label: "Nouveau",   count: max(0, total - mastered - reviewing - learning))
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color("cardBackground"))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("borderLight"), lineWidth: 0.5)))
        .padding(.horizontal, 20)
    }
}

private struct MasteryBar: View {
    let count: Int; let total: Int; let color: Color; let label: String
    var fraction: CGFloat { total > 0 ? CGFloat(count) / CGFloat(total) : 0 }
    var body: some View {
        color.frame(maxWidth: .infinity * fraction)
    }
}

private struct MasteryLegend: View {
    let emoji: String; let label: String; let count: Int
    var body: some View {
        VStack(spacing: 2) {
            Text(emoji).font(.system(size: 14))
            Text("\(count)").font(.system(size: 13, weight: .medium)).foregroundColor(Color("textPrimary"))
            Text(label).font(.system(size: 10)).foregroundColor(Color("textSecondary"))
        }
    }
}

// MARK: - Paramètres rappels
struct CollegeReminderSettingsCard: View {
    @Bindable var student: CollegeProfile
    @State private var selectedHour: Int = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔔 Rappels quotidiens")
                .font(.system(size: 17, weight: .medium)).foregroundColor(Color("textPrimary"))

            Text("Recevez une notification chaque jour pour maintenir la routine — essentielle pour les jeunes TSA.")
                .font(.system(size: 13)).foregroundColor(Color("textSecondary")).lineSpacing(4)

            Toggle("Activer les rappels", isOn: $student.reminderEnabled)
                .font(.system(size: 15))
                .tint(Color("accentPurple"))
                .onChange(of: student.reminderEnabled) { _, enabled in
                    if enabled {
                        CollegeNotificationService.scheduleDailyReminder(
                            studentName: student.firstName,
                            hour: student.reminderHour,
                            language: student.language)
                    } else {
                        CollegeNotificationService.cancelReminder()
                    }
                }

            if student.reminderEnabled {
                HStack {
                    Text("Heure du rappel")
                        .font(.system(size: 15)).foregroundColor(Color("textPrimary"))
                    Spacer()
                    Picker("Heure", selection: $student.reminderHour) {
                        ForEach(6..<22, id: \.self) { h in
                            Text("\(h):00").tag(h)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Color("accentPurple"))
                    .onChange(of: student.reminderHour) { _, hour in
                        CollegeNotificationService.scheduleDailyReminder(
                            studentName: student.firstName, hour: hour,
                            language: student.language)
                    }
                }

                Text("Le rappel sera envoyé tous les jours à \(student.reminderHour):00.")
                    .font(.system(size: 12)).foregroundColor(Color("textSecondary"))
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color("cardBackground"))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color("borderLight"), lineWidth: 0.5)))
        .padding(.horizontal, 20)
        .onAppear {
            selectedHour = student.reminderHour
            if student.reminderEnabled {
                CollegeNotificationService.scheduleDailyReminder(
                    studentName: student.firstName,
                    hour: student.reminderHour,
                    language: student.language)
            }
        }
    }
}

// MARK: - Onglet Guide (ado)
struct CollegeGuideTab: View {
    let sections: [(String, String, [String])] = [
        ("🧠", "Comprendre le TSA chez l'ado", [
            "Pourquoi le collège est souvent un point de rupture",
            "Profil sensoriel et surcharge au lycée",
            "Anxiété scolaire et TSA — différencier et agir",
            "La double empathie — mythe ou réalité ?"
        ]),
        ("🏠", "À la maison", [
            "Routine et prévisibilité : comment structurer la semaine",
            "Sommeil : 9-10 heures essentielles pour l'ado TSA",
            "Alimentation cérébrale (oméga-3, magnésium, vitamine D3)",
            "Gérer les crises émotionnelles à l'adolescence"
        ]),
        ("🧬", "Examens recommandés", [
            "Bilan neuropsychologique — QI, mémoire, attention",
            "qEEG (cartographie cérébrale) pour identifier les patterns",
            "IRM DTI (connectivité des faisceaux blancs)",
            "Bilan sensoriel avec ergothérapeute"
        ]),
        ("💪", "Thérapies et aides", [
            "ABA adapté à l'ado : autonomie et généralisation",
            "TCC adaptée TSA — gestion émotionnelle",
            "Neurofeedback (tACS) — preuves et limites",
            "Sport adapté : natation, escalade, arts martiaux doux"
        ]),
        ("👥", "Socialisation & droits", [
            "Groupes de pairs TSA — trouver une communauté",
            "MDPH : renouvellement et dossier lycée",
            "PAP / PPS au lycée — ce qu'on peut demander",
            "Orientation post-bac pour jeune avec TSA"
        ])
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(sections, id: \.0) { emoji, title, items in
                CollegeGuideSection(emoji: emoji, title: title, items: items)
            }
        }
        .padding(.horizontal, 20).padding(.top, 8)
    }
}

struct CollegeGuideSection: View {
    let emoji: String; let title: String; let items: [String]
    @State private var expanded = false
    var body: some View {
        VStack(spacing: 0) {
            Button { withAnimation(.spring()) { expanded.toggle() } } label: {
                HStack(spacing: 12) {
                    Text(emoji).font(.system(size: 20))
                    Text(title).font(.system(size: 14, weight: .medium)).foregroundColor(Color("textPrimary"))
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12)).foregroundColor(Color("textSecondary"))
                }
                .padding(14)
            }
            if expanded {
                Divider().opacity(0.3)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Circle().fill(Color("accentPurple")).frame(width: 5, height: 5).padding(.top, 6)
                            Text(item).font(.system(size: 13)).foregroundColor(Color("textSecondary")).lineSpacing(3)
                        }
                    }
                }
                .padding(14)
            }
        }
        .background(RoundedRectangle(cornerRadius: 14).fill(Color("cardBackground"))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("borderLight"), lineWidth: 0.5)))
    }
}

// MARK: - Onglet Support (ado)
struct CollegeSupportTab: View {
    let items: [(String, String, String, String)] = [
        ("🧠", "Neurologique", "Neuropédiatre spé TSA, qEEG, neurofeedback, tACS neuromodulation", "accentPurple"),
        ("💬", "Psychologique", "TCC adaptée TSA, thérapie familiale, coaching émotionnel ado", "accentBlue"),
        ("🏃", "Sport & corps", "Natation, escalade, arts martiaux doux, équithérapie adaptée", "accentGreen"),
        ("🍽️", "Nutrition cérébrale", "Oméga-3 DHA, magnésium bisglycinate, vitamine D3+K2, zinc, probiotiques", "accentOrange"),
        ("👥", "Associations", "Autism France, Sésame Autisme, CRA régionaux, groupes de pairs ado", "accentPink"),
        ("⚖️", "Administratif", "MDPH, AEEH, PAP lycée, PPS, orientation post-bac adaptée TSA", "accentYellow"),
    ]
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items, id: \.0) { emoji, title, desc, color in
                HStack(alignment: .top, spacing: 14) {
                    Text(emoji).font(.system(size: 24)).frame(width: 36)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title).font(.system(size: 14, weight: .medium)).foregroundColor(Color("textPrimary"))
                        Text(desc).font(.system(size: 12)).foregroundColor(Color("textSecondary")).lineSpacing(3)
                    }
                }
                .padding(14).frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(color).opacity(0.06))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(color).opacity(0.2), lineWidth: 0.5)))
            }
        }
        .padding(.horizontal, 20).padding(.top, 8)
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
