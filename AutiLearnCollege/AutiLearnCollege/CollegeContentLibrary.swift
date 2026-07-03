import Foundation

// MARK: - Bibliothèque d'exercices collège/lycée
struct CollegeContentLibrary {

    static func exercises(for subject: CollegeSubject,
                          level: CollegeLevel,
                          count: Int = 8) -> [CollegeExercise] {
        let pool = allExercises(subject: subject, level: level)
        let shuffled = pool.shuffled()
        return Array(shuffled.prefix(count))
    }

    private static func allExercises(subject: CollegeSubject, level: CollegeLevel) -> [CollegeExercise] {
        switch subject {
        case .francais:      return francaisExercises(level: level)
        case .maths:         return mathsExercises(level: level)
        case .anglais:       return anglaisExercises(level: level)
        case .histoire:      return histoireExercises(level: level)
        case .sciences:      return sciencesExercises(level: level)
        case .communication: return communicationExercises(level: level)
        }
    }

    // MARK: - Français
    private static func francaisExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = []

        // 6ème / 5ème
        pool += [
            ex(.francais, .multipleChoice,
               "Quel est le sujet dans : « Le chat mange la souris » ?",
               ["Le chat", "mange", "la souris", "Le"], "Le chat",
               "Le sujet indique qui fait l'action.", "🐱", 1),
            ex(.francais, .trueFalse,
               "Un nom propre prend toujours une majuscule.",
               ["Vrai", "Faux"], "Vrai",
               "Les noms propres (personnes, villes, pays) ont toujours une majuscule.", "✍️", 1),
            ex(.francais, .fillBlank,
               "Complète : « Le soleil ___ (briller) chaque matin. »",
               [], "brille",
               "Le verbe 'briller' conjugué au présent avec 'il/elle' donne 'brille'.", "☀️", 1),
            ex(.francais, .multipleChoice,
               "Qu'est-ce qu'un synonyme ?",
               ["Un mot de même sens", "Un mot contraire", "Un mot qui rime", "Un mot étranger"], "Un mot de même sens",
               "Un synonyme est un mot qui a le même sens qu'un autre. Ex : content = heureux.", "📖", 1),
            ex(.francais, .shortAnswer,
               "Donne un synonyme du mot 'rapide'.",
               [], "vite / véloce / prompt",
               "Rapide, vite, véloce, prompt sont synonymes.", "💨", 1),
            ex(.francais, .multipleChoice,
               "Dans « Elle est très belle », quel est l'adjectif ?",
               ["belle", "très", "elle", "est"], "belle",
               "L'adjectif qualificatif 'belle' décrit le sujet 'elle'.", "🌸", 1),
            ex(.francais, .trueFalse,
               "Le pluriel de 'journal' est 'journals'.",
               ["Vrai", "Faux"], "Faux",
               "Le pluriel de 'journal' est 'journaux'. Les mots en -al font leur pluriel en -aux.", "📰", 2),
            ex(.francais, .fillBlank,
               "Complète avec l'accord correct : « Les fleurs sont ___ (beau). »",
               [], "belles",
               "'Beau' s'accorde en genre et en nombre : fleurs (féminin pluriel) → belles.", "🌺", 2),
            ex(.francais, .multipleChoice,
               "Qu'est-ce qu'une métaphore ?",
               ["Une comparaison sans 'comme'", "Une comparaison avec 'comme'", "Un mot inventé", "Une répétition"], "Une comparaison sans 'comme'",
               "La métaphore compare sans outil de comparaison. Ex : « Il est un lion » = il est courageux.", "🦁", 2),
            ex(.francais, .oral,
               "Explique en une phrase ce qu'est un roman.",
               [], "Un roman est un récit long et fictif avec des personnages.",
               "Un roman est une œuvre de fiction longue, avec une histoire et des personnages inventés.", "📚", 2),
        ]

        // 4ème / 3ème / lycée — ajout d'exercices plus complexes
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex(.francais, .multipleChoice,
                   "Qu'est-ce qu'un oxymore ?",
                   ["Deux mots contraires ensemble", "Une répétition de sons", "Un mot rare", "Une question rhétorique"], "Deux mots contraires ensemble",
                   "L'oxymore associe deux mots de sens contraires. Ex : « une obscure clarté ».", "✨", 3),
                ex(.francais, .shortAnswer,
                   "Cite une figure de style et donne un exemple.",
                   [], "Métaphore : « La vie est un long fleuve tranquille »",
                   "Les figures de style enrichissent le langage : métaphore, comparaison, hyperbole, etc.", "🎭", 3),
                ex(.francais, .oral,
                   "Résume en 2 phrases le thème principal d'un livre que tu connais.",
                   [], "Réponse libre selon le livre choisi.",
                   "Résumer un texte consiste à dégager les idées essentielles sans détails superflus.", "📖", 3),
                ex(.francais, .multipleChoice,
                   "Le subjonctif est utilisé pour exprimer :",
                   ["Un doute ou un souhait", "Une certitude", "Le passé", "Une question"], "Un doute ou un souhait",
                   "Le subjonctif exprime le doute, le souhait, la nécessité. Ex : « Il faut que tu viennes ».", "❓", 3),
            ]
        }

        return pool
    }

    // MARK: - Maths
    private static func mathsExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = []

        pool += [
            ex(.maths, .shortAnswer,
               "Calcule : 7 × 8 = ?",
               [], "56",
               "7 × 8 = 56. Les tables de multiplication sont la base du calcul.", "✖️", 1),
            ex(.maths, .multipleChoice,
               "Qu'est-ce qu'un nombre premier ?",
               ["Divisible seulement par 1 et lui-même", "Pair", "Multiple de 5", "Inférieur à 10"], "Divisible seulement par 1 et lui-même",
               "Un nombre premier n'a que deux diviseurs : 1 et lui-même. Ex : 2, 3, 5, 7, 11...", "🔢", 2),
            ex(.maths, .shortAnswer,
               "Calcule l'aire d'un rectangle de 5 cm × 3 cm.",
               [], "15 cm²",
               "Aire = longueur × largeur = 5 × 3 = 15 cm²", "📐", 1),
            ex(.maths, .trueFalse,
               "La somme des angles d'un triangle est toujours 180°.",
               ["Vrai", "Faux"], "Vrai",
               "La somme des angles intérieurs d'un triangle est toujours 180°.", "📐", 2),
            ex(.maths, .multipleChoice,
               "Quel est le résultat de 3² (trois au carré) ?",
               ["6", "9", "8", "12"], "9",
               "3² = 3 × 3 = 9. L'exposant 2 signifie qu'on multiplie le nombre par lui-même.", "🔢", 1),
            ex(.maths, .shortAnswer,
               "Simplifie la fraction 6/8.",
               [], "3/4",
               "On divise le numérateur et le dénominateur par leur PGCD (2) : 6÷2 = 3 et 8÷2 = 4.", "➗", 2),
            ex(.maths, .multipleChoice,
               "Qu'est-ce qu'une équation ?",
               ["Une égalité avec une inconnue", "Un calcul sans inconnue", "Une fraction", "Un triangle"], "Une égalité avec une inconnue",
               "Une équation est une égalité contenant une inconnue (souvent x) à trouver.", "❓", 2),
            ex(.maths, .shortAnswer,
               "Résous : x + 5 = 12, x = ?",
               [], "7",
               "x = 12 - 5 = 7. On isole l'inconnue en faisant la même opération des deux côtés.", "🔡", 2),
        ]

        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex(.maths, .shortAnswer,
                   "Développe : (x + 3)(x + 2) = ?",
                   [], "x² + 5x + 6",
                   "(x+3)(x+2) = x²+2x+3x+6 = x²+5x+6 — on utilise la distributivité double.", "📊", 3),
                ex(.maths, .multipleChoice,
                   "Le théorème de Pythagore s'applique à :",
                   ["Un triangle rectangle", "Tout triangle", "Un carré", "Un cercle"], "Un triangle rectangle",
                   "Pythagore : dans un triangle rectangle, a²+b²=c² où c est l'hypoténuse.", "📐", 3),
                ex(.maths, .trueFalse,
                   "√16 = 4",
                   ["Vrai", "Faux"], "Vrai",
                   "√16 = 4 car 4² = 16. La racine carrée est l'opération inverse du carré.", "√", 2),
                ex(.maths, .shortAnswer,
                   "Calcule le périmètre d'un cercle de rayon 5 cm. (π ≈ 3,14)",
                   [], "31,4 cm",
                   "P = 2 × π × r = 2 × 3,14 × 5 = 31,4 cm", "⭕", 3),
            ]
        }

        if level.isLycee {
            pool += [
                ex(.maths, .shortAnswer,
                   "Calcule la dérivée de f(x) = x³ + 2x.",
                   [], "f'(x) = 3x² + 2",
                   "La dérivée de xⁿ est n·xⁿ⁻¹. Donc (x³)' = 3x² et (2x)' = 2.", "📈", 3),
                ex(.maths, .multipleChoice,
                   "Qu'est-ce qu'un vecteur ?",
                   ["Un segment orienté", "Un angle", "Un cercle", "Une fraction"], "Un segment orienté",
                   "Un vecteur est défini par une direction, un sens et une norme (longueur).", "➡️", 3),
            ]
        }

        return pool
    }

    // MARK: - Anglais
    private static func anglaisExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = []

        pool += [
            ex(.anglais, .multipleChoice,
               "Traduis en anglais : « Je m'appelle... »",
               ["My name is...", "I have...", "I am...", "I like..."], "My name is...",
               "'My name is' signifie littéralement 'mon nom est'.", "🇬🇧", 1),
            ex(.anglais, .trueFalse,
               "En anglais, on dit 'I goes to school'.",
               ["Vrai", "Faux"], "Faux",
               "Avec 'I', on dit 'I go'. Le 's' du présent simple s'ajoute seulement avec he/she/it.", "📚", 2),
            ex(.anglais, .fillBlank,
               "Complète : « ___ is the capital of England. »",
               [], "London",
               "London (Londres) est la capitale de l'Angleterre.", "🏙️", 1),
            ex(.anglais, .multipleChoice,
               "Quel est le prétérit de 'to go' ?",
               ["went", "goed", "gone", "go"], "went",
               "'Go' est un verbe irrégulier : go → went → gone.", "⏰", 2),
            ex(.anglais, .shortAnswer,
               "Traduis : 'The dog is running in the garden.'",
               [], "Le chien court dans le jardin.",
               "The dog = le chien / is running = court (présent continu) / in the garden = dans le jardin.", "🐕", 1),
            ex(.anglais, .oral,
               "Présente-toi en 2 phrases en anglais.",
               [], "My name is... I am ... years old and I like...",
               "Se présenter en anglais : nom, âge, goûts. C'est la base de la communication.", "🗣️", 1),
            ex(.anglais, .multipleChoice,
               "Que signifie 'although' ?",
               ["Bien que / même si", "Parce que", "Donc", "Si"], "Bien que / même si",
               "'Although' introduit une concession : Although it rains, we play. = Bien qu'il pleuve, on joue.", "💬", 3),
        ]

        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex(.anglais, .fillBlank,
                   "Complète au passif : « The book ___ (to write) by J.K. Rowling. »",
                   [], "was written",
                   "La voix passive au prétérit : was/were + participe passé. 'write' → 'written'.", "✍️", 3),
                ex(.anglais, .multipleChoice,
                   "Quel temps est 'I will have finished by 5pm'?",
                   ["Futur antérieur", "Présent continu", "Conditionnel", "Prétérit"], "Futur antérieur",
                   "'Will have + past participle' = futur antérieur (future perfect).", "⏳", 3),
            ]
        }

        return pool
    }

    // MARK: - Histoire-Géo
    private static func histoireExercises(level: CollegeLevel) -> [CollegeExercise] {
        [
            ex(.histoire, .multipleChoice,
               "En quelle année a débuté la Première Guerre mondiale ?",
               ["1914", "1918", "1939", "1905"], "1914",
               "La Première Guerre mondiale a débuté en 1914 et s'est terminée en 1918.", "🏛️", 2),
            ex(.histoire, .trueFalse,
               "La Révolution française a eu lieu en 1789.",
               ["Vrai", "Faux"], "Vrai",
               "La Révolution française commence le 14 juillet 1789 avec la prise de la Bastille.", "🗼", 1),
            ex(.histoire, .multipleChoice,
               "Quel est le plus grand pays du monde ?",
               ["Russie", "Canada", "Chine", "États-Unis"], "Russie",
               "La Russie est le plus grand pays du monde avec 17 millions de km².", "🌍", 1),
            ex(.histoire, .shortAnswer,
               "Cite deux causes de la Seconde Guerre mondiale.",
               [], "Montée du nazisme / Crise économique / Traité de Versailles humiliant",
               "La montée du nazisme, la crise de 1929 et les clauses humiliantes du traité de Versailles.", "📜", 3),
            ex(.histoire, .multipleChoice,
               "Le mur de Berlin est tombé en :",
               ["1989", "1979", "1999", "1969"], "1989",
               "Le mur de Berlin, symbole de la Guerre froide, est tombé le 9 novembre 1989.", "🧱", 2),
            ex(.histoire, .oral,
               "Explique pourquoi l'Union européenne a été créée.",
               [], "Pour assurer la paix, la coopération économique et la stabilité en Europe.",
               "L'UE est née après les guerres pour garantir la paix et la prospérité en Europe.", "🇪🇺", 3),
        ]
    }

    // MARK: - Sciences
    private static func sciencesExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.sciences, .multipleChoice,
               "De quoi est composé un atome ?",
               ["Protons, neutrons, électrons", "Molécules et ions", "Cellules", "Photons"], "Protons, neutrons, électrons",
               "L'atome est formé d'un noyau (protons + neutrons) entouré d'électrons.", "⚛️", 2),
            ex(.sciences, .trueFalse,
               "La photosynthèse produit de l'oxygène.",
               ["Vrai", "Faux"], "Vrai",
               "Les plantes utilisent CO₂ + eau + lumière → glucose + O₂ (oxygène).", "🌿", 1),
            ex(.sciences, .multipleChoice,
               "Quelle est la formule chimique de l'eau ?",
               ["H₂O", "CO₂", "O₂", "NaCl"], "H₂O",
               "L'eau est composée de 2 atomes d'hydrogène et 1 atome d'oxygène.", "💧", 1),
            ex(.sciences, .shortAnswer,
               "Cite les 3 états de la matière.",
               [], "Solide, liquide, gazeux",
               "La matière peut être solide (glace), liquide (eau) ou gazeuse (vapeur).", "🧊", 1),
            ex(.sciences, .multipleChoice,
               "Qu'est-ce que la mitose ?",
               ["Division cellulaire", "Reproduction sexuée", "Photosynthèse", "Digestion"], "Division cellulaire",
               "La mitose est la division d'une cellule en deux cellules filles identiques.", "🔬", 3),
            ex(.sciences, .oral,
               "Explique le cycle de l'eau en 2 phrases.",
               [], "L'eau s'évapore, forme des nuages, puis retombe en pluie.",
               "Le cycle de l'eau : évaporation → condensation → précipitations → ruissellement → évaporation.", "☁️", 2),
        ]

        if level.isLycee {
            pool += [
                ex(.sciences, .multipleChoice,
                   "Qu'est-ce que l'ADN ?",
                   ["Le support de l'information génétique", "Une protéine", "Une cellule", "Un organe"], "Le support de l'information génétique",
                   "L'ADN (acide désoxyribonucléique) contient toute l'information génétique d'un organisme.", "🧬", 3),
                ex(.sciences, .shortAnswer,
                   "Donne la formule de la loi d'Ohm.",
                   [], "U = R × I",
                   "Loi d'Ohm : U (tension en volts) = R (résistance en ohms) × I (intensité en ampères).", "⚡", 3),
            ]
        }

        return pool
    }

    // MARK: - Communication sociale (spécifique TSA)
    private static func communicationExercises(level: CollegeLevel) -> [CollegeExercise] {
        [
            ex(.communication, .multipleChoice,
               "Quand on veut parler à quelqu'un, on commence par :",
               ["Appeler son prénom / dire bonjour", "Parler directement du sujet", "Attendre qu'il finisse", "Lever la main"], "Appeler son prénom / dire bonjour",
               "Attirer l'attention poliment avant de parler montre du respect.", "👋", 1),
            ex(.communication, .oral,
               "Demande poliment à quelqu'un de répéter ce qu'il vient de dire.",
               [], "« Excuse-moi, peux-tu répéter s'il te plaît ? »",
               "Demander de répéter est naturel et poli. C'est une compétence sociale importante.", "👂", 1),
            ex(.communication, .trueFalse,
               "Couper la parole à quelqu'un pendant qu'il parle est poli.",
               ["Vrai", "Faux"], "Faux",
               "Il faut attendre que l'autre ait fini de parler avant de prendre la parole.", "🚦", 1),
            ex(.communication, .multipleChoice,
               "Si tu ne comprends pas une consigne en classe, tu dois :",
               ["Lever la main et demander", "Ne rien faire", "Faire autre chose", "Partir"], "Lever la main et demander",
               "Lever la main pour demander de l'aide est la bonne stratégie en classe.", "✋", 1),
            ex(.communication, .oral,
               "Comment exprimer que tu es fatigué(e) à un adulte ?",
               [], "« Je me sens fatigué(e), j'ai besoin d'une pause. »",
               "Exprimer ses besoins clairement aide les autres à nous soutenir.", "😴", 2),
            ex(.communication, .multipleChoice,
               "Quand une personne dit 'ça va' mais a l'air triste, elle ressent probablement :",
               ["De la tristesse", "De la joie", "De la colère", "De la peur"], "De la tristesse",
               "Les expressions et le ton de voix peuvent indiquer une émotion différente des mots.", "😟", 2),
            ex(.communication, .oral,
               "Comment résoudre un désaccord avec un camarade ?",
               [], "En parlant calmement et en écoutant son point de vue.",
               "La résolution de conflit passe par le dialogue calme et l'écoute mutuelle.", "🤝", 2),
            ex(.communication, .multipleChoice,
               "Le sarcasme, c'est :",
               ["Dire le contraire de ce qu'on pense de façon moqueuse", "Un compliment sincère", "Une question directe", "Une règle de politesse"], "Dire le contraire de ce qu'on pense de façon moqueuse",
               "Le sarcasme est souvent difficile à détecter pour les personnes avec TSA — c'est normal.", "💬", 3),
        ]
    }

    // MARK: - Helper
    private static func ex(_ subject: CollegeSubject, _ mode: CollegeExerciseMode,
                            _ question: String, _ choices: [String], _ answer: String,
                            _ explanation: String, _ emoji: String, _ difficulty: Int) -> CollegeExercise {
        CollegeExercise(subject: subject, mode: mode, question: question, choices: choices,
                        correctAnswer: answer, explanation: explanation, emoji: emoji, difficulty: difficulty)
    }
}
