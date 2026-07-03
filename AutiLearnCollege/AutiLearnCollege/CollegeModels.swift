import SwiftUI
import SwiftData

// MARK: - Niveaux scolaires collège/lycée
enum CollegeLevel: String, CaseIterable, Codable {
    case sixieme  = "6ème"
    case cinquieme = "5ème"
    case quatrieme = "4ème"
    case troisieme = "3ème"
    case seconde  = "Seconde"
    case premiere = "Première"
    case terminale = "Terminale"

    var ageRange: String {
        switch self {
        case .sixieme:   return "11-12 ans"
        case .cinquieme: return "12-13 ans"
        case .quatrieme: return "13-14 ans"
        case .troisieme: return "14-15 ans"
        case .seconde:   return "15-16 ans"
        case .premiere:  return "16-17 ans"
        case .terminale: return "17-18 ans"
        }
    }

    var emoji: String {
        switch self {
        case .sixieme:   return "🏫"
        case .cinquieme: return "📚"
        case .quatrieme: return "🔬"
        case .troisieme: return "🧪"
        case .seconde:   return "🎓"
        case .premiere:  return "📐"
        case .terminale: return "🏆"
        }
    }

    var isLycee: Bool {
        self == .seconde || self == .premiere || self == .terminale
    }
}

// MARK: - Matières
enum CollegeSubject: String, CaseIterable, Codable {
    case francais     = "Français"
    case maths        = "Mathématiques"
    case anglais      = "Anglais"
    case histoire     = "Histoire-Géo"
    case sciences     = "Sciences"
    case communication = "Communication sociale"

    var emoji: String {
        switch self {
        case .francais:      return "📝"
        case .maths:         return "🔢"
        case .anglais:       return "🌍"
        case .histoire:      return "🏛️"
        case .sciences:      return "🔬"
        case .communication: return "🗣️"
        }
    }

    var color: String {
        switch self {
        case .francais:      return "accentPurple"
        case .maths:         return "accentBlue"
        case .anglais:       return "accentGreen"
        case .histoire:      return "accentOrange"
        case .sciences:      return "accentPink"
        case .communication: return "accentYellow"
        }
    }
}

// MARK: - Mode d'exercice
enum CollegeExerciseMode: String, Codable {
    case multipleChoice   // QCM
    case shortAnswer      // Réponse courte
    case trueFalse        // Vrai/Faux
    case fillBlank        // Compléter la phrase
    case oral             // Répéter/Expliquer à voix haute
}

// MARK: - Exercice collège
struct CollegeExercise: Identifiable {
    let id = UUID()
    let subject: CollegeSubject
    let mode: CollegeExerciseMode
    let question: String
    let choices: [String]          // Vide si shortAnswer/oral
    let correctAnswer: String
    let explanation: String        // Explication pédagogique après réponse
    let emoji: String
    let difficulty: Int            // 1-3 : facile, moyen, difficile
}

// MARK: - Profil élève collège
@Model
class CollegeProfile {
    var firstName: String
    var avatarName: String
    var level: CollegeLevel
    var totalStars: Int
    var currentStreak: Int
    var lastSessionDate: Date?
    var sessions: [CollegeSession]

    init(firstName: String, avatarName: String, level: CollegeLevel) {
        self.firstName = firstName
        self.avatarName = avatarName
        self.level = level
        self.totalStars = 0
        self.currentStreak = 0
        self.sessions = []
    }
}

@Model
class CollegeSession {
    var date: Date
    var subject: String
    var starsEarned: Int
    var correctAnswers: Int
    var totalAnswers: Int
    var durationSeconds: Int

    init(subject: CollegeSubject, stars: Int, correct: Int, total: Int, duration: Int) {
        self.date = Date()
        self.subject = subject.rawValue
        self.starsEarned = stars
        self.correctAnswers = correct
        self.totalAnswers = total
        self.durationSeconds = duration
    }

    var successRate: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }
}

// MARK: - Hiérarchie de prompts ABA (adaptée ado)
enum CollegePromptLevel: Int, CaseIterable {
    case independent = 0
    case hint        = 1
    case partial     = 2
    case full        = 3

    var buttonLabel: String {
        switch self {
        case .independent: return "J'ai besoin d'un indice 💡"
        case .hint:        return "Encore un indice"
        case .partial:     return "Voir la réponse partielle"
        case .full:        return ""
        }
    }
}

// MARK: - Couleurs (identiques à l'app primaire pour cohérence)
extension Color {
    static let accentPurple = Color("accentPurple")
    static let accentBlue   = Color("accentBlue")
    static let accentGreen  = Color("accentGreen")
    static let accentOrange = Color("accentOrange")
    static let accentPink   = Color("accentPink")
    static let accentYellow = Color("accentYellow")
}
