import Foundation

// MARK: - Bibliothèque d'exercices collège/lycée
struct CollegeContentLibrary {

    static func exercises(for subject: CollegeSubject,
                          level: CollegeLevel,
                          language: CollegeLanguage = .french,
                          count: Int = 8) -> [CollegeExercise] {
        let pool = allExercises(subject: subject, level: level, language: language)
        return Array(pool.shuffled().prefix(count))
    }

    private static func allExercises(subject: CollegeSubject, level: CollegeLevel, language: CollegeLanguage) -> [CollegeExercise] {
        switch subject {
        case .francais:      return CollegeNativeLangLibrary.exercises(level: level, language: language)
        case .histoire:      return CollegeHistoryLibrary.exercises(level: level, language: language)
        case .maths:         return mathsExercises(level: level)
        case .anglais:       return anglaisExercises(level: level, language: language)
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

    // MARK: - Langue étrangère (anglais pour la plupart, français pour anglophones)
    private static func anglaisExercises(level: CollegeLevel, language: CollegeLanguage) -> [CollegeExercise] {
        // Anglophones apprennent le français comme langue étrangère
        if language == .english {
            return foreignFrenchForEnglish(level: level)
        }
        // Tous les autres apprennent l'anglais
        var pool: [CollegeExercise] = [
            ex(.anglais, .multipleChoice,
               "Translate: 'My name is...'",
               ["Je m'appelle / My name is", "J'ai / I have", "Je suis / I am", "J'aime / I like"], "Je m'appelle / My name is",
               "'My name is' in English = 'Je m'appelle' in French.", "🇬🇧", 1),
            ex(.anglais, .trueFalse,
               "In English: 'He go to school' is correct.",
               ["Vrai", "Faux"], "Faux",
               "With he/she/it, add -s: 'He goes to school'. Only 'I/you/we/they' use the base form.", "📚", 2),
            ex(.anglais, .fillBlank,
               "Complete: '___ is the capital of England.'",
               [], "London",
               "London is the capital of England, and one of the largest cities in Europe.", "🏙️", 1),
            ex(.anglais, .multipleChoice,
               "Past tense of 'to go':",
               ["went", "goed", "gone", "go"], "went",
               "'Go' is irregular: go → went → gone.", "⏰", 2),
            ex(.anglais, .oral,
               "Introduce yourself in 2 sentences in English.",
               [], "My name is... I am ... years old and I like...",
               "Self-introduction: name, age, interests. A key social and academic skill.", "🗣️", 1),
            ex(.anglais, .multipleChoice,
               "What does 'although' mean?",
               ["Even though / despite", "Because", "Therefore", "If"], "Even though / despite",
               "'Although' introduces a concession: 'Although it rains, we play.' = même si.", "💬", 3),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex(.anglais, .fillBlank,
                   "Complete (passive): 'The book ___ (to write) by J.K. Rowling.'",
                   [], "was written",
                   "Passive past: was/were + past participle. 'write' → 'written'.", "✍️", 3),
                ex(.anglais, .multipleChoice,
                   "What tense is: 'I will have finished by 5pm'?",
                   ["Future perfect", "Present continuous", "Conditional", "Past simple"], "Future perfect",
                   "'Will have + past participle' = future perfect. Action completed before a future point.", "⏳", 3),
            ]
        }
        return pool
    }

    private static func foreignFrenchForEnglish(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.anglais, .multipleChoice,
               "How do you say 'My name is...' in French?",
               ["Je m'appelle...", "J'ai...", "Je suis...", "J'aime..."], "Je m'appelle...",
               "'Je m'appelle' literally means 'I call myself'. It's the standard French introduction.", "🇫🇷", 1),
            ex(.anglais, .trueFalse,
               "In French, adjectives usually come AFTER the noun.",
               ["True", "False"], "True",
               "E.g. 'une maison rouge' (a red house). Some short adjectives (grand, petit, beau) come before.", "📝", 2),
            ex(.anglais, .multipleChoice,
               "What does 'bonjour' mean?",
               ["Good morning / Hello", "Good night", "Goodbye", "Thank you"], "Good morning / Hello",
               "'Bonjour' is used as a daytime greeting in French. 'Bonsoir' is for the evening.", "👋", 1),
            ex(.anglais, .shortAnswer,
               "Conjugate 'avoir' (to have) for 'je'.",
               [], "j'ai",
               "'Avoir' is an irregular verb: j'ai, tu as, il a, nous avons, vous avez, ils ont.", "✍️", 2),
            ex(.anglais, .multipleChoice,
               "The French word for 'dog' is:",
               ["chien", "chat", "cheval", "cochon"], "chien",
               "Chien (m) = dog. Chat = cat. Cheval = horse. Cochon = pig.", "🐕", 1),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex(.anglais, .multipleChoice,
                   "Which is correct: 'Je suis allé' or 'J'ai allé'?",
                   ["Je suis allé", "J'ai allé", "Both are correct", "Neither"], "Je suis allé",
                   "'Aller' uses 'être' not 'avoir' in passé composé: je suis allé(e).", "⏰", 3),
                ex(.anglais, .shortAnswer,
                   "Translate: 'She has been living in Paris for three years.'",
                   [], "Elle habite à Paris depuis trois ans.",
                   "French uses present tense + 'depuis' where English uses present perfect continuous.", "🗼", 3),
            ]
        }
        return pool
    }

    // MARK: - Sciences (différencié par niveau)
    private static func sciencesExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = []

        // 6ème / 5ème — SVT et physique de base
        pool += [
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
            ex(.sciences, .oral,
               "Explique le cycle de l'eau en 2 phrases.",
               [], "L'eau s'évapore, forme des nuages, puis retombe en pluie.",
               "Le cycle de l'eau : évaporation → condensation → précipitations → ruissellement → évaporation.", "☁️", 2),
            ex(.sciences, .multipleChoice,
               "Quel organe filtre le sang dans notre corps ?",
               ["Les reins", "Le cœur", "Les poumons", "Le foie"], "Les reins",
               "Les reins filtrent le sang et produisent l'urine pour éliminer les déchets.", "🫘", 1),
        ]

        // 4ème / 3ème — Chimie, physique, génétique de base
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex(.sciences, .multipleChoice,
                   "De quoi est composé un atome ?",
                   ["Protons, neutrons, électrons", "Molécules et ions", "Cellules", "Photons"], "Protons, neutrons, électrons",
                   "L'atome est formé d'un noyau (protons + neutrons) entouré d'électrons.", "⚛️", 2),
                ex(.sciences, .multipleChoice,
                   "Qu'est-ce que la mitose ?",
                   ["Division cellulaire", "Reproduction sexuée", "Photosynthèse", "Digestion"], "Division cellulaire",
                   "La mitose est la division d'une cellule en deux cellules filles identiques.", "🔬", 3),
                ex(.sciences, .trueFalse,
                   "La vitesse de la lumière dans le vide est d'environ 300 000 km/s.",
                   ["Vrai", "Faux"], "Vrai",
                   "La vitesse de la lumière dans le vide est c ≈ 3×10⁸ m/s = 300 000 km/s.", "💡", 2),
                ex(.sciences, .shortAnswer,
                   "Quelle est la formule de la force (2ème loi de Newton) ?",
                   [], "F = m × a",
                   "F (force en Newtons) = m (masse en kg) × a (accélération en m/s²).", "⚖️", 3),
            ]
        }

        // Lycée — Terminale : génétique, chimie organique, physique avancée
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
                ex(.sciences, .multipleChoice,
                   "La méiose produit :",
                   ["Des cellules reproductrices (gamètes)", "Des cellules somatiques", "Des anticorps", "Des neurones"], "Des cellules reproductrices (gamètes)",
                   "La méiose produit des gamètes (ovule et spermatozoïde) avec moitié du nombre de chromosomes.", "🧫", 3),
                ex(.sciences, .shortAnswer,
                   "Qu'est-ce que le pH d'une solution ?",
                   [], "Mesure de l'acidité/basicité, de 0 (acide fort) à 14 (base forte), 7 = neutre.",
                   "Le pH mesure la concentration en ions H⁺. pH < 7 = acide, pH = 7 = neutre, pH > 7 = basique.", "🧪", 3),
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
