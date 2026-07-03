import SwiftUI
import SwiftData

// MARK: - Dashboard Parents
struct ParentDashboardView: View {
    let child: ChildProfile
    @EnvironmentObject var subscriptionService: SubscriptionService
    @State private var selectedTab: ParentTab = .progress

    enum ParentTab: String, CaseIterable {
        case progress = "Progression"
        case guide    = "Guide"
        case support  = "Aide"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Espace Parents")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                        Text("Suivi de \(child.firstName)")
                            .font(.system(size: 14))
                            .foregroundColor(Color("textSecondary"))
                    }
                    Spacer()
                    // Badge trial si pas abonné
                    if !subscriptionService.isSubscribed {
                        TrialBadge(daysLeft: subscriptionService.trialDaysRemaining)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Tabs
                HStack(spacing: 0) {
                    ForEach(ParentTab.allCases, id: \.self) { tab in
                        Button {
                            withAnimation { selectedTab = tab }
                        } label: {
                            Text(tab.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedTab == tab ?
                                                 Color("accentPurple") : Color("textSecondary"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .overlay(
                                    Rectangle()
                                        .fill(Color("accentPurple"))
                                        .frame(height: 2)
                                        .opacity(selectedTab == tab ? 1 : 0),
                                    alignment: .bottom
                                )
                        }
                    }
                }
                .overlay(
                    Rectangle().fill(Color("borderLight")).frame(height: 0.5),
                    alignment: .bottom
                )

                ScrollView {
                    switch selectedTab {
                    case .progress:
                        ProgressTabView(child: child)
                    case .guide:
                        GuideTabView()
                    case .support:
                        SupportTabView()
                    }
                }
                .background(Color("backgroundSoft"))
            }
            .background(Color("backgroundSoft"))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Onglet Progression
struct ProgressTabView: View {
    let child: ChildProfile

    var recentSessions: [LearningSession] {
        child.sessions.sorted { $0.date > $1.date }.prefix(14).map { $0 }
    }

    var thisWeekSessions: [LearningSession] {
        recentSessions.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
        }
    }

    var masteredWords: [WordProgress] { child.wordProgresses.filter { $0.masteryLevel == .mastered } }
    var learningWords: [WordProgress] { child.wordProgresses.filter { $0.masteryLevel == .learning } }

    var weeklySuccessRate: Double {
        guard !thisWeekSessions.isEmpty else { return 0 }
        return thisWeekSessions.map { $0.successRate }.reduce(0, +) / Double(thisWeekSessions.count)
    }

    var dueWords: [WordProgress] {
        let today = Date()
        return child.wordProgresses.filter { wp in
            guard let next = wp.nextReviewDate else { return false }
            return next <= today && wp.masteryLevel != .mastered
        }
    }

    // Données 7 derniers jours pour le graphique
    var last7DaysData: [(String, Double)] {
        let cal = Calendar.current
        return (0..<7).reversed().map { daysAgo -> (String, Double) in
            let date = cal.date(byAdding: .day, value: -daysAgo, to: Date())!
            let daySessions = recentSessions.filter {
                cal.isDate($0.date, inSameDayAs: date)
            }
            let rate = daySessions.isEmpty ? 0.0
                : daySessions.map { $0.successRate }.reduce(0, +) / Double(daySessions.count)
            let label = cal.isDateInToday(date) ? "Auj." :
                ["Lun","Mar","Mer","Jeu","Ven","Sam","Dim"][cal.component(.weekday, from: date) - 2 < 0 ? 6 : cal.component(.weekday, from: date) - 2]
            return (label, rate)
        }
    }

    // Compétences ABA : echoïques / tacts / intraverbaux
    var abaSkills: [(String, String, Double, String)] {
        let echoics   = recentSessions.filter { $0.moduleType == .diction }
        let tacts     = recentSessions.filter { $0.moduleType == .vocabulary }
        let intraver  = recentSessions.filter { $0.moduleType == .reading || $0.moduleType == .story }

        func rate(_ s: [LearningSession]) -> Double {
            guard !s.isEmpty else { return 0 }
            return s.map { $0.successRate }.reduce(0, +) / Double(s.count)
        }

        return [
            ("🗣️", "Échoïques (répétition)", rate(echoics), "accentOrange"),
            ("👁️", "Tacts (nommer)", rate(tacts), "accentPurple"),
            ("💬", "Intraverbaux (répondre)", rate(intraver), "accentBlue"),
        ]
    }

    var autoParentMessage: String {
        let rate = Int(weeklySuccessRate * 100)
        let streak = child.currentStreak
        let mastered = masteredWords.count

        if rate >= 80 {
            return "💪 \(child.firstName) performe excellemment cette semaine (\(rate)% de réussite). Continuez ainsi — la régularité est la clé ABA !"
        } else if rate >= 60 {
            return "📈 Bonne semaine pour \(child.firstName) (\(rate)% de réussite). Insistez sur les exercices de répétition vocale."
        } else if thisWeekSessions.isEmpty {
            return "⏰ Pas encore de session cette semaine. Même 10 minutes par jour font une grande différence pour \(child.firstName)."
        } else {
            return "🤝 \(child.firstName) progresse doucement (\(rate)%). Utilisez les indices (💡) pour réduire la frustration et renforcer chaque tentative."
        }
    }

    var body: some View {
        VStack(spacing: 16) {

            SectionHeader(title: "Cette semaine")

            // KPI grid
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 12) {
                StatCard(value: "\(masteredWords.count)",  label: "mots maîtrisés",    emoji: "⭐️")
                StatCard(value: "\(learningWords.count)",  label: "en apprentissage",  emoji: "📚")
                StatCard(value: "\(Int(weeklySuccessRate * 100))%", label: "taux de réussite", emoji: "✅")
                StatCard(value: "\(child.currentStreak)j", label: "série active",      emoji: "🔥")
            }
            .padding(.horizontal, 20)

            // Graphique 7 jours
            WeekBarChart(data: last7DaysData)
                .padding(.horizontal, 20)

            // Compétences ABA
            ABASkillsCard(skills: abaSkills)
                .padding(.horizontal, 20)

            // Maîtrise des mots
            MasteryBreakdownCard(child: child)
                .padding(.horizontal, 20)

            // Mots à réviser
            if !dueWords.isEmpty {
                ReviewWordsCard(words: dueWords)
                    .padding(.horizontal, 20)
            }

            // Rapport hebdomadaire
            WeeklyReportCard(child: child,
                             successRate: weeklySuccessRate,
                             sessionsCount: thisWeekSessions.count,
                             autoMessage: autoParentMessage)
                .padding(.horizontal, 20)

            // Progression par module
            ModuleProgressCard(sessions: recentSessions)
                .padding(.horizontal, 20)

            Spacer(minLength: 24)
        }
    }
}

// MARK: - En-tête de section
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(Color("textPrimary"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
    }
}

// MARK: - Graphique barres 7 jours
struct WeekBarChart: View {
    let data: [(String, Double)] // (label, rate 0-1)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📅 Réussite sur 7 jours")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            GeometryReader { geo in
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(data, id: \.0) { (label, rate) in
                        VStack(spacing: 4) {
                            // Valeur au-dessus si > 0
                            Text(rate > 0 ? "\(Int(rate * 100))%" : "")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(Color("accentPurple"))
                                .frame(height: 12)

                            // Barre
                            RoundedRectangle(cornerRadius: 4)
                                .fill(rate > 0
                                      ? Color("accentPurple").opacity(0.7 + rate * 0.3)
                                      : Color("borderLight"))
                                .frame(height: max(4, (geo.size.height - 36) * rate))

                            // Étiquette jour
                            Text(label)
                                .font(.system(size: 10))
                                .foregroundColor(Color("textSecondary"))
                                .frame(height: 14)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Compétences ABA
struct ABASkillsCard: View {
    let skills: [(String, String, Double, String)] // emoji, nom, rate, color

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("🧠 Compétences ABA")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            ForEach(skills, id: \.1) { (emoji, name, rate, color) in
                VStack(spacing: 6) {
                    HStack {
                        Text(emoji + " " + name)
                            .font(.system(size: 13))
                            .foregroundColor(Color("textSecondary"))
                        Spacer()
                        Text(rate > 0 ? "\(Int(rate * 100))%" : "Pas encore")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(rate > 0 ? Color(color) : Color("textSecondary"))
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color("borderLight"))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(color))
                                .frame(width: geo.size.width * rate, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Répartition des niveaux de maîtrise
struct MasteryBreakdownCard: View {
    let child: ChildProfile

    var counts: [(MasteryLevel, Int)] {
        MasteryLevel.allCases.map { level in
            (level, child.wordProgresses.filter { $0.masteryLevel == level }.count)
        }
    }
    var total: Int { child.wordProgresses.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📊 Maîtrise des mots")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Spacer()
                Text("\(total) mots")
                    .font(.system(size: 12))
                    .foregroundColor(Color("textSecondary"))
            }

            if total == 0 {
                Text("Aucun mot étudié encore — lancez la première session !")
                    .font(.system(size: 13))
                    .foregroundColor(Color("textSecondary"))
            } else {
                // Barre segmentée
                GeometryReader { geo in
                    HStack(spacing: 2) {
                        ForEach(counts, id: \.0) { (level, count) in
                            if count > 0 {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(level.color))
                                    .frame(width: geo.size.width * CGFloat(count) / CGFloat(total))
                            }
                        }
                    }
                }
                .frame(height: 10)
                .clipShape(RoundedRectangle(cornerRadius: 5))

                // Légende
                HStack(spacing: 12) {
                    ForEach(counts, id: \.0) { (level, count) in
                        HStack(spacing: 4) {
                            Circle().fill(Color(level.color)).frame(width: 8, height: 8)
                            Text("\(level.emoji) \(count)")
                                .font(.system(size: 11))
                                .foregroundColor(Color("textSecondary"))
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

struct ReviewWordsCard: View {
    let words: [WordProgress]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🔄 Mots à réviser aujourd'hui")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("accentOrange"))
                Spacer()
                Text("\(words.count)")
                    .font(.system(size: 13))
                    .foregroundColor(Color("textSecondary"))
            }
            FlowLayout(items: words.prefix(8).map { $0.word }) { word in
                Text(word)
                    .font(.system(size: 13))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("accentOrange").opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(Color("accentOrange"))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

struct WeeklyReportCard: View {
    let child: ChildProfile
    let successRate: Double
    let sessionsCount: Int
    let autoMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("📋 Bilan de la semaine")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Spacer()
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15))
                    .foregroundColor(Color("accentPurple").opacity(0.4))
            }

            HStack(spacing: 0) {
                ReportStat(value: "\(sessionsCount)", label: "sessions",  color: "accentPurple")
                Divider().frame(height: 40)
                ReportStat(value: "\(Int(successRate * 100))%", label: "réussite", color: "accentGreen")
                Divider().frame(height: 40)
                ReportStat(value: "\(child.totalStars)", label: "⭐️ total", color: "accentOrange")
            }

            // Message auto dynamique basé sur les vraies données
            Text(autoMessage)
                .font(.system(size: 13))
                .foregroundColor(Color("textSecondary"))
                .lineSpacing(3)
                .padding(12)
                .background(Color("backgroundSoft"))
                .cornerRadius(10)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

struct ReportStat: View {
    let value: String
    let label: String
    let color: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(color))
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color("textSecondary"))
        }
        .frame(maxWidth: .infinity)
    }
}

struct ModuleProgressCard: View {
    let sessions: [LearningSession]

    var moduleStats: [(String, Int, String)] {
        let types: [(ModuleType, String, String)] = [
            (.vocabulary, "Vocabulaire", "📖"),
            (.numbers,    "Chiffres",    "🔢"),
            (.diction,    "Diction",     "🎤"),
            (.story,      "Histoire",    "📚"),
        ]
        return types.map { (type, name, emoji) in
            let count = sessions.filter { $0.moduleType == type }.count
            return (emoji + " " + name, count, "accentPurple")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Modules cette semaine")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("textPrimary"))

            ForEach(moduleStats, id: \.0) { (name, count, color) in
                HStack {
                    Text(name)
                        .font(.system(size: 14))
                        .foregroundColor(Color("textSecondary"))
                    Spacer()
                    Text("\(count) sessions")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(color))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Onglet Guide Parents
struct GuideTabView: View {
    let sections: [(String, String, [String])] = [
        ("🧠", "Comprendre le TSA", [
            "Qu'est-ce que le trouble du spectre autistique ?",
            "Les différents profils sensoriels",
            "Communication et TSA",
            "Gestion des comportements défis"
        ]),
        ("🏠", "À la maison", [
            "Structurer la journée avec des routines visuelles",
            "Sommeil : pourquoi 11h sont essentielles",
            "Alimentation et cerveau (oméga-3, Mg, vitamine D)",
            "Gérer les crises et meltdowns"
        ]),
        ("🧬", "Examens recommandés", [
            "Bilan neuropsychologique complet",
            "qEEG (cartographie cérébrale)",
            "IRM DTI (connectivité cérébrale)",
            "Bilan sensoriel avec ergothérapeute"
        ]),
        ("💪", "Thérapies et aides", [
            "ABA : principes et application à la maison",
            "Orthophonie : trouver le bon professionnel",
            "Ergothérapie sensorielle",
            "Équithérapie, natation, sports adaptés"
        ]),
        ("⚖️", "Droits et administratif", [
            "MDPH : constitution du dossier",
            "AEEH : comment la demander",
            "AESH / AVS : vos droits",
            "PPS à l'école : mode d'emploi"
        ])
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(sections, id: \.0) { (emoji, title, items) in
                GuideSection(emoji: emoji, title: title, items: items)
            }
            Spacer(minLength: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

struct GuideSection: View {
    let emoji: String
    let title: String
    let items: [String]
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Text(emoji).font(.system(size: 22))
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13))
                        .foregroundColor(Color("textSecondary"))
                }
                .padding(16)
            }

            if isExpanded {
                Divider().opacity(0.3)
                VStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color("accentPurple").opacity(0.3))
                                .frame(width: 6, height: 6)
                            Text(item)
                                .font(.system(size: 14))
                                .foregroundColor(Color("textSecondary"))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundColor(Color("borderLight"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        Divider().opacity(0.2).padding(.leading, 32)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("cardBackground"))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borderLight"), lineWidth: 0.5))
        )
    }
}

// MARK: - Onglet Support
struct SupportTabView: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(supportItems, id: \.title) { item in
                SupportCard(item: item)
            }
            Spacer(minLength: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    let supportItems: [SupportItem] = [
        SupportItem(emoji: "🧠", title: "Neurologique",
                    description: "Neuropédiatre, qEEG, neuromodulation (tACS, neurofeedback)",
                    color: "accentPurple"),
        SupportItem(emoji: "🤝", title: "Psychologique",
                    description: "TCC adaptée TSA, thérapie familiale, gestion émotions parent",
                    color: "accentBlue"),
        SupportItem(emoji: "🏃", title: "Sport & corps",
                    description: "Équithérapie, natation adaptée, trampoline thérapeutique",
                    color: "accentGreen"),
        SupportItem(emoji: "🍽️", title: "Nutrition cérébrale",
                    description: "Oméga-3 DHA, magnésium glycinate, vitamine D3+K2, probiotiques",
                    color: "accentOrange"),
        SupportItem(emoji: "👥", title: "Social & associations",
                    description: "Autism France, Sésame Autisme, groupes de parents locaux",
                    color: "accentPink"),
    ]
}

struct SupportItem {
    let emoji: String
    let title: String
    let description: String
    let color: String
}

struct SupportCard: View {
    let item: SupportItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(item.emoji)
                .font(.system(size: 28))
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("textPrimary"))
                Text(item.description)
                    .font(.system(size: 13))
                    .foregroundColor(Color("textSecondary"))
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(item.color).opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(item.color).opacity(0.2), lineWidth: 0.5))
        )
    }
}

// MARK: - Badge trial
struct TrialBadge: View {
    let daysLeft: Int

    var body: some View {
        Text("\(daysLeft)j gratuits")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color("accentOrange"))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color("accentOrange").opacity(0.12))
            .cornerRadius(20)
    }
}

// MARK: - Paywall
struct PaywallView: View {
    @EnvironmentObject var subscriptionService: SubscriptionService
    @EnvironmentObject var appState: AppState
    @State private var isPurchasing = false
    @State private var showRestoreConfirm = false

    var isTrialActive: Bool { !subscriptionService.trialExpired }
    var daysLeft: Int { subscriptionService.trialDaysRemaining }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // Bandeau trial / expiré
                if isTrialActive {
                    HStack(spacing: 8) {
                        Text("⏳")
                        Text("Essai gratuit — encore \(daysLeft) jour\(daysLeft > 1 ? "s" : "")")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                        Button("Continuer gratuitement") {
                            // retour si le trial est encore actif
                            if let child = appState.selectedChild {
                                _ = child
                            }
                            appState.currentScreen = .home
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .underline()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color("accentOrange"))
                } else {
                    HStack(spacing: 8) {
                        Text("🔒")
                        Text("Votre essai de 21 jours est terminé")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.85))
                }

                // Hero
                VStack(spacing: 14) {
                    Text("🏠")
                        .font(.system(size: 52))
                        .padding(.top, 36)

                    Text("ABA Homeschooling")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(Color("textPrimary"))

                    Text(isTrialActive
                         ? "Débloquez l'accès complet à vie\navant la fin de votre essai."
                         : "Votre enfant attend.\nContinuez le programme scolaire à la maison.")
                        .font(.system(size: 16))
                        .foregroundColor(Color("textSecondary"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 32)

                // Ancrage prix
                VStack(spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("199 €")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundColor(Color("textPrimary"))
                        Text("une fois")
                            .font(.system(size: 16))
                            .foregroundColor(Color("textSecondary"))
                    }
                    Text("Accès à vie — aucun abonnement — pour toute la famille")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color("accentGreen"))
                        .multilineTextAlignment(.center)

                    // Comparaison prix
                    HStack(spacing: 8) {
                        ComparisonPill(label: "vs 90 €/séance ortho", striked: true)
                        ComparisonPill(label: "vs 800 €/an AVS", striked: true)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                // Bouton principal
                Button {
                    isPurchasing = true
                    Task {
                        await subscriptionService.purchaseLifetime()
                        isPurchasing = false
                        if subscriptionService.isSubscribed {
                            appState.currentScreen = .home
                        }
                    }
                } label: {
                    HStack(spacing: 10) {
                        if isPurchasing {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 16))
                            Text("Débloquer — 199 €")
                                .font(.system(size: 18, weight: .medium))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(
                        LinearGradient(colors: [Color("accentPurple"), Color("accentPurple").opacity(0.82)],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(18)
                    .shadow(color: Color("accentPurple").opacity(0.35), radius: 12, y: 4)
                }
                .disabled(isPurchasing)
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Button {
                    Task {
                        await subscriptionService.restorePurchases()
                        showRestoreConfirm = true
                    }
                } label: {
                    Text("Restaurer un achat précédent")
                        .font(.system(size: 14))
                        .foregroundColor(Color("textSecondary"))
                        .underline()
                }
                .padding(.top, 12)
                .alert("Achat restauré", isPresented: $showRestoreConfirm) {
                    Button("OK") {
                        if subscriptionService.isSubscribed { appState.currentScreen = .home }
                    }
                } message: {
                    Text(subscriptionService.isSubscribed
                         ? "Votre accès a bien été restauré."
                         : "Aucun achat trouvé sur ce compte.")
                }

                // Ce qui est inclus
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ce qui est inclus")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .padding(.bottom, 12)

                    VStack(spacing: 10) {
                        PaywallFeature(emoji: "🏫", text: "Programme maternelle → CM2 complet")
                        PaywallFeature(emoji: "🗣️", text: "Exercices de parole ABA avec Léo")
                        PaywallFeature(emoji: "🌍", text: "8 langues disponibles")
                        PaywallFeature(emoji: "📊", text: "Tableau de bord parents + rapports")
                        PaywallFeature(emoji: "👨‍👩‍👧‍👦", text: "Plusieurs enfants, un seul achat")
                        PaywallFeature(emoji: "🔄", text: "Mises à jour incluses à vie")
                        PaywallFeature(emoji: "📵", text: "Fonctionne hors ligne")
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color("cardBackground"))
                        .overlay(RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("borderLight"), lineWidth: 0.5))
                )
                .padding(.horizontal, 20)
                .padding(.top, 28)

                // Témoignage
                VStack(alignment: .leading, spacing: 8) {
                    Text("❝")
                        .font(.system(size: 28))
                        .foregroundColor(Color("accentPurple").opacity(0.4))
                    Text("On a essayé des centaines d'euros d'applications. ABA Homeschooling est la seule qui suit vraiment le programme. Nathan progresse en lecture chaque semaine.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .lineSpacing(4)
                    Text("— Sophie, maman de Nathan (8 ans, TSA niveau 2)")
                        .font(.system(size: 12))
                        .foregroundColor(Color("textSecondary"))
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color("accentPurple").opacity(0.06))
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 48)
            }
        }
        .background(Color("backgroundSoft").ignoresSafeArea())
    }
}

struct ComparisonPill: View {
    let label: String
    let striked: Bool
    var body: some View {
        Text(label)
            .font(.system(size: 11, weight: .medium))
            .strikethrough(striked)
            .foregroundColor(Color("textSecondary"))
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(Color("cardBackground"))
            .cornerRadius(20)
    }
}

struct PaywallFeature: View {
    let emoji: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji).font(.system(size: 20))
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(Color("textPrimary"))
            Spacer()
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color("accentGreen"))
        }
    }
}

// MARK: - LearningHubView (stub)
struct LearningHubView: View {
    let child: ChildProfile

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Programme \(child.schoolLevel.displayName)")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Color("textPrimary"))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    // TODO: Séquence de leçons structurées par thème
                    Text("Les modules de la semaine arrivent ici —\nnavigation par thème et par compétence.")
                        .font(.system(size: 15))
                        .foregroundColor(Color("textSecondary"))
                        .padding(.horizontal, 20)
                        .lineSpacing(4)
                }
            }
            .background(Color("backgroundSoft"))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - RewardsView (stub)
struct RewardsView: View {
    let child: ChildProfile

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Mes récompenses")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(Color("textPrimary"))
                            Text("⭐️ \(child.totalStars) étoiles accumulées")
                                .font(.system(size: 14))
                                .foregroundColor(Color("accentOrange"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // TODO: Badges débloqués, jeux de pause, avatar évolution
                    Text("Badges, jeux de pause et\névolution de l'avatar arrivent ici.")
                        .font(.system(size: 15))
                        .foregroundColor(Color("textSecondary"))
                        .padding(.horizontal, 20)
                        .lineSpacing(4)
                }
            }
            .background(Color("backgroundSoft"))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - FlowLayout simple
struct FlowLayout<Content: View>: View {
    let items: [String]
    let content: (String) -> Content

    var body: some View {
        // Implémentation simple en VStack/HStack wrapping
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                ForEach(items, id: \.self) { item in
                    content(item)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
