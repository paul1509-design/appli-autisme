import Foundation

// MARK: - Exercice pédagogique (nouveau format)
struct CurriculumExercise {
    let characterSays: String
    let prompt: String
    let expectedAnswer: String
    let emoji: String
    let type: ExerciseMode
    let subject: CurriculumSubject
    let useGirl: Bool

    enum ExerciseMode: String {
        case repeatAfterMe = "repeat"
        case answerQuestion = "answer"
        case writeResponse  = "write"
    }

    enum CurriculumSubject: String {
        case oral, reading, writing, math, science, social, arts
        var displayName: String {
            switch self {
            case .oral:    return "Parole"
            case .reading: return "Lecture"
            case .writing: return "Écriture"
            case .math:    return "Maths"
            case .science: return "Sciences"
            case .social:  return "Vie sociale"
            case .arts:    return "Arts"
            }
        }
    }
}

struct ContentLibrary {

    static func exercises(for module: ModuleType,
                          level: SchoolLevel,
                          count: Int = 8) -> [CurriculumExercise] {
        let pool: [CurriculumExercise]
        switch level {
        case .level0: pool = maternelle(module)
        case .level1: pool = cpCe1(module)
        case .level2: pool = ce2Cm2(module)
        case .level3: pool = college(module)
        }
        return Array(pool.shuffled().prefix(count))
    }

    // MARK: - MATERNELLE (3–5 ans)
    private static func maternelle(_ module: ModuleType) -> [CurriculumExercise] {
        [
            e("Dis bonjour !", "Répète ce mot", "Bonjour", "👋", .repeatAfterMe, .oral, true),
            e("Au revoir !", "Répète ce mot", "Au revoir", "👋", .repeatAfterMe, .oral, false),
            e("Merci !", "Répète ce mot", "Merci", "🙏", .repeatAfterMe, .oral, true),
            e("S'il vous plaît.", "Répète", "S'il vous plaît", "🙏", .repeatAfterMe, .oral, false),
            e("Oui.", "Répète ce mot", "Oui", "✅", .repeatAfterMe, .oral, true),
            e("Non.", "Répète ce mot", "Non", "❌", .repeatAfterMe, .oral, false),
            e("Comment tu t'appelles ?", "Réponds à la question", "Je m'appelle...", "🧒", .answerQuestion, .social, true),
            e("J'ai faim.", "Répète cette phrase", "J'ai faim", "🍽️", .repeatAfterMe, .oral, false),
            e("J'ai soif.", "Répète cette phrase", "J'ai soif", "💧", .repeatAfterMe, .oral, true),
            e("J'ai mal.", "Répète cette phrase", "J'ai mal", "🤕", .repeatAfterMe, .oral, false),
            e("Je veux jouer.", "Répète cette phrase", "Je veux jouer", "🎮", .repeatAfterMe, .oral, true),
            e("Je veux manger.", "Répète cette phrase", "Je veux manger", "🍎", .repeatAfterMe, .oral, false),
            e("Aide-moi s'il te plaît.", "Répète", "Aide-moi s'il te plaît", "🤝", .repeatAfterMe, .social, true),
            e("C'est à moi.", "Répète", "C'est à moi", "👆", .repeatAfterMe, .social, false),
            e("Je suis content.", "Répète", "Je suis content", "😊", .repeatAfterMe, .social, true),
            e("Je suis triste.", "Répète", "Je suis triste", "😢", .repeatAfterMe, .social, false),
            e("C'est rouge !", "Répète la couleur", "Rouge", "🔴", .repeatAfterMe, .oral, true),
            e("C'est bleu !", "Répète la couleur", "Bleu", "🔵", .repeatAfterMe, .oral, false),
            e("C'est jaune !", "Répète la couleur", "Jaune", "🟡", .repeatAfterMe, .oral, true),
            e("C'est vert !", "Répète la couleur", "Vert", "🟢", .repeatAfterMe, .oral, false),
            e("Un, deux, trois !", "Répète les chiffres", "Un, deux, trois", "🔢", .repeatAfterMe, .math, true),
            e("Quatre, cinq !", "Répète les chiffres", "Quatre, cinq", "🔢", .repeatAfterMe, .math, false),
            e("Le chat dit miaou.", "Répète", "Le chat dit miaou", "🐱", .repeatAfterMe, .oral, true),
            e("Le chien dit ouaf.", "Répète", "Le chien dit ouaf", "🐶", .repeatAfterMe, .oral, false),
            e("Où est ton nez ?", "Montre et dis le mot", "Nez", "👃", .answerQuestion, .social, true),
            e("Montre-moi ta main.", "Montre et répète", "Main", "✋", .answerQuestion, .social, false),
            e("Maman.", "Répète ce mot", "Maman", "👩", .repeatAfterMe, .oral, true),
            e("Papa.", "Répète ce mot", "Papa", "👨", .repeatAfterMe, .oral, false),
            e("Encore !", "Répète ce mot", "Encore", "🔁", .repeatAfterMe, .oral, true),
            e("Fini !", "Répète ce mot", "Fini", "🏁", .repeatAfterMe, .oral, false),
        ]
    }

    // MARK: - CP – CE1 (6–7 ans)
    private static func cpCe1(_ module: ModuleType) -> [CurriculumExercise] {
        [
            // Parole
            e("Répète : Le chat mange une souris.", "Répète la phrase", "Le chat mange une souris", "🐱", .repeatAfterMe, .oral, true),
            e("Répète : La fille joue dans le jardin.", "Répète la phrase", "La fille joue dans le jardin", "🌸", .repeatAfterMe, .oral, false),
            e("Répète : Le soleil brille aujourd'hui.", "Répète la phrase", "Le soleil brille aujourd'hui", "☀️", .repeatAfterMe, .oral, true),
            e("Qu'est-ce que tu vois ?", "Regarde 🐶 et réponds", "Je vois un chien", "🐶", .answerQuestion, .oral, false),
            e("C'est de quelle couleur ?", "Regarde 🍎 et réponds", "C'est rouge", "🍎", .answerQuestion, .oral, true),
            e("Répète : Je lis un livre.", "Répète", "Je lis un livre", "📖", .repeatAfterMe, .reading, false),
            e("Répète : J'écris mon prénom.", "Répète", "J'écris mon prénom", "✏️", .repeatAfterMe, .writing, true),
            e("Répète : Je range mes affaires.", "Répète", "Je range mes affaires", "🎒", .repeatAfterMe, .social, false),
            // Sons et lecture
            e("Le son A — comme dans ARBRE.", "Répète le son et le mot", "A — Arbre", "🌳", .repeatAfterMe, .reading, true),
            e("Le son O — comme dans OISEAU.", "Répète le son et le mot", "O — Oiseau", "🐦", .repeatAfterMe, .reading, false),
            e("Le son I — comme dans ILE.", "Répète le son et le mot", "I — Île", "🏝️", .repeatAfterMe, .reading, true),
            e("Lis : MA-MAN.", "Lis les syllabes", "Maman", "👩", .repeatAfterMe, .reading, false),
            e("Lis : cha-peau.", "Lis les syllabes", "Chapeau", "🎩", .repeatAfterMe, .reading, true),
            e("Lis : ma-i-son.", "Lis les syllabes", "Maison", "🏠", .repeatAfterMe, .reading, false),
            e("Lis : pa-pi-llon.", "Lis les syllabes", "Papillon", "🦋", .repeatAfterMe, .reading, true),
            e("Lis : é-lé-phant.", "Lis les syllabes", "Éléphant", "🐘", .repeatAfterMe, .reading, false),
            // Maths
            e("Combien font 2 plus 3 ?", "Réponds à voix haute", "5", "🔢", .answerQuestion, .math, true),
            e("Combien font 4 plus 1 ?", "Réponds à voix haute", "5", "🔢", .answerQuestion, .math, false),
            e("Combien font 3 plus 3 ?", "Réponds à voix haute", "6", "🔢", .answerQuestion, .math, true),
            e("Compte jusqu'à 10.", "Compte à voix haute", "1, 2, 3, 4, 5, 6, 7, 8, 9, 10", "🔢", .repeatAfterMe, .math, false),
            e("Combien font 5 moins 2 ?", "Réponds", "3", "🔢", .answerQuestion, .math, true),
            e("7 est-il plus grand que 3 ?", "Réponds", "Oui, 7 est plus grand que 3", "🔢", .answerQuestion, .math, false),
            // Vie sociale
            e("Qu'est-ce qu'on dit quand on arrive ?", "Réponds", "Bonjour", "🏫", .answerQuestion, .social, true),
            e("Qu'est-ce qu'on dit quand on part ?", "Réponds", "Au revoir", "👋", .answerQuestion, .social, false),
            e("Répète : Je lève la main pour parler.", "Répète la règle", "Je lève la main pour parler", "✋", .repeatAfterMe, .social, true),
            e("Répète : Je partage avec mes amis.", "Répète", "Je partage avec mes amis", "🤝", .repeatAfterMe, .social, false),
        ]
    }

    // MARK: - CE2 – CM2 (8–10 ans)
    private static func ce2Cm2(_ module: ModuleType) -> [CurriculumExercise] {
        [
            // Grammaire & expression
            e("Répète : Le chien court après le ballon rouge.", "Répète la phrase", "Le chien court après le ballon rouge", "🐕", .repeatAfterMe, .oral, true),
            e("Quel est le sujet de : Les oiseaux chantent ?", "Réponds", "Les oiseaux", "🐦", .answerQuestion, .reading, false),
            e("Conjugue ALLER au présent : je...", "Complète", "Je vais", "📝", .answerQuestion, .writing, true),
            e("Conjugue ÊTRE au présent : il...", "Complète", "Il est", "📝", .answerQuestion, .writing, false),
            e("Conjugue AVOIR au présent : nous...", "Complète", "Nous avons", "📝", .answerQuestion, .writing, true),
            e("Quel est le pluriel de CHEVAL ?", "Réponds", "Chevaux", "🐴", .answerQuestion, .writing, false),
            e("Quel est le féminin de BOULANGER ?", "Réponds", "Boulangère", "🍞", .answerQuestion, .writing, true),
            e("Répète : Nous mangeons des fruits frais chaque matin.", "Répète", "Nous mangeons des fruits frais chaque matin", "🍎", .repeatAfterMe, .oral, false),
            e("Donne un synonyme de CONTENT.", "Réponds", "Heureux", "😊", .answerQuestion, .writing, true),
            e("Donne un antonyme de GRAND.", "Réponds", "Petit", "📏", .answerQuestion, .writing, false),
            e("Quel est le COD dans : Je mange une pomme ?", "Réponds", "Une pomme", "🍎", .answerQuestion, .reading, true),
            e("Répète : Les fleurs poussent au printemps.", "Répète", "Les fleurs poussent au printemps", "🌸", .repeatAfterMe, .oral, false),
            // Maths
            e("Combien font 7 fois 8 ?", "Réponds", "56", "🔢", .answerQuestion, .math, true),
            e("Combien font 6 fois 9 ?", "Réponds", "54", "🔢", .answerQuestion, .math, false),
            e("Combien font 45 divisé par 9 ?", "Réponds", "5", "🔢", .answerQuestion, .math, true),
            e("Quelle est la moitié de 80 ?", "Réponds", "40", "🔢", .answerQuestion, .math, false),
            e("Combien font 234 plus 156 ?", "Calcule et réponds", "390", "🔢", .answerQuestion, .math, true),
            e("Quel est le périmètre d'un carré de côté 5 ?", "Réponds", "20", "📐", .answerQuestion, .math, false),
            e("Convertis 2 km en mètres.", "Réponds", "2000 mètres", "📏", .answerQuestion, .math, true),
            e("Combien font 3 quarts de 100 ?", "Réponds", "75", "🔢", .answerQuestion, .math, false),
            // Sciences & géo
            e("Quelle est la capitale de la France ?", "Réponds", "Paris", "🗼", .answerQuestion, .science, true),
            e("Cite trois planètes.", "Réponds", "Mercure, Vénus, Mars", "🪐", .answerQuestion, .science, false),
            e("De quoi les plantes ont-elles besoin ?", "Réponds", "Eau, lumière et terre", "🌱", .answerQuestion, .science, true),
            e("Répète : La photosynthèse permet aux plantes de se nourrir.", "Répète", "La photosynthèse permet aux plantes de se nourrir", "🌿", .repeatAfterMe, .science, false),
            e("Quels sont les trois états de l'eau ?", "Réponds", "Liquide, solide, gazeux", "💧", .answerQuestion, .science, true),
        ]
    }

    // MARK: - COLLÈGE (11–14 ans)
    private static func college(_ module: ModuleType) -> [CurriculumExercise] {
        [
            e("Répète : La liberté d'expression est un droit fondamental.", "Répète", "La liberté d'expression est un droit fondamental", "📜", .repeatAfterMe, .oral, true),
            e("Qu'est-ce qu'une métaphore ?", "Explique et donne un exemple", "Une image sans 'comme'. Ex : Il est un lion", "📖", .answerQuestion, .reading, false),
            e("Conjugue VOULOIR au conditionnel : je...", "Réponds", "Je voudrais", "📝", .answerQuestion, .writing, true),
            e("Conjugue POUVOIR au futur : nous...", "Réponds", "Nous pourrons", "📝", .answerQuestion, .writing, false),
            e("Identifie le temps de : Il aurait chanté.", "Réponds", "Conditionnel passé", "📖", .answerQuestion, .reading, true),
            e("Donne un exemple de phrase au subjonctif.", "Réponds", "Il faut que tu viennes", "📝", .answerQuestion, .writing, false),
            e("Répète : Malgré la pluie, nous sommes allés nous promener.", "Répète", "Malgré la pluie, nous sommes allés nous promener", "🌧️", .repeatAfterMe, .oral, true),
            // Maths
            e("Calcule : 3 au carré plus 4 au carré.", "Réponds", "25", "🔢", .answerQuestion, .math, false),
            e("Résous : 2x plus 6 égale 14.", "Réponds", "x égale 4", "🔢", .answerQuestion, .math, true),
            e("Quelle est la formule de l'aire d'un triangle ?", "Réponds", "Base fois hauteur divisé par 2", "📐", .answerQuestion, .math, false),
            e("Qu'est-ce qu'un nombre premier ?", "Explique et cite un exemple", "Divisible par 1 et lui-même. Ex : 7", "🔢", .answerQuestion, .math, true),
            e("Quel est le théorème de Pythagore ?", "Réponds", "Dans un triangle rectangle, a² + b² = c²", "📐", .answerQuestion, .math, false),
            // Sciences & Histoire
            e("Répète : La cellule est l'unité de base du vivant.", "Répète", "La cellule est l'unité de base du vivant", "🔬", .repeatAfterMe, .science, true),
            e("En quelle année a commencé la Première Guerre Mondiale ?", "Réponds", "1914", "📚", .answerQuestion, .science, false),
            e("Quelle est la formule chimique de l'eau ?", "Réponds", "H deux O", "💧", .answerQuestion, .science, true),
            e("Cite deux droits de l'enfant.", "Réponds", "Le droit à l'éducation et à la santé", "📜", .answerQuestion, .social, false),
            // Expression
            e("Décris ta journée idéale en une phrase.", "Réponds librement", "Ma journée idéale serait...", "🌟", .answerQuestion, .oral, true),
            e("Répète : Je pense que chaque personne mérite d'être respectée.", "Répète", "Je pense que chaque personne mérite d'être respectée", "🤝", .repeatAfterMe, .social, false),
            e("Comment demandes-tu de l'aide poliment ?", "Réponds", "Excusez-moi, pourriez-vous m'aider ?", "🙏", .answerQuestion, .social, true),
        ]
    }

    // MARK: - Helper
    private static func e(_ says: String, _ prompt: String, _ answer: String,
                           _ emoji: String, _ type: CurriculumExercise.ExerciseMode,
                           _ subject: CurriculumExercise.CurriculumSubject,
                           _ girl: Bool) -> CurriculumExercise {
        CurriculumExercise(characterSays: says, prompt: prompt,
                           expectedAnswer: answer, emoji: emoji,
                           type: type, subject: subject, useGirl: girl)
    }

    // Backward compat — plus utilisé mais garde la signature
    static func questions(for module: ModuleType, level: SchoolLevel, count: Int = 8) -> [Question] { [] }
}
