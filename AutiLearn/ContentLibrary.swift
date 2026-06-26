import Foundation

struct ContentLibrary {

    // MARK: - Génération de questions
    static func questions(for module: ModuleType,
                          level: SchoolLevel,
                          count: Int = 8) -> [Question] {
        let pool = wordPool(for: module, level: level)
        let selected = Array(pool.shuffled().prefix(count))

        return selected.map { entry in
            let (word, emoji, distractors) = entry
            var choices = [word] + distractors.shuffled().prefix(2)
            choices = choices.shuffled()

            return Question(
                word: word,
                imageEmoji: emoji,
                instruction: instruction(for: module),
                choices: choices,
                correctAnswer: word
            )
        }
    }

    private static func instruction(for module: ModuleType) -> String {
        switch module {
        case .vocabulary: return "Quel mot correspond à cette image ?"
        case .numbers:    return "Quel chiffre vois-tu ?"
        case .reading:    return "Lis ce mot à voix haute, puis choisis-le."
        case .diction:    return "Répète ce mot, puis choisis la bonne réponse."
        default:          return "Quelle est la bonne réponse ?"
        }
    }

    // MARK: - Pool de mots par niveau (FR)
    // Format : (mot, emoji, [distracteurs])
    private static func wordPool(for module: ModuleType,
                                  level: SchoolLevel) -> [(String, String, [String])] {
        switch level {
        case .level0: return maternelleWords(module)
        case .level1: return cp_ce1Words(module)
        case .level2: return ce2_cm2Words(module)
        case .level3: return collegeWords(module)
        }
    }

    // MARK: - Maternelle
    private static func maternelleWords(_ module: ModuleType) -> [(String, String, [String])] {
        let vocab: [(String, String, [String])] = [
            ("chat",    "🐱", ["chien", "lapin", "oiseau"]),
            ("chien",   "🐶", ["chat", "lapin", "vache"]),
            ("pomme",   "🍎", ["poire", "banane", "orange"]),
            ("soleil",  "☀️", ["lune", "étoile", "nuage"]),
            ("maison",  "🏠", ["école", "voiture", "arbre"]),
            ("eau",     "💧", ["lait", "jus", "soupe"]),
            ("arbre",   "🌳", ["fleur", "herbe", "buisson"]),
            ("voiture", "🚗", ["vélo", "bus", "train"]),
            ("pain",    "🍞", ["gâteau", "biscuit", "tarte"]),
            ("lit",     "🛏️", ["table", "chaise", "canapé"]),
            ("rouge",   "🔴", ["bleu", "vert", "jaune"]),
            ("grand",   "🏔️", ["petit", "long", "rond"]),
        ]
        let numbers: [(String, String, [String])] = [
            ("un",    "1️⃣", ["deux", "trois", "quatre"]),
            ("deux",  "2️⃣", ["un", "trois", "cinq"]),
            ("trois", "3️⃣", ["deux", "quatre", "un"]),
            ("quatre","4️⃣", ["trois", "cinq", "deux"]),
            ("cinq",  "5️⃣", ["quatre", "six", "trois"]),
        ]
        return module == .numbers ? numbers : vocab
    }

    // MARK: - CP-CE1
    private static func cp_ce1Words(_ module: ModuleType) -> [(String, String, [String])] {
        let vocab: [(String, String, [String])] = [
            ("école",     "🏫", ["maison", "hôpital", "magasin"]),
            ("livre",     "📚", ["cahier", "stylo", "crayon"]),
            ("famille",   "👨‍👩‍👧", ["ami", "voisin", "inconnu"]),
            ("manger",    "🍽️", ["dormir", "jouer", "courir"]),
            ("dormir",    "😴", ["manger", "lire", "chanter"]),
            ("courir",    "🏃", ["marcher", "nager", "sauter"]),
            ("sourire",   "😊", ["pleurer", "crier", "dormir"]),
            ("partager",  "🤝", ["garder", "cacher", "perdre"]),
            ("printemps", "🌸", ["été", "automne", "hiver"]),
            ("lundi",     "📅", ["mardi", "mercredi", "jeudi"]),
        ]
        return vocab
    }

    // MARK: - CE2-CM2
    private static func ce2_cm2Words(_ module: ModuleType) -> [(String, String, [String])] {
        [
            ("continent",  "🌍", ["pays", "ville", "île"]),
            ("vocabulaire","📖", ["grammaire", "conjugaison", "orthographe"]),
            ("problème",   "🧩", ["solution", "question", "réponse"]),
            ("géographie", "🗺️", ["histoire", "sciences", "musique"]),
            ("fraction",   "½",  ["entier", "décimal", "pourcentage"]),
            ("synonyme",   "🔄", ["antonyme", "homonyme", "pronom"]),
            ("respiration","🫁", ["digestion", "circulation", "nutrition"]),
            ("planète",    "🪐", ["étoile", "satellite", "galaxie"]),
        ]
    }

    // MARK: - Collège
    private static func collegeWords(_ module: ModuleType) -> [(String, String, [String])] {
        [
            ("autonomie",     "🧭", ["dépendance", "liberté", "contrainte"]),
            ("communication", "💬", ["silence", "isolement", "incompréhension"]),
            ("responsabilité","⚖️", ["négligence", "indifférence", "abandon"]),
            ("citoyenneté",   "🗳️", ["exclusion", "marginalité", "anonymat"]),
            ("biodiversité",  "🌿", ["uniformité", "désert", "extinction"]),
            ("démocratie",    "🏛️", ["monarchie", "dictature", "anarchie"]),
        ]
    }
}
