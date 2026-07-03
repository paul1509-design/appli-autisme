import Foundation

// MARK: - Exercice pédagogique
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
    }
}

struct ContentLibrary {

    static func exercises(for module: ModuleType,
                          level: SchoolLevel,
                          language: AppLanguage = .french,
                          count: Int = 8) -> [CurriculumExercise] {
        let pool: [CurriculumExercise]
        switch language {
        case .french:     pool = french(level, module)
        case .english:    pool = english(level, module)
        case .spanish:    pool = spanish(level, module)
        case .portuguese: pool = portuguese(level, module)
        case .italian:    pool = italian(level, module)
        case .german:     pool = german(level, module)
        case .arabic:     pool = arabic(level, module)
        case .dutch:      pool = dutch(level, module)
        }
        return Array(pool.shuffled().prefix(count))
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

    // MARK: - FRENCH
    private static func french(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return frLevel0()
        case .level1: return frLevel1()
        case .level2: return frLevel2()
        case .level3: return frLevel3()
        }
    }

    private static func frLevel0() -> [CurriculumExercise] { [
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
        e("Je suis content.", "Répète", "Je suis content", "😊", .repeatAfterMe, .social, false),
        e("Je suis triste.", "Répète", "Je suis triste", "😢", .repeatAfterMe, .social, true),
        e("C'est rouge !", "Répète la couleur", "Rouge", "🔴", .repeatAfterMe, .oral, false),
        e("C'est bleu !", "Répète la couleur", "Bleu", "🔵", .repeatAfterMe, .oral, true),
        e("C'est jaune !", "Répète la couleur", "Jaune", "🟡", .repeatAfterMe, .oral, false),
        e("C'est vert !", "Répète la couleur", "Vert", "🟢", .repeatAfterMe, .oral, true),
        e("Un, deux, trois !", "Répète les chiffres", "Un, deux, trois", "🔢", .repeatAfterMe, .math, false),
        e("Quatre, cinq !", "Répète les chiffres", "Quatre, cinq", "🔢", .repeatAfterMe, .math, true),
        e("Le chat dit miaou.", "Répète", "Le chat dit miaou", "🐱", .repeatAfterMe, .oral, false),
        e("Le chien dit ouaf.", "Répète", "Le chien dit ouaf", "🐶", .repeatAfterMe, .oral, true),
        e("Maman.", "Répète ce mot", "Maman", "👩", .repeatAfterMe, .oral, false),
        e("Papa.", "Répète ce mot", "Papa", "👨", .repeatAfterMe, .oral, true),
        e("Encore !", "Répète ce mot", "Encore", "🔁", .repeatAfterMe, .oral, false),
        e("Fini !", "Répète ce mot", "Fini", "🏁", .repeatAfterMe, .oral, true),
        e("C'est chaud !", "Répète", "C'est chaud", "🔥", .repeatAfterMe, .oral, false),
        e("C'est froid !", "Répète", "C'est froid", "❄️", .repeatAfterMe, .oral, true),
        e("Dors bien !", "Répète", "Dors bien", "😴", .repeatAfterMe, .social, false),
    ] }

    private static func frLevel1() -> [CurriculumExercise] { [
        e("Répète : Le chat mange une souris.", "Répète la phrase", "Le chat mange une souris", "🐱", .repeatAfterMe, .oral, true),
        e("Répète : La fille joue dans le jardin.", "Répète la phrase", "La fille joue dans le jardin", "🌸", .repeatAfterMe, .oral, false),
        e("Répète : Le soleil brille aujourd'hui.", "Répète la phrase", "Le soleil brille aujourd'hui", "☀️", .repeatAfterMe, .oral, true),
        e("Qu'est-ce que tu vois ?", "Regarde 🐶 et réponds", "Je vois un chien", "🐶", .answerQuestion, .oral, false),
        e("C'est de quelle couleur ?", "Regarde 🍎 et réponds", "C'est rouge", "🍎", .answerQuestion, .oral, true),
        e("Répète : Je lis un livre.", "Répète", "Je lis un livre", "📖", .repeatAfterMe, .reading, false),
        e("Répète : J'écris mon prénom.", "Répète", "J'écris mon prénom", "✏️", .repeatAfterMe, .writing, true),
        e("Le son A — comme dans ARBRE.", "Répète le son et le mot", "A — Arbre", "🌳", .repeatAfterMe, .reading, false),
        e("Le son O — comme dans OISEAU.", "Répète le son et le mot", "O — Oiseau", "🐦", .repeatAfterMe, .reading, true),
        e("Lis : MA-MAN.", "Lis les syllabes", "Maman", "👩", .repeatAfterMe, .reading, false),
        e("Lis : cha-peau.", "Lis les syllabes", "Chapeau", "🎩", .repeatAfterMe, .reading, true),
        e("Lis : ma-i-son.", "Lis les syllabes", "Maison", "🏠", .repeatAfterMe, .reading, false),
        e("Combien font 2 plus 3 ?", "Réponds à voix haute", "5", "🔢", .answerQuestion, .math, true),
        e("Combien font 4 plus 1 ?", "Réponds à voix haute", "5", "🔢", .answerQuestion, .math, false),
        e("Combien font 3 plus 3 ?", "Réponds à voix haute", "6", "🔢", .answerQuestion, .math, true),
        e("Compte jusqu'à 10.", "Compte à voix haute", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, false),
        e("Combien font 5 moins 2 ?", "Réponds", "3", "🔢", .answerQuestion, .math, true),
        e("Qu'est-ce qu'on dit quand on arrive ?", "Réponds", "Bonjour", "🏫", .answerQuestion, .social, false),
        e("Qu'est-ce qu'on dit quand on part ?", "Réponds", "Au revoir", "👋", .answerQuestion, .social, true),
        e("Répète : Je lève la main pour parler.", "Répète la règle", "Je lève la main pour parler", "✋", .repeatAfterMe, .social, false),
        e("Lis : pa-pi-llon.", "Lis les syllabes", "Papillon", "🦋", .repeatAfterMe, .reading, true),
        e("Lis : é-lé-phant.", "Lis les syllabes", "Éléphant", "🐘", .repeatAfterMe, .reading, false),
        e("Répète : Je range mes affaires.", "Répète", "Je range mes affaires", "🎒", .repeatAfterMe, .social, true),
        e("Répète : Je partage avec mes amis.", "Répète", "Je partage avec mes amis", "🤝", .repeatAfterMe, .social, false),
        e("7 est-il plus grand que 3 ?", "Réponds", "Oui 7 est plus grand que 3", "🔢", .answerQuestion, .math, true),
    ] }

    private static func frLevel2() -> [CurriculumExercise] { [
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
        e("Combien font 7 fois 8 ?", "Réponds", "56", "🔢", .answerQuestion, .math, true),
        e("Combien font 6 fois 9 ?", "Réponds", "54", "🔢", .answerQuestion, .math, false),
        e("Combien font 45 divisé par 9 ?", "Réponds", "5", "🔢", .answerQuestion, .math, true),
        e("Quelle est la moitié de 80 ?", "Réponds", "40", "🔢", .answerQuestion, .math, false),
        e("Combien font 234 plus 156 ?", "Calcule et réponds", "390", "🔢", .answerQuestion, .math, true),
        e("Quelle est la capitale de la France ?", "Réponds", "Paris", "🗼", .answerQuestion, .science, false),
        e("Cite trois planètes.", "Réponds", "Mercure Vénus Mars", "🪐", .answerQuestion, .science, true),
        e("De quoi les plantes ont-elles besoin ?", "Réponds", "Eau lumière et terre", "🌱", .answerQuestion, .science, false),
        e("Répète : La photosynthèse permet aux plantes de se nourrir.", "Répète", "La photosynthèse permet aux plantes de se nourrir", "🌿", .repeatAfterMe, .science, true),
        e("Quels sont les trois états de l'eau ?", "Réponds", "Liquide solide gazeux", "💧", .answerQuestion, .science, false),
        e("Répète : Les fleurs poussent au printemps.", "Répète", "Les fleurs poussent au printemps", "🌸", .repeatAfterMe, .oral, true),
        e("Quel est le périmètre d'un carré de côté 5 ?", "Réponds", "20", "📐", .answerQuestion, .math, false),
        e("Convertis 2 km en mètres.", "Réponds", "2000 mètres", "📏", .answerQuestion, .math, true),
        e("Quel est le COD dans : Je mange une pomme ?", "Réponds", "Une pomme", "🍎", .answerQuestion, .reading, false),
        e("Répète : Nous vivons sur la planète Terre.", "Répète", "Nous vivons sur la planète Terre", "🌍", .repeatAfterMe, .science, true),
    ] }

    private static func frLevel3() -> [CurriculumExercise] { [
        e("Répète : La liberté d'expression est un droit fondamental.", "Répète", "La liberté d'expression est un droit fondamental", "📜", .repeatAfterMe, .oral, true),
        e("Qu'est-ce qu'une métaphore ?", "Explique et donne un exemple", "Une image sans comme. Ex : Il est un lion", "📖", .answerQuestion, .reading, false),
        e("Conjugue VOULOIR au conditionnel : je...", "Réponds", "Je voudrais", "📝", .answerQuestion, .writing, true),
        e("Résous : 2x plus 6 égale 14.", "Réponds", "x égale 4", "🔢", .answerQuestion, .math, false),
        e("Quel est le théorème de Pythagore ?", "Réponds", "Dans un triangle rectangle a² plus b² égale c²", "📐", .answerQuestion, .math, true),
        e("Répète : La cellule est l'unité de base du vivant.", "Répète", "La cellule est l'unité de base du vivant", "🔬", .repeatAfterMe, .science, false),
        e("En quelle année a commencé la Première Guerre Mondiale ?", "Réponds", "1914", "📚", .answerQuestion, .science, true),
        e("Quelle est la formule chimique de l'eau ?", "Réponds", "H deux O", "💧", .answerQuestion, .science, false),
        e("Cite deux droits de l'enfant.", "Réponds", "Le droit à l'éducation et à la santé", "📜", .answerQuestion, .social, true),
        e("Décris ta journée idéale en une phrase.", "Réponds librement", "Ma journée idéale serait...", "🌟", .answerQuestion, .oral, false),
    ] }

    // MARK: - ENGLISH
    private static func english(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return enLevel0()
        case .level1: return enLevel1()
        case .level2: return enLevel2()
        case .level3: return enLevel3()
        }
    }

    private static func enLevel0() -> [CurriculumExercise] { [
        e("Say hello!", "Repeat this word", "Hello", "👋", .repeatAfterMe, .oral, true),
        e("Goodbye!", "Repeat this word", "Goodbye", "👋", .repeatAfterMe, .oral, false),
        e("Thank you!", "Repeat this word", "Thank you", "🙏", .repeatAfterMe, .oral, true),
        e("Please.", "Repeat", "Please", "🙏", .repeatAfterMe, .oral, false),
        e("Yes.", "Repeat this word", "Yes", "✅", .repeatAfterMe, .oral, true),
        e("No.", "Repeat this word", "No", "❌", .repeatAfterMe, .oral, false),
        e("What is your name?", "Answer the question", "My name is...", "🧒", .answerQuestion, .social, false),
        e("I am hungry.", "Repeat this sentence", "I am hungry", "🍽️", .repeatAfterMe, .oral, true),
        e("I am thirsty.", "Repeat this sentence", "I am thirsty", "💧", .repeatAfterMe, .oral, false),
        e("I am tired.", "Repeat this sentence", "I am tired", "😴", .repeatAfterMe, .oral, true),
        e("I want to play.", "Repeat this sentence", "I want to play", "🎮", .repeatAfterMe, .oral, false),
        e("I want to eat.", "Repeat this sentence", "I want to eat", "🍎", .repeatAfterMe, .oral, true),
        e("Help me please.", "Repeat", "Help me please", "🤝", .repeatAfterMe, .social, false),
        e("I am happy.", "Repeat", "I am happy", "😊", .repeatAfterMe, .social, true),
        e("I am sad.", "Repeat", "I am sad", "😢", .repeatAfterMe, .social, false),
        e("It is red!", "Repeat the colour", "Red", "🔴", .repeatAfterMe, .oral, true),
        e("It is blue!", "Repeat the colour", "Blue", "🔵", .repeatAfterMe, .oral, false),
        e("It is yellow!", "Repeat the colour", "Yellow", "🟡", .repeatAfterMe, .oral, true),
        e("It is green!", "Repeat the colour", "Green", "🟢", .repeatAfterMe, .oral, false),
        e("One, two, three!", "Repeat the numbers", "One, two, three", "🔢", .repeatAfterMe, .math, true),
        e("Four, five!", "Repeat the numbers", "Four, five", "🔢", .repeatAfterMe, .math, false),
        e("The cat says meow.", "Repeat", "The cat says meow", "🐱", .repeatAfterMe, .oral, true),
        e("The dog says woof.", "Repeat", "The dog says woof", "🐶", .repeatAfterMe, .oral, false),
        e("Mummy.", "Repeat this word", "Mummy", "👩", .repeatAfterMe, .oral, true),
        e("Daddy.", "Repeat this word", "Daddy", "👨", .repeatAfterMe, .oral, false),
        e("More!", "Repeat this word", "More", "🔁", .repeatAfterMe, .oral, true),
        e("Finished!", "Repeat this word", "Finished", "🏁", .repeatAfterMe, .oral, false),
        e("It is hot!", "Repeat", "It is hot", "🔥", .repeatAfterMe, .oral, true),
        e("It is cold!", "Repeat", "It is cold", "❄️", .repeatAfterMe, .oral, false),
        e("Good night!", "Repeat", "Good night", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func enLevel1() -> [CurriculumExercise] { [
        e("Repeat: The cat eats a fish.", "Repeat the sentence", "The cat eats a fish", "🐱", .repeatAfterMe, .oral, true),
        e("Repeat: The girl plays in the garden.", "Repeat the sentence", "The girl plays in the garden", "🌸", .repeatAfterMe, .oral, false),
        e("Repeat: The sun is shining today.", "Repeat the sentence", "The sun is shining today", "☀️", .repeatAfterMe, .oral, true),
        e("What do you see?", "Look at 🐶 and answer", "I see a dog", "🐶", .answerQuestion, .oral, false),
        e("What colour is it?", "Look at 🍎 and answer", "It is red", "🍎", .answerQuestion, .oral, true),
        e("The sound A — as in APPLE.", "Repeat the sound and word", "A — Apple", "🍎", .repeatAfterMe, .reading, false),
        e("The sound B — as in BALL.", "Repeat the sound and word", "B — Ball", "⚽", .repeatAfterMe, .reading, true),
        e("Read: CAT.", "Read the word", "Cat", "🐱", .repeatAfterMe, .reading, false),
        e("Read: DOG.", "Read the word", "Dog", "🐶", .repeatAfterMe, .reading, true),
        e("Read: SUN.", "Read the word", "Sun", "☀️", .repeatAfterMe, .reading, false),
        e("How much is 2 plus 3?", "Answer out loud", "5", "🔢", .answerQuestion, .math, true),
        e("How much is 4 plus 1?", "Answer out loud", "5", "🔢", .answerQuestion, .math, false),
        e("Count to 10.", "Count out loud", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, true),
        e("How much is 5 minus 2?", "Answer", "3", "🔢", .answerQuestion, .math, false),
        e("What do you say when you arrive?", "Answer", "Hello", "🏫", .answerQuestion, .social, true),
        e("What do you say when you leave?", "Answer", "Goodbye", "👋", .answerQuestion, .social, false),
        e("Repeat: I raise my hand to speak.", "Repeat the rule", "I raise my hand to speak", "✋", .repeatAfterMe, .social, true),
        e("Repeat: I share with my friends.", "Repeat", "I share with my friends", "🤝", .repeatAfterMe, .social, false),
        e("Repeat: I read a book every day.", "Repeat", "I read a book every day", "📖", .repeatAfterMe, .reading, true),
        e("Is 7 bigger than 3?", "Answer", "Yes 7 is bigger than 3", "🔢", .answerQuestion, .math, false),
        e("Repeat: I tidy my things.", "Repeat", "I tidy my things", "🎒", .repeatAfterMe, .social, true),
        e("Read: BUT-TER-FLY.", "Read the syllables", "Butterfly", "🦋", .repeatAfterMe, .reading, false),
        e("Read: EL-E-PHANT.", "Read the syllables", "Elephant", "🐘", .repeatAfterMe, .reading, true),
        e("How much is 3 plus 3?", "Answer", "6", "🔢", .answerQuestion, .math, false),
        e("Spell your name.", "Say each letter", "My name is...", "🔤", .answerQuestion, .writing, true),
    ] }

    private static func enLevel2() -> [CurriculumExercise] { [
        e("Repeat: The dog runs after the red ball.", "Repeat the sentence", "The dog runs after the red ball", "🐕", .repeatAfterMe, .oral, true),
        e("What is the subject of: The birds sing?", "Answer", "The birds", "🐦", .answerQuestion, .reading, false),
        e("Conjugate TO GO in present: I...", "Complete", "I go", "📝", .answerQuestion, .writing, true),
        e("Conjugate TO BE in present: he...", "Complete", "He is", "📝", .answerQuestion, .writing, false),
        e("What is the plural of CHILD?", "Answer", "Children", "👶", .answerQuestion, .writing, true),
        e("Give a synonym for HAPPY.", "Answer", "Joyful", "😊", .answerQuestion, .writing, false),
        e("Give an antonym for BIG.", "Answer", "Small", "📏", .answerQuestion, .writing, true),
        e("How much is 7 times 8?", "Answer", "56", "🔢", .answerQuestion, .math, false),
        e("How much is 6 times 9?", "Answer", "54", "🔢", .answerQuestion, .math, true),
        e("How much is 45 divided by 9?", "Answer", "5", "🔢", .answerQuestion, .math, false),
        e("What is half of 80?", "Answer", "40", "🔢", .answerQuestion, .math, true),
        e("What is the capital of England?", "Answer", "London", "🏛️", .answerQuestion, .science, false),
        e("Name three planets.", "Answer", "Mercury Venus Mars", "🪐", .answerQuestion, .science, true),
        e("What do plants need to grow?", "Answer", "Water light and soil", "🌱", .answerQuestion, .science, false),
        e("What are the three states of water?", "Answer", "Liquid solid gas", "💧", .answerQuestion, .science, true),
        e("Repeat: Flowers bloom in spring.", "Repeat", "Flowers bloom in spring", "🌸", .repeatAfterMe, .oral, false),
        e("What is the perimeter of a square with side 5?", "Answer", "20", "📐", .answerQuestion, .math, true),
        e("Convert 2 km into metres.", "Answer", "2000 metres", "📏", .answerQuestion, .math, false),
        e("Repeat: We eat fresh fruit every morning.", "Repeat", "We eat fresh fruit every morning", "🍎", .repeatAfterMe, .oral, true),
        e("Repeat: Photosynthesis helps plants make food.", "Repeat", "Photosynthesis helps plants make food", "🌿", .repeatAfterMe, .science, false),
        e("What is the object in: I eat an apple?", "Answer", "An apple", "🍎", .answerQuestion, .reading, true),
        e("How much is 234 plus 156?", "Calculate and answer", "390", "🔢", .answerQuestion, .math, false),
        e("Repeat: We live on planet Earth.", "Repeat", "We live on planet Earth", "🌍", .repeatAfterMe, .science, true),
        e("Conjugate TO HAVE in present: we...", "Complete", "We have", "📝", .answerQuestion, .writing, false),
        e("Repeat: I always try my best.", "Repeat", "I always try my best", "🌟", .repeatAfterMe, .social, true),
    ] }

    private static func enLevel3() -> [CurriculumExercise] { [
        e("Repeat: Freedom of speech is a fundamental right.", "Repeat", "Freedom of speech is a fundamental right", "📜", .repeatAfterMe, .oral, true),
        e("What is a metaphor? Give an example.", "Answer", "A comparison without like or as. He is a lion", "📖", .answerQuestion, .reading, false),
        e("Solve: 2x plus 6 equals 14.", "Answer", "x equals 4", "🔢", .answerQuestion, .math, true),
        e("State the theorem of Pythagoras.", "Answer", "In a right triangle a squared plus b squared equals c squared", "📐", .answerQuestion, .math, false),
        e("Repeat: The cell is the basic unit of life.", "Repeat", "The cell is the basic unit of life", "🔬", .repeatAfterMe, .science, true),
        e("In what year did World War One begin?", "Answer", "1914", "📚", .answerQuestion, .science, false),
        e("What is the chemical formula for water?", "Answer", "H two O", "💧", .answerQuestion, .science, true),
        e("Name two children's rights.", "Answer", "The right to education and to health", "📜", .answerQuestion, .social, false),
        e("Describe your ideal day in one sentence.", "Answer freely", "My ideal day would be...", "🌟", .answerQuestion, .oral, true),
        e("Repeat: I believe every person deserves respect.", "Repeat", "I believe every person deserves respect", "🤝", .repeatAfterMe, .social, false),
    ] }

    // MARK: - SPANISH
    private static func spanish(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return esLevel0()
        case .level1: return esLevel1()
        case .level2: return esLevel2()
        case .level3: return esLevel3()
        }
    }

    private static func esLevel0() -> [CurriculumExercise] { [
        e("¡Di hola!", "Repite esta palabra", "Hola", "👋", .repeatAfterMe, .oral, true),
        e("¡Adiós!", "Repite esta palabra", "Adiós", "👋", .repeatAfterMe, .oral, false),
        e("¡Gracias!", "Repite esta palabra", "Gracias", "🙏", .repeatAfterMe, .oral, true),
        e("Por favor.", "Repite", "Por favor", "🙏", .repeatAfterMe, .oral, false),
        e("Sí.", "Repite esta palabra", "Sí", "✅", .repeatAfterMe, .oral, true),
        e("No.", "Repite esta palabra", "No", "❌", .repeatAfterMe, .oral, false),
        e("¿Cómo te llamas?", "Responde a la pregunta", "Me llamo...", "🧒", .answerQuestion, .social, false),
        e("Tengo hambre.", "Repite esta frase", "Tengo hambre", "🍽️", .repeatAfterMe, .oral, true),
        e("Tengo sed.", "Repite esta frase", "Tengo sed", "💧", .repeatAfterMe, .oral, false),
        e("Me duele.", "Repite esta frase", "Me duele", "🤕", .repeatAfterMe, .oral, true),
        e("Quiero jugar.", "Repite esta frase", "Quiero jugar", "🎮", .repeatAfterMe, .oral, false),
        e("Quiero comer.", "Repite esta frase", "Quiero comer", "🍎", .repeatAfterMe, .oral, true),
        e("Ayúdame por favor.", "Repite", "Ayúdame por favor", "🤝", .repeatAfterMe, .social, false),
        e("Estoy contento.", "Repite", "Estoy contento", "😊", .repeatAfterMe, .social, true),
        e("Estoy triste.", "Repite", "Estoy triste", "😢", .repeatAfterMe, .social, false),
        e("¡Es rojo!", "Repite el color", "Rojo", "🔴", .repeatAfterMe, .oral, true),
        e("¡Es azul!", "Repite el color", "Azul", "🔵", .repeatAfterMe, .oral, false),
        e("¡Es amarillo!", "Repite el color", "Amarillo", "🟡", .repeatAfterMe, .oral, true),
        e("¡Es verde!", "Repite el color", "Verde", "🟢", .repeatAfterMe, .oral, false),
        e("¡Uno, dos, tres!", "Repite los números", "Uno, dos, tres", "🔢", .repeatAfterMe, .math, true),
        e("¡Cuatro, cinco!", "Repite los números", "Cuatro, cinco", "🔢", .repeatAfterMe, .math, false),
        e("El gato dice miau.", "Repite", "El gato dice miau", "🐱", .repeatAfterMe, .oral, true),
        e("El perro dice guau.", "Repite", "El perro dice guau", "🐶", .repeatAfterMe, .oral, false),
        e("Mamá.", "Repite esta palabra", "Mamá", "👩", .repeatAfterMe, .oral, true),
        e("Papá.", "Repite esta palabra", "Papá", "👨", .repeatAfterMe, .oral, false),
        e("¡Más!", "Repite esta palabra", "Más", "🔁", .repeatAfterMe, .oral, true),
        e("¡Terminado!", "Repite esta palabra", "Terminado", "🏁", .repeatAfterMe, .oral, false),
        e("¡Hace calor!", "Repite", "Hace calor", "🔥", .repeatAfterMe, .oral, true),
        e("¡Hace frío!", "Repite", "Hace frío", "❄️", .repeatAfterMe, .oral, false),
        e("¡Buenas noches!", "Repite", "Buenas noches", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func esLevel1() -> [CurriculumExercise] { [
        e("Repite: El gato come un ratón.", "Repite la frase", "El gato come un ratón", "🐱", .repeatAfterMe, .oral, true),
        e("Repite: La niña juega en el jardín.", "Repite la frase", "La niña juega en el jardín", "🌸", .repeatAfterMe, .oral, false),
        e("Repite: El sol brilla hoy.", "Repite la frase", "El sol brilla hoy", "☀️", .repeatAfterMe, .oral, true),
        e("¿Qué ves?", "Mira 🐶 y responde", "Veo un perro", "🐶", .answerQuestion, .oral, false),
        e("¿De qué color es?", "Mira 🍎 y responde", "Es rojo", "🍎", .answerQuestion, .oral, true),
        e("El sonido A — como en ÁRBOL.", "Repite el sonido y la palabra", "A — Árbol", "🌳", .repeatAfterMe, .reading, false),
        e("Lee: MA-MÁ.", "Lee las sílabas", "Mamá", "👩", .repeatAfterMe, .reading, true),
        e("Lee: CA-SA.", "Lee las sílabas", "Casa", "🏠", .repeatAfterMe, .reading, false),
        e("¿Cuánto es 2 más 3?", "Responde en voz alta", "5", "🔢", .answerQuestion, .math, true),
        e("¿Cuánto es 4 más 1?", "Responde en voz alta", "5", "🔢", .answerQuestion, .math, false),
        e("Cuenta hasta 10.", "Cuenta en voz alta", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, true),
        e("¿Cuánto es 5 menos 2?", "Responde", "3", "🔢", .answerQuestion, .math, false),
        e("¿Qué dices cuando llegas?", "Responde", "Hola", "🏫", .answerQuestion, .social, true),
        e("¿Qué dices cuando te vas?", "Responde", "Adiós", "👋", .answerQuestion, .social, false),
        e("Repite: Levanto la mano para hablar.", "Repite la regla", "Levanto la mano para hablar", "✋", .repeatAfterMe, .social, true),
        e("Repite: Comparto con mis amigos.", "Repite", "Comparto con mis amigos", "🤝", .repeatAfterMe, .social, false),
        e("¿7 es mayor que 3?", "Responde", "Sí 7 es mayor que 3", "🔢", .answerQuestion, .math, true),
        e("Lee: MA-RI-PO-SA.", "Lee las sílabas", "Mariposa", "🦋", .repeatAfterMe, .reading, false),
        e("Lee: E-LE-FAN-TE.", "Lee las sílabas", "Elefante", "🐘", .repeatAfterMe, .reading, true),
        e("Repite: Recojo mis cosas.", "Repite", "Recojo mis cosas", "🎒", .repeatAfterMe, .social, false),
        e("¿Cuánto es 3 más 3?", "Responde", "6", "🔢", .answerQuestion, .math, true),
        e("Deletrea tu nombre.", "Di cada letra", "Mi nombre es...", "🔤", .answerQuestion, .writing, false),
        e("Repite: Leo un libro cada día.", "Repite", "Leo un libro cada día", "📖", .repeatAfterMe, .reading, true),
        e("El sonido O — como en OSO.", "Repite el sonido y la palabra", "O — Oso", "🐻", .repeatAfterMe, .reading, false),
        e("¿Cuánto es 4 más 4?", "Responde", "8", "🔢", .answerQuestion, .math, true),
    ] }

    private static func esLevel2() -> [CurriculumExercise] { [
        e("Repite: El perro corre tras la pelota roja.", "Repite la frase", "El perro corre tras la pelota roja", "🐕", .repeatAfterMe, .oral, true),
        e("¿Cuál es el sujeto de: Los pájaros cantan?", "Responde", "Los pájaros", "🐦", .answerQuestion, .reading, false),
        e("Conjuga IR en presente: yo...", "Completa", "Yo voy", "📝", .answerQuestion, .writing, true),
        e("Conjuga SER en presente: él...", "Completa", "Él es", "📝", .answerQuestion, .writing, false),
        e("¿Cuál es el plural de PEZ?", "Responde", "Peces", "🐟", .answerQuestion, .writing, true),
        e("Da un sinónimo de CONTENTO.", "Responde", "Feliz", "😊", .answerQuestion, .writing, false),
        e("Da un antónimo de GRANDE.", "Responde", "Pequeño", "📏", .answerQuestion, .writing, true),
        e("¿Cuánto es 7 por 8?", "Responde", "56", "🔢", .answerQuestion, .math, false),
        e("¿Cuánto es 6 por 9?", "Responde", "54", "🔢", .answerQuestion, .math, true),
        e("¿Cuánto es 45 dividido entre 9?", "Responde", "5", "🔢", .answerQuestion, .math, false),
        e("¿La mitad de 80 es?", "Responde", "40", "🔢", .answerQuestion, .math, true),
        e("¿Cuál es la capital de España?", "Responde", "Madrid", "🏛️", .answerQuestion, .science, false),
        e("Nombra tres planetas.", "Responde", "Mercurio Venus Marte", "🪐", .answerQuestion, .science, true),
        e("¿Qué necesitan las plantas para crecer?", "Responde", "Agua luz y tierra", "🌱", .answerQuestion, .science, false),
        e("¿Cuáles son los tres estados del agua?", "Responde", "Líquido sólido gaseoso", "💧", .answerQuestion, .science, true),
        e("Repite: Las flores florecen en primavera.", "Repite", "Las flores florecen en primavera", "🌸", .repeatAfterMe, .oral, false),
        e("Repite: Vivimos en el planeta Tierra.", "Repite", "Vivimos en el planeta Tierra", "🌍", .repeatAfterMe, .science, true),
        e("¿Cuánto es 234 más 156?", "Calcula y responde", "390", "🔢", .answerQuestion, .math, false),
        e("Repite: Comemos frutas frescas cada mañana.", "Repite", "Comemos frutas frescas cada mañana", "🍎", .repeatAfterMe, .oral, true),
        e("¿Cuál es el perímetro de un cuadrado de lado 5?", "Responde", "20", "📐", .answerQuestion, .math, false),
        e("Convierte 2 km en metros.", "Responde", "2000 metros", "📏", .answerQuestion, .math, true),
        e("Repite: La fotosíntesis permite que las plantas se nutran.", "Repite", "La fotosíntesis permite que las plantas se nutran", "🌿", .repeatAfterMe, .science, false),
        e("¿Cuánto es 3 por 7?", "Responde", "21", "🔢", .answerQuestion, .math, true),
        e("Conjuga TENER en presente: nosotros...", "Completa", "Nosotros tenemos", "📝", .answerQuestion, .writing, false),
        e("Repite: Siempre doy lo mejor de mí.", "Repite", "Siempre doy lo mejor de mí", "🌟", .repeatAfterMe, .social, true),
    ] }

    private static func esLevel3() -> [CurriculumExercise] { [
        e("Repite: La libertad de expresión es un derecho fundamental.", "Repite", "La libertad de expresión es un derecho fundamental", "📜", .repeatAfterMe, .oral, true),
        e("¿Qué es una metáfora? Da un ejemplo.", "Responde", "Una comparación sin como. Ej: Él es un león", "📖", .answerQuestion, .reading, false),
        e("Resuelve: 2x más 6 igual a 14.", "Responde", "x igual a 4", "🔢", .answerQuestion, .math, true),
        e("Enuncia el teorema de Pitágoras.", "Responde", "En un triángulo rectángulo a² más b² igual c²", "📐", .answerQuestion, .math, false),
        e("Repite: La célula es la unidad básica de los seres vivos.", "Repite", "La célula es la unidad básica de los seres vivos", "🔬", .repeatAfterMe, .science, true),
        e("¿En qué año comenzó la Primera Guerra Mundial?", "Responde", "1914", "📚", .answerQuestion, .science, false),
        e("¿Cuál es la fórmula química del agua?", "Responde", "H dos O", "💧", .answerQuestion, .science, true),
        e("Nombra dos derechos del niño.", "Responde", "El derecho a la educación y a la salud", "📜", .answerQuestion, .social, false),
        e("Describe tu día ideal en una frase.", "Responde libremente", "Mi día ideal sería...", "🌟", .answerQuestion, .oral, true),
        e("Repite: Creo que toda persona merece ser respetada.", "Repite", "Creo que toda persona merece ser respetada", "🤝", .repeatAfterMe, .social, false),
    ] }

    // MARK: - PORTUGUESE
    private static func portuguese(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return ptLevel0()
        case .level1: return ptLevel1()
        case .level2: return ptLevel2()
        case .level3: return ptLevel3()
        }
    }

    private static func ptLevel0() -> [CurriculumExercise] { [
        e("Diga olá!", "Repita esta palavra", "Olá", "👋", .repeatAfterMe, .oral, true),
        e("Tchau!", "Repita esta palavra", "Tchau", "👋", .repeatAfterMe, .oral, false),
        e("Obrigado!", "Repita esta palavra", "Obrigado", "🙏", .repeatAfterMe, .oral, true),
        e("Por favor.", "Repita", "Por favor", "🙏", .repeatAfterMe, .oral, false),
        e("Sim.", "Repita esta palavra", "Sim", "✅", .repeatAfterMe, .oral, true),
        e("Não.", "Repita esta palavra", "Não", "❌", .repeatAfterMe, .oral, false),
        e("Qual é o seu nome?", "Responda à pergunta", "Meu nome é...", "🧒", .answerQuestion, .social, false),
        e("Estou com fome.", "Repita esta frase", "Estou com fome", "🍽️", .repeatAfterMe, .oral, true),
        e("Estou com sede.", "Repita esta frase", "Estou com sede", "💧", .repeatAfterMe, .oral, false),
        e("Estou com dor.", "Repita esta frase", "Estou com dor", "🤕", .repeatAfterMe, .oral, true),
        e("Quero brincar.", "Repita esta frase", "Quero brincar", "🎮", .repeatAfterMe, .oral, false),
        e("Quero comer.", "Repita esta frase", "Quero comer", "🍎", .repeatAfterMe, .oral, true),
        e("Me ajude por favor.", "Repita", "Me ajude por favor", "🤝", .repeatAfterMe, .social, false),
        e("Estou feliz.", "Repita", "Estou feliz", "😊", .repeatAfterMe, .social, true),
        e("Estou triste.", "Repita", "Estou triste", "😢", .repeatAfterMe, .social, false),
        e("É vermelho!", "Repita a cor", "Vermelho", "🔴", .repeatAfterMe, .oral, true),
        e("É azul!", "Repita a cor", "Azul", "🔵", .repeatAfterMe, .oral, false),
        e("É amarelo!", "Repita a cor", "Amarelo", "🟡", .repeatAfterMe, .oral, true),
        e("É verde!", "Repita a cor", "Verde", "🟢", .repeatAfterMe, .oral, false),
        e("Um, dois, três!", "Repita os números", "Um, dois, três", "🔢", .repeatAfterMe, .math, true),
        e("Quatro, cinco!", "Repita os números", "Quatro, cinco", "🔢", .repeatAfterMe, .math, false),
        e("O gato faz miau.", "Repita", "O gato faz miau", "🐱", .repeatAfterMe, .oral, true),
        e("O cachorro faz au au.", "Repita", "O cachorro faz au au", "🐶", .repeatAfterMe, .oral, false),
        e("Mamãe.", "Repita esta palavra", "Mamãe", "👩", .repeatAfterMe, .oral, true),
        e("Papai.", "Repita esta palavra", "Papai", "👨", .repeatAfterMe, .oral, false),
        e("Mais!", "Repita esta palavra", "Mais", "🔁", .repeatAfterMe, .oral, true),
        e("Acabou!", "Repita esta palavra", "Acabou", "🏁", .repeatAfterMe, .oral, false),
        e("Está quente!", "Repita", "Está quente", "🔥", .repeatAfterMe, .oral, true),
        e("Está frio!", "Repita", "Está frio", "❄️", .repeatAfterMe, .oral, false),
        e("Boa noite!", "Repita", "Boa noite", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func ptLevel1() -> [CurriculumExercise] { [
        e("Repita: O gato come um peixe.", "Repita a frase", "O gato come um peixe", "🐱", .repeatAfterMe, .oral, true),
        e("Repita: A menina brinca no jardim.", "Repita a frase", "A menina brinca no jardim", "🌸", .repeatAfterMe, .oral, false),
        e("O som A — como em ÁRVORE.", "Repita o som e a palavra", "A — Árvore", "🌳", .repeatAfterMe, .reading, true),
        e("Leia: MA-MÃE.", "Leia as sílabas", "Mamãe", "👩", .repeatAfterMe, .reading, false),
        e("Leia: CA-SA.", "Leia as sílabas", "Casa", "🏠", .repeatAfterMe, .reading, true),
        e("Quanto é 2 mais 3?", "Responda em voz alta", "5", "🔢", .answerQuestion, .math, false),
        e("Quanto é 4 mais 1?", "Responda em voz alta", "5", "🔢", .answerQuestion, .math, true),
        e("Conte até 10.", "Conte em voz alta", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, false),
        e("Quanto é 5 menos 2?", "Responda", "3", "🔢", .answerQuestion, .math, true),
        e("O que você diz quando chega?", "Responda", "Olá", "🏫", .answerQuestion, .social, false),
        e("O que você diz quando vai embora?", "Responda", "Tchau", "👋", .answerQuestion, .social, true),
        e("Repita: Levanto a mão para falar.", "Repita a regra", "Levanto a mão para falar", "✋", .repeatAfterMe, .social, false),
        e("Repita: Compartilho com meus amigos.", "Repita", "Compartilho com meus amigos", "🤝", .repeatAfterMe, .social, true),
        e("7 é maior que 3?", "Responda", "Sim 7 é maior que 3", "🔢", .answerQuestion, .math, false),
        e("Leia: BOR-BO-LE-TA.", "Leia as sílabas", "Borboleta", "🦋", .repeatAfterMe, .reading, true),
        e("Leia: E-LE-FAN-TE.", "Leia as sílabas", "Elefante", "🐘", .repeatAfterMe, .reading, false),
        e("Repita: Organizo minhas coisas.", "Repita", "Organizo minhas coisas", "🎒", .repeatAfterMe, .social, true),
        e("O que você vê?", "Olhe para 🐶 e responda", "Vejo um cachorro", "🐶", .answerQuestion, .oral, false),
        e("De que cor é?", "Olhe para 🍎 e responda", "É vermelho", "🍎", .answerQuestion, .oral, true),
        e("Quanto é 3 mais 3?", "Responda", "6", "🔢", .answerQuestion, .math, false),
    ] }

    private static func ptLevel2() -> [CurriculumExercise] { [
        e("Repita: O cachorro corre atrás da bola vermelha.", "Repita a frase", "O cachorro corre atrás da bola vermelha", "🐕", .repeatAfterMe, .oral, true),
        e("Qual é o sujeito de: Os pássaros cantam?", "Responda", "Os pássaros", "🐦", .answerQuestion, .reading, false),
        e("Conjugue IR no presente: eu...", "Complete", "Eu vou", "📝", .answerQuestion, .writing, true),
        e("Conjugue SER no presente: ele...", "Complete", "Ele é", "📝", .answerQuestion, .writing, false),
        e("Qual é o plural de CÃO?", "Responda", "Cães", "🐶", .answerQuestion, .writing, true),
        e("Dê um sinônimo de FELIZ.", "Responda", "Alegre", "😊", .answerQuestion, .writing, false),
        e("Quanto é 7 vezes 8?", "Responda", "56", "🔢", .answerQuestion, .math, true),
        e("Quanto é 6 vezes 9?", "Responda", "54", "🔢", .answerQuestion, .math, false),
        e("Qual é a capital do Brasil?", "Responda", "Brasília", "🏛️", .answerQuestion, .science, true),
        e("Nomeie três planetas.", "Responda", "Mercúrio Vênus Marte", "🪐", .answerQuestion, .science, false),
        e("O que as plantas precisam para crescer?", "Responda", "Água luz e terra", "🌱", .answerQuestion, .science, true),
        e("Quais são os três estados da água?", "Responda", "Líquido sólido gasoso", "💧", .answerQuestion, .science, false),
        e("Repita: As flores desabrocham na primavera.", "Repita", "As flores desabrocham na primavera", "🌸", .repeatAfterMe, .oral, true),
        e("Quanto é 45 dividido por 9?", "Responda", "5", "🔢", .answerQuestion, .math, false),
        e("Quanto é 234 mais 156?", "Calcule e responda", "390", "🔢", .answerQuestion, .math, true),
        e("Repita: Vivemos no planeta Terra.", "Repita", "Vivemos no planeta Terra", "🌍", .repeatAfterMe, .science, false),
        e("Qual é a metade de 80?", "Responda", "40", "🔢", .answerQuestion, .math, true),
        e("Repita: Comemos frutas frescas toda manhã.", "Repita", "Comemos frutas frescas toda manhã", "🍎", .repeatAfterMe, .oral, false),
        e("Conjugue TER no presente: nós...", "Complete", "Nós temos", "📝", .answerQuestion, .writing, true),
        e("Repita: Sempre faço o meu melhor.", "Repita", "Sempre faço o meu melhor", "🌟", .repeatAfterMe, .social, false),
    ] }

    private static func ptLevel3() -> [CurriculumExercise] { [
        e("Repita: A liberdade de expressão é um direito fundamental.", "Repita", "A liberdade de expressão é um direito fundamental", "📜", .repeatAfterMe, .oral, true),
        e("O que é uma metáfora? Dê um exemplo.", "Responda", "Uma comparação sem como. Ex: Ele é um leão", "📖", .answerQuestion, .reading, false),
        e("Resolva: 2x mais 6 igual a 14.", "Responda", "x igual a 4", "🔢", .answerQuestion, .math, true),
        e("Enuncie o teorema de Pitágoras.", "Responda", "Num triângulo retângulo a² mais b² igual c²", "📐", .answerQuestion, .math, false),
        e("Repita: A célula é a unidade básica da vida.", "Repita", "A célula é a unidade básica da vida", "🔬", .repeatAfterMe, .science, true),
        e("Em que ano começou a Primeira Guerra Mundial?", "Responda", "1914", "📚", .answerQuestion, .science, false),
        e("Qual é a fórmula química da água?", "Responda", "H dois O", "💧", .answerQuestion, .science, true),
        e("Cite dois direitos da criança.", "Responda", "O direito à educação e à saúde", "📜", .answerQuestion, .social, false),
        e("Descreva seu dia ideal em uma frase.", "Responda livremente", "Meu dia ideal seria...", "🌟", .answerQuestion, .oral, true),
        e("Repita: Acredito que toda pessoa merece ser respeitada.", "Repita", "Acredito que toda pessoa merece ser respeitada", "🤝", .repeatAfterMe, .social, false),
    ] }

    // MARK: - ITALIAN
    private static func italian(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return itLevel0()
        case .level1: return itLevel1()
        case .level2: return itLevel2()
        case .level3: return itLevel3()
        }
    }

    private static func itLevel0() -> [CurriculumExercise] { [
        e("Di' ciao!", "Ripeti questa parola", "Ciao", "👋", .repeatAfterMe, .oral, true),
        e("Arrivederci!", "Ripeti questa parola", "Arrivederci", "👋", .repeatAfterMe, .oral, false),
        e("Grazie!", "Ripeti questa parola", "Grazie", "🙏", .repeatAfterMe, .oral, true),
        e("Per favore.", "Ripeti", "Per favore", "🙏", .repeatAfterMe, .oral, false),
        e("Sì.", "Ripeti questa parola", "Sì", "✅", .repeatAfterMe, .oral, true),
        e("No.", "Ripeti questa parola", "No", "❌", .repeatAfterMe, .oral, false),
        e("Come ti chiami?", "Rispondi alla domanda", "Mi chiamo...", "🧒", .answerQuestion, .social, false),
        e("Ho fame.", "Ripeti questa frase", "Ho fame", "🍽️", .repeatAfterMe, .oral, true),
        e("Ho sete.", "Ripeti questa frase", "Ho sete", "💧", .repeatAfterMe, .oral, false),
        e("Mi fa male.", "Ripeti questa frase", "Mi fa male", "🤕", .repeatAfterMe, .oral, true),
        e("Voglio giocare.", "Ripeti questa frase", "Voglio giocare", "🎮", .repeatAfterMe, .oral, false),
        e("Voglio mangiare.", "Ripeti questa frase", "Voglio mangiare", "🍎", .repeatAfterMe, .oral, true),
        e("Aiutami per favore.", "Ripeti", "Aiutami per favore", "🤝", .repeatAfterMe, .social, false),
        e("Sono contento.", "Ripeti", "Sono contento", "😊", .repeatAfterMe, .social, true),
        e("Sono triste.", "Ripeti", "Sono triste", "😢", .repeatAfterMe, .social, false),
        e("È rosso!", "Ripeti il colore", "Rosso", "🔴", .repeatAfterMe, .oral, true),
        e("È blu!", "Ripeti il colore", "Blu", "🔵", .repeatAfterMe, .oral, false),
        e("È giallo!", "Ripeti il colore", "Giallo", "🟡", .repeatAfterMe, .oral, true),
        e("È verde!", "Ripeti il colore", "Verde", "🟢", .repeatAfterMe, .oral, false),
        e("Uno, due, tre!", "Ripeti i numeri", "Uno, due, tre", "🔢", .repeatAfterMe, .math, true),
        e("Quattro, cinque!", "Ripeti i numeri", "Quattro, cinque", "🔢", .repeatAfterMe, .math, false),
        e("Il gatto fa miao.", "Ripeti", "Il gatto fa miao", "🐱", .repeatAfterMe, .oral, true),
        e("Il cane fa bau.", "Ripeti", "Il cane fa bau", "🐶", .repeatAfterMe, .oral, false),
        e("Mamma.", "Ripeti questa parola", "Mamma", "👩", .repeatAfterMe, .oral, true),
        e("Papà.", "Ripeti questa parola", "Papà", "👨", .repeatAfterMe, .oral, false),
        e("Ancora!", "Ripeti questa parola", "Ancora", "🔁", .repeatAfterMe, .oral, true),
        e("Finito!", "Ripeti questa parola", "Finito", "🏁", .repeatAfterMe, .oral, false),
        e("È caldo!", "Ripeti", "È caldo", "🔥", .repeatAfterMe, .oral, true),
        e("È freddo!", "Ripeti", "È freddo", "❄️", .repeatAfterMe, .oral, false),
        e("Buona notte!", "Ripeti", "Buona notte", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func itLevel1() -> [CurriculumExercise] { [
        e("Ripeti: Il gatto mangia un topo.", "Ripeti la frase", "Il gatto mangia un topo", "🐱", .repeatAfterMe, .oral, true),
        e("Ripeti: La bambina gioca in giardino.", "Ripeti la frase", "La bambina gioca in giardino", "🌸", .repeatAfterMe, .oral, false),
        e("Il suono A — come in ALBERO.", "Ripeti il suono e la parola", "A — Albero", "🌳", .repeatAfterMe, .reading, true),
        e("Leggi: MA-M-MA.", "Leggi le sillabe", "Mamma", "👩", .repeatAfterMe, .reading, false),
        e("Quanto fa 2 più 3?", "Rispondi a voce alta", "5", "🔢", .answerQuestion, .math, true),
        e("Quanto fa 4 più 1?", "Rispondi a voce alta", "5", "🔢", .answerQuestion, .math, false),
        e("Conta fino a 10.", "Conta a voce alta", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, true),
        e("Quanto fa 5 meno 2?", "Rispondi", "3", "🔢", .answerQuestion, .math, false),
        e("Cosa dici quando arrivi?", "Rispondi", "Ciao", "🏫", .answerQuestion, .social, true),
        e("Cosa dici quando te ne vai?", "Rispondi", "Arrivederci", "👋", .answerQuestion, .social, false),
        e("Ripeti: Alzo la mano per parlare.", "Ripeti la regola", "Alzo la mano per parlare", "✋", .repeatAfterMe, .social, true),
        e("Ripeti: Condivido con i miei amici.", "Ripeti", "Condivido con i miei amici", "🤝", .repeatAfterMe, .social, false),
        e("7 è maggiore di 3?", "Rispondi", "Sì 7 è maggiore di 3", "🔢", .answerQuestion, .math, true),
        e("Leggi: FAR-FAL-LA.", "Leggi le sillabe", "Farfalla", "🦋", .repeatAfterMe, .reading, false),
        e("Leggi: E-LE-FAN-TE.", "Leggi le sillabe", "Elefante", "🐘", .repeatAfterMe, .reading, true),
        e("Ripeti: Metto in ordine le mie cose.", "Ripeti", "Metto in ordine le mie cose", "🎒", .repeatAfterMe, .social, false),
        e("Quanto fa 3 più 3?", "Rispondi", "6", "🔢", .answerQuestion, .math, true),
        e("Cosa vedi?", "Guarda 🐶 e rispondi", "Vedo un cane", "🐶", .answerQuestion, .oral, false),
        e("Di che colore è?", "Guarda 🍎 e rispondi", "È rosso", "🍎", .answerQuestion, .oral, true),
        e("Ripeti: Leggo un libro ogni giorno.", "Ripeti", "Leggo un libro ogni giorno", "📖", .repeatAfterMe, .reading, false),
    ] }

    private static func itLevel2() -> [CurriculumExercise] { [
        e("Ripeti: Il cane corre dietro alla palla rossa.", "Ripeti la frase", "Il cane corre dietro alla palla rossa", "🐕", .repeatAfterMe, .oral, true),
        e("Qual è il soggetto di: Gli uccelli cantano?", "Rispondi", "Gli uccelli", "🐦", .answerQuestion, .reading, false),
        e("Coniuga ANDARE al presente: io...", "Completa", "Io vado", "📝", .answerQuestion, .writing, true),
        e("Coniuga ESSERE al presente: lui...", "Completa", "Lui è", "📝", .answerQuestion, .writing, false),
        e("Qual è il plurale di UOMO?", "Rispondi", "Uomini", "👨", .answerQuestion, .writing, true),
        e("Dai un sinonimo di FELICE.", "Rispondi", "Contento", "😊", .answerQuestion, .writing, false),
        e("Quanto fa 7 per 8?", "Rispondi", "56", "🔢", .answerQuestion, .math, true),
        e("Qual è la capitale dell'Italia?", "Rispondi", "Roma", "🏛️", .answerQuestion, .science, false),
        e("Nomina tre pianeti.", "Rispondi", "Mercurio Venere Marte", "🪐", .answerQuestion, .science, true),
        e("Di cosa hanno bisogno le piante per crescere?", "Rispondi", "Acqua luce e terra", "🌱", .answerQuestion, .science, false),
        e("Quali sono i tre stati dell'acqua?", "Rispondi", "Liquido solido gassoso", "💧", .answerQuestion, .science, true),
        e("Ripeti: I fiori sbocciano in primavera.", "Ripeti", "I fiori sbocciano in primavera", "🌸", .repeatAfterMe, .oral, false),
        e("Quanto fa 45 diviso 9?", "Rispondi", "5", "🔢", .answerQuestion, .math, true),
        e("Quanto fa la metà di 80?", "Rispondi", "40", "🔢", .answerQuestion, .math, false),
        e("Ripeti: Viviamo sul pianeta Terra.", "Ripeti", "Viviamo sul pianeta Terra", "🌍", .repeatAfterMe, .science, true),
        e("Quanto fa 234 più 156?", "Calcola e rispondi", "390", "🔢", .answerQuestion, .math, false),
        e("Coniuga AVERE al presente: noi...", "Completa", "Noi abbiamo", "📝", .answerQuestion, .writing, true),
        e("Ripeti: Mangiamo frutta fresca ogni mattina.", "Ripeti", "Mangiamo frutta fresca ogni mattina", "🍎", .repeatAfterMe, .oral, false),
        e("Ripeti: Do sempre il meglio di me.", "Ripeti", "Do sempre il meglio di me", "🌟", .repeatAfterMe, .social, true),
        e("Quanto fa 6 per 9?", "Rispondi", "54", "🔢", .answerQuestion, .math, false),
    ] }

    private static func itLevel3() -> [CurriculumExercise] { [
        e("Ripeti: La libertà di espressione è un diritto fondamentale.", "Ripeti", "La libertà di espressione è un diritto fondamentale", "📜", .repeatAfterMe, .oral, true),
        e("Cos'è una metafora? Dai un esempio.", "Rispondi", "Un paragone senza come. Es: È un leone", "📖", .answerQuestion, .reading, false),
        e("Risolvi: 2x più 6 uguale 14.", "Rispondi", "x uguale 4", "🔢", .answerQuestion, .math, true),
        e("Enunciare il teorema di Pitagora.", "Rispondi", "In un triangolo rettangolo a² più b² uguale c²", "📐", .answerQuestion, .math, false),
        e("Ripeti: La cellula è l'unità di base della vita.", "Ripeti", "La cellula è l'unità di base della vita", "🔬", .repeatAfterMe, .science, true),
        e("In che anno iniziò la Prima Guerra Mondiale?", "Rispondi", "1914", "📚", .answerQuestion, .science, false),
        e("Qual è la formula chimica dell'acqua?", "Rispondi", "H due O", "💧", .answerQuestion, .science, true),
        e("Cita due diritti del bambino.", "Rispondi", "Il diritto all'istruzione e alla salute", "📜", .answerQuestion, .social, false),
        e("Descrivi la tua giornata ideale in una frase.", "Rispondi liberamente", "La mia giornata ideale sarebbe...", "🌟", .answerQuestion, .oral, true),
        e("Ripeti: Credo che ogni persona meriti di essere rispettata.", "Ripeti", "Credo che ogni persona meriti di essere rispettata", "🤝", .repeatAfterMe, .social, false),
    ] }

    // MARK: - GERMAN
    private static func german(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return deLevel0()
        case .level1: return deLevel1()
        case .level2: return deLevel2()
        case .level3: return deLevel3()
        }
    }

    private static func deLevel0() -> [CurriculumExercise] { [
        e("Sag hallo!", "Wiederhole dieses Wort", "Hallo", "👋", .repeatAfterMe, .oral, true),
        e("Auf Wiedersehen!", "Wiederhole dieses Wort", "Auf Wiedersehen", "👋", .repeatAfterMe, .oral, false),
        e("Danke!", "Wiederhole dieses Wort", "Danke", "🙏", .repeatAfterMe, .oral, true),
        e("Bitte.", "Wiederhole", "Bitte", "🙏", .repeatAfterMe, .oral, false),
        e("Ja.", "Wiederhole dieses Wort", "Ja", "✅", .repeatAfterMe, .oral, true),
        e("Nein.", "Wiederhole dieses Wort", "Nein", "❌", .repeatAfterMe, .oral, false),
        e("Wie heißt du?", "Beantworte die Frage", "Ich heiße...", "🧒", .answerQuestion, .social, false),
        e("Ich habe Hunger.", "Wiederhole diesen Satz", "Ich habe Hunger", "🍽️", .repeatAfterMe, .oral, true),
        e("Ich habe Durst.", "Wiederhole diesen Satz", "Ich habe Durst", "💧", .repeatAfterMe, .oral, false),
        e("Ich habe Schmerzen.", "Wiederhole diesen Satz", "Ich habe Schmerzen", "🤕", .repeatAfterMe, .oral, true),
        e("Ich möchte spielen.", "Wiederhole diesen Satz", "Ich möchte spielen", "🎮", .repeatAfterMe, .oral, false),
        e("Ich möchte essen.", "Wiederhole diesen Satz", "Ich möchte essen", "🍎", .repeatAfterMe, .oral, true),
        e("Hilf mir bitte.", "Wiederhole", "Hilf mir bitte", "🤝", .repeatAfterMe, .social, false),
        e("Ich bin glücklich.", "Wiederhole", "Ich bin glücklich", "😊", .repeatAfterMe, .social, true),
        e("Ich bin traurig.", "Wiederhole", "Ich bin traurig", "😢", .repeatAfterMe, .social, false),
        e("Es ist rot!", "Wiederhole die Farbe", "Rot", "🔴", .repeatAfterMe, .oral, true),
        e("Es ist blau!", "Wiederhole die Farbe", "Blau", "🔵", .repeatAfterMe, .oral, false),
        e("Es ist gelb!", "Wiederhole die Farbe", "Gelb", "🟡", .repeatAfterMe, .oral, true),
        e("Es ist grün!", "Wiederhole die Farbe", "Grün", "🟢", .repeatAfterMe, .oral, false),
        e("Eins, zwei, drei!", "Wiederhole die Zahlen", "Eins, zwei, drei", "🔢", .repeatAfterMe, .math, true),
        e("Vier, fünf!", "Wiederhole die Zahlen", "Vier, fünf", "🔢", .repeatAfterMe, .math, false),
        e("Die Katze sagt miau.", "Wiederhole", "Die Katze sagt miau", "🐱", .repeatAfterMe, .oral, true),
        e("Der Hund sagt wau.", "Wiederhole", "Der Hund sagt wau", "🐶", .repeatAfterMe, .oral, false),
        e("Mama.", "Wiederhole dieses Wort", "Mama", "👩", .repeatAfterMe, .oral, true),
        e("Papa.", "Wiederhole dieses Wort", "Papa", "👨", .repeatAfterMe, .oral, false),
        e("Mehr!", "Wiederhole dieses Wort", "Mehr", "🔁", .repeatAfterMe, .oral, true),
        e("Fertig!", "Wiederhole dieses Wort", "Fertig", "🏁", .repeatAfterMe, .oral, false),
        e("Es ist heiß!", "Wiederhole", "Es ist heiß", "🔥", .repeatAfterMe, .oral, true),
        e("Es ist kalt!", "Wiederhole", "Es ist kalt", "❄️", .repeatAfterMe, .oral, false),
        e("Gute Nacht!", "Wiederhole", "Gute Nacht", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func deLevel1() -> [CurriculumExercise] { [
        e("Wiederhole: Die Katze frisst eine Maus.", "Wiederhole den Satz", "Die Katze frisst eine Maus", "🐱", .repeatAfterMe, .oral, true),
        e("Wiederhole: Das Mädchen spielt im Garten.", "Wiederhole den Satz", "Das Mädchen spielt im Garten", "🌸", .repeatAfterMe, .oral, false),
        e("Wiederhole: Die Sonne scheint heute.", "Wiederhole den Satz", "Die Sonne scheint heute", "☀️", .repeatAfterMe, .oral, true),
        e("Was siehst du?", "Schau auf 🐶 und antworte", "Ich sehe einen Hund", "🐶", .answerQuestion, .oral, false),
        e("Welche Farbe hat das?", "Schau auf 🍎 und antworte", "Es ist rot", "🍎", .answerQuestion, .oral, true),
        e("Der Laut A — wie in APFEL.", "Wiederhole den Laut und das Wort", "A — Apfel", "🍎", .repeatAfterMe, .reading, false),
        e("Lies: MA-MA.", "Lies die Silben", "Mama", "👩", .repeatAfterMe, .reading, true),
        e("Lies: HAUS.", "Lies das Wort", "Haus", "🏠", .repeatAfterMe, .reading, false),
        e("Wie viel ist 2 plus 3?", "Antworte laut", "5", "🔢", .answerQuestion, .math, true),
        e("Wie viel ist 4 plus 1?", "Antworte laut", "5", "🔢", .answerQuestion, .math, false),
        e("Zähle bis 10.", "Zähle laut", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, true),
        e("Wie viel ist 5 minus 2?", "Antworte", "3", "🔢", .answerQuestion, .math, false),
        e("Was sagst du, wenn du ankommst?", "Antworte", "Hallo", "🏫", .answerQuestion, .social, true),
        e("Was sagst du, wenn du gehst?", "Antworte", "Auf Wiedersehen", "👋", .answerQuestion, .social, false),
        e("Wiederhole: Ich melde mich, wenn ich sprechen möchte.", "Wiederhole die Regel", "Ich melde mich wenn ich sprechen möchte", "✋", .repeatAfterMe, .social, true),
        e("Ist 7 größer als 3?", "Antworte", "Ja 7 ist größer als 3", "🔢", .answerQuestion, .math, false),
        e("Lies: SCHMET-TER-LING.", "Lies die Silben", "Schmetterling", "🦋", .repeatAfterMe, .reading, true),
        e("Lies: E-LE-FANT.", "Lies die Silben", "Elefant", "🐘", .repeatAfterMe, .reading, false),
        e("Wie viel ist 3 plus 3?", "Antworte", "6", "🔢", .answerQuestion, .math, true),
        e("Wiederhole: Ich teile mit meinen Freunden.", "Wiederhole", "Ich teile mit meinen Freunden", "🤝", .repeatAfterMe, .social, false),
    ] }

    private static func deLevel2() -> [CurriculumExercise] { [
        e("Wiederhole: Der Hund läuft dem roten Ball nach.", "Wiederhole den Satz", "Der Hund läuft dem roten Ball nach", "🐕", .repeatAfterMe, .oral, true),
        e("Was ist das Subjekt von: Die Vögel singen?", "Antworte", "Die Vögel", "🐦", .answerQuestion, .reading, false),
        e("Konjugiere GEHEN im Präsens: ich...", "Ergänze", "Ich gehe", "📝", .answerQuestion, .writing, true),
        e("Konjugiere SEIN im Präsens: er...", "Ergänze", "Er ist", "📝", .answerQuestion, .writing, false),
        e("Was ist der Plural von KIND?", "Antworte", "Kinder", "👶", .answerQuestion, .writing, true),
        e("Gib ein Synonym für GLÜCKLICH.", "Antworte", "Fröhlich", "😊", .answerQuestion, .writing, false),
        e("Wie viel ist 7 mal 8?", "Antworte", "56", "🔢", .answerQuestion, .math, true),
        e("Wie viel ist 6 mal 9?", "Antworte", "54", "🔢", .answerQuestion, .math, false),
        e("Was ist die Hauptstadt von Deutschland?", "Antworte", "Berlin", "🏛️", .answerQuestion, .science, true),
        e("Nenne drei Planeten.", "Antworte", "Merkur Venus Mars", "🪐", .answerQuestion, .science, false),
        e("Was brauchen Pflanzen zum Wachsen?", "Antworte", "Wasser Licht und Erde", "🌱", .answerQuestion, .science, true),
        e("Wie viel ist 45 geteilt durch 9?", "Antworte", "5", "🔢", .answerQuestion, .math, false),
        e("Wie viel ist die Hälfte von 80?", "Antworte", "40", "🔢", .answerQuestion, .math, true),
        e("Wiederhole: Blumen blühen im Frühling.", "Wiederhole", "Blumen blühen im Frühling", "🌸", .repeatAfterMe, .oral, false),
        e("Wiederhole: Wir leben auf dem Planeten Erde.", "Wiederhole", "Wir leben auf dem Planeten Erde", "🌍", .repeatAfterMe, .science, true),
        e("Wie viel ist 234 plus 156?", "Berechne und antworte", "390", "🔢", .answerQuestion, .math, false),
        e("Was sind die drei Zustände des Wassers?", "Antworte", "Flüssig fest gasförmig", "💧", .answerQuestion, .science, true),
        e("Konjugiere HABEN im Präsens: wir...", "Ergänze", "Wir haben", "📝", .answerQuestion, .writing, false),
        e("Wiederhole: Wir essen jeden Morgen frisches Obst.", "Wiederhole", "Wir essen jeden Morgen frisches Obst", "🍎", .repeatAfterMe, .oral, true),
        e("Wiederhole: Ich gebe immer mein Bestes.", "Wiederhole", "Ich gebe immer mein Bestes", "🌟", .repeatAfterMe, .social, false),
    ] }

    private static func deLevel3() -> [CurriculumExercise] { [
        e("Wiederhole: Meinungsfreiheit ist ein Grundrecht.", "Wiederhole", "Meinungsfreiheit ist ein Grundrecht", "📜", .repeatAfterMe, .oral, true),
        e("Was ist eine Metapher? Gib ein Beispiel.", "Antworte", "Ein Vergleich ohne wie. Bsp: Er ist ein Löwe", "📖", .answerQuestion, .reading, false),
        e("Löse: 2x plus 6 gleich 14.", "Antworte", "x gleich 4", "🔢", .answerQuestion, .math, true),
        e("Nenne den Satz des Pythagoras.", "Antworte", "Im rechtwinkligen Dreieck gilt a² plus b² gleich c²", "📐", .answerQuestion, .math, false),
        e("Wiederhole: Die Zelle ist die Grundeinheit des Lebens.", "Wiederhole", "Die Zelle ist die Grundeinheit des Lebens", "🔬", .repeatAfterMe, .science, true),
        e("In welchem Jahr begann der Erste Weltkrieg?", "Antworte", "1914", "📚", .answerQuestion, .science, false),
        e("Was ist die chemische Formel von Wasser?", "Antworte", "H zwei O", "💧", .answerQuestion, .science, true),
        e("Nenne zwei Kinderrechte.", "Antworte", "Das Recht auf Bildung und Gesundheit", "📜", .answerQuestion, .social, false),
        e("Beschreibe deinen idealen Tag in einem Satz.", "Antworte frei", "Mein idealer Tag wäre...", "🌟", .answerQuestion, .oral, true),
        e("Wiederhole: Ich glaube, dass jeder Mensch Respekt verdient.", "Wiederhole", "Ich glaube dass jeder Mensch Respekt verdient", "🤝", .repeatAfterMe, .social, false),
    ] }

    // MARK: - ARABIC
    private static func arabic(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return arLevel0()
        case .level1: return arLevel1()
        case .level2: return arLevel2()
        case .level3: return arLevel3()
        }
    }

    private static func arLevel0() -> [CurriculumExercise] { [
        e("قل مرحباً!", "أعد هذه الكلمة", "مرحباً", "👋", .repeatAfterMe, .oral, true),
        e("مع السلامة!", "أعد هذه الكلمة", "مع السلامة", "👋", .repeatAfterMe, .oral, false),
        e("شكراً!", "أعد هذه الكلمة", "شكراً", "🙏", .repeatAfterMe, .oral, true),
        e("من فضلك.", "أعد", "من فضلك", "🙏", .repeatAfterMe, .oral, false),
        e("نعم.", "أعد هذه الكلمة", "نعم", "✅", .repeatAfterMe, .oral, true),
        e("لا.", "أعد هذه الكلمة", "لا", "❌", .repeatAfterMe, .oral, false),
        e("ما اسمك؟", "أجب على السؤال", "اسمي...", "🧒", .answerQuestion, .social, false),
        e("أنا جائع.", "أعد هذه الجملة", "أنا جائع", "🍽️", .repeatAfterMe, .oral, true),
        e("أنا عطشان.", "أعد هذه الجملة", "أنا عطشان", "💧", .repeatAfterMe, .oral, false),
        e("أنا مريض.", "أعد هذه الجملة", "أنا مريض", "🤕", .repeatAfterMe, .oral, true),
        e("أريد اللعب.", "أعد هذه الجملة", "أريد اللعب", "🎮", .repeatAfterMe, .oral, false),
        e("أريد الأكل.", "أعد هذه الجملة", "أريد الأكل", "🍎", .repeatAfterMe, .oral, true),
        e("ساعدني من فضلك.", "أعد", "ساعدني من فضلك", "🤝", .repeatAfterMe, .social, false),
        e("أنا سعيد.", "أعد", "أنا سعيد", "😊", .repeatAfterMe, .social, true),
        e("أنا حزين.", "أعد", "أنا حزين", "😢", .repeatAfterMe, .social, false),
        e("إنه أحمر!", "أعد اللون", "أحمر", "🔴", .repeatAfterMe, .oral, true),
        e("إنه أزرق!", "أعد اللون", "أزرق", "🔵", .repeatAfterMe, .oral, false),
        e("إنه أصفر!", "أعد اللون", "أصفر", "🟡", .repeatAfterMe, .oral, true),
        e("إنه أخضر!", "أعد اللون", "أخضر", "🟢", .repeatAfterMe, .oral, false),
        e("واحد، اثنان، ثلاثة!", "أعد الأرقام", "واحد اثنان ثلاثة", "🔢", .repeatAfterMe, .math, true),
        e("أربعة، خمسة!", "أعد الأرقام", "أربعة خمسة", "🔢", .repeatAfterMe, .math, false),
        e("القطة تقول مياو.", "أعد", "القطة تقول مياو", "🐱", .repeatAfterMe, .oral, true),
        e("الكلب يقول هاو.", "أعد", "الكلب يقول هاو", "🐶", .repeatAfterMe, .oral, false),
        e("أمي.", "أعد هذه الكلمة", "أمي", "👩", .repeatAfterMe, .oral, true),
        e("أبي.", "أعد هذه الكلمة", "أبي", "👨", .repeatAfterMe, .oral, false),
        e("أكثر!", "أعد هذه الكلمة", "أكثر", "🔁", .repeatAfterMe, .oral, true),
        e("انتهى!", "أعد هذه الكلمة", "انتهى", "🏁", .repeatAfterMe, .oral, false),
        e("الجو حار!", "أعد", "الجو حار", "🔥", .repeatAfterMe, .oral, true),
        e("الجو بارد!", "أعد", "الجو بارد", "❄️", .repeatAfterMe, .oral, false),
        e("تصبح على خير!", "أعد", "تصبح على خير", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func arLevel1() -> [CurriculumExercise] { [
        e("أعد: القطة تأكل سمكة.", "أعد الجملة", "القطة تأكل سمكة", "🐱", .repeatAfterMe, .oral, true),
        e("أعد: البنت تلعب في الحديقة.", "أعد الجملة", "البنت تلعب في الحديقة", "🌸", .repeatAfterMe, .oral, false),
        e("حرف الألف — كما في أسد.", "أعد الحرف والكلمة", "أ — أسد", "🦁", .repeatAfterMe, .reading, true),
        e("اقرأ: بَيْت.", "اقرأ الكلمة", "بيت", "🏠", .repeatAfterMe, .reading, false),
        e("كم يساوي 2 زائد 3؟", "أجب بصوت عالٍ", "5", "🔢", .answerQuestion, .math, true),
        e("كم يساوي 4 زائد 1؟", "أجب بصوت عالٍ", "5", "🔢", .answerQuestion, .math, false),
        e("عد حتى 10.", "عد بصوت عالٍ", "واحد اثنان ثلاثة أربعة خمسة ستة سبعة ثمانية تسعة عشرة", "🔢", .repeatAfterMe, .math, true),
        e("كم يساوي 5 ناقص 2؟", "أجب", "3", "🔢", .answerQuestion, .math, false),
        e("ماذا تقول عند الوصول؟", "أجب", "مرحباً", "🏫", .answerQuestion, .social, true),
        e("ماذا تقول عند الرحيل؟", "أجب", "مع السلامة", "👋", .answerQuestion, .social, false),
        e("أعد: أرفع يدي للتحدث.", "أعد القاعدة", "أرفع يدي للتحدث", "✋", .repeatAfterMe, .social, true),
        e("أعد: أشارك أصدقائي.", "أعد", "أشارك أصدقائي", "🤝", .repeatAfterMe, .social, false),
        e("هل 7 أكبر من 3؟", "أجب", "نعم 7 أكبر من 3", "🔢", .answerQuestion, .math, true),
        e("اقرأ: فَرَاشَة.", "اقرأ الكلمة", "فراشة", "🦋", .repeatAfterMe, .reading, false),
        e("اقرأ: فِيل.", "اقرأ الكلمة", "فيل", "🐘", .repeatAfterMe, .reading, true),
        e("أعد: أرتب أغراضي.", "أعد", "أرتب أغراضي", "🎒", .repeatAfterMe, .social, false),
        e("ماذا ترى؟", "انظر إلى 🐶 وأجب", "أرى كلباً", "🐶", .answerQuestion, .oral, true),
        e("ما لون هذا؟", "انظر إلى 🍎 وأجب", "إنه أحمر", "🍎", .answerQuestion, .oral, false),
        e("كم يساوي 3 زائد 3؟", "أجب", "6", "🔢", .answerQuestion, .math, true),
        e("أعد: أقرأ كتاباً كل يوم.", "أعد", "أقرأ كتاباً كل يوم", "📖", .repeatAfterMe, .reading, false),
    ] }

    private static func arLevel2() -> [CurriculumExercise] { [
        e("أعد: الكلب يركض خلف الكرة الحمراء.", "أعد الجملة", "الكلب يركض خلف الكرة الحمراء", "🐕", .repeatAfterMe, .oral, true),
        e("ما هو الفاعل في: الطيور تغني؟", "أجب", "الطيور", "🐦", .answerQuestion, .reading, false),
        e("صرّف فعل ذَهَبَ في المضارع: أنا...", "أكمل", "أنا أذهب", "📝", .answerQuestion, .writing, true),
        e("صرّف فعل كَانَ في الماضي: هو...", "أكمل", "هو كان", "📝", .answerQuestion, .writing, false),
        e("ما جمع كلمة كِتَاب؟", "أجب", "كتب", "📚", .answerQuestion, .writing, true),
        e("أعطِ مرادفاً لكلمة سَعِيد.", "أجب", "فرحان", "😊", .answerQuestion, .writing, false),
        e("كم يساوي 7 في 8؟", "أجب", "56", "🔢", .answerQuestion, .math, true),
        e("كم يساوي 6 في 9؟", "أجب", "54", "🔢", .answerQuestion, .math, false),
        e("ما عاصمة المملكة العربية السعودية؟", "أجب", "الرياض", "🏛️", .answerQuestion, .science, true),
        e("سمِّ ثلاثة كواكب.", "أجب", "عطارد الزهرة المريخ", "🪐", .answerQuestion, .science, false),
        e("ماذا تحتاج النباتات للنمو؟", "أجب", "ماء وضوء وتربة", "🌱", .answerQuestion, .science, true),
        e("ما الحالات الثلاث للماء؟", "أجب", "سائل صلب غازي", "💧", .answerQuestion, .science, false),
        e("أعد: الزهور تتفتح في الربيع.", "أعد", "الزهور تتفتح في الربيع", "🌸", .repeatAfterMe, .oral, true),
        e("كم يساوي 45 مقسوماً على 9؟", "أجب", "5", "🔢", .answerQuestion, .math, false),
        e("ما نصف 80؟", "أجب", "40", "🔢", .answerQuestion, .math, true),
        e("أعد: نعيش على كوكب الأرض.", "أعد", "نعيش على كوكب الأرض", "🌍", .repeatAfterMe, .science, false),
        e("كم يساوي 234 زائد 156؟", "احسب وأجب", "390", "🔢", .answerQuestion, .math, true),
        e("أعد: نأكل فاكهة طازجة كل صباح.", "أعد", "نأكل فاكهة طازجة كل صباح", "🍎", .repeatAfterMe, .oral, false),
        e("صرّف فعل أَخَذَ في المضارع: نحن...", "أكمل", "نحن نأخذ", "📝", .answerQuestion, .writing, true),
        e("أعد: أبذل دائماً قصارى جهدي.", "أعد", "أبذل دائماً قصارى جهدي", "🌟", .repeatAfterMe, .social, false),
    ] }

    private static func arLevel3() -> [CurriculumExercise] { [
        e("أعد: حرية التعبير حق أساسي.", "أعد", "حرية التعبير حق أساسي", "📜", .repeatAfterMe, .oral, true),
        e("ما هو الاستعارة؟ أعطِ مثالاً.", "أجب", "تعبير مجازي بلا أداة تشبيه. مثال: هو أسد", "📖", .answerQuestion, .reading, false),
        e("حل المعادلة: 2x زائد 6 يساوي 14.", "أجب", "x يساوي 4", "🔢", .answerQuestion, .math, true),
        e("اذكر نظرية فيثاغورس.", "أجب", "في المثلث القائم مجموع مربعي الضلعين يساوي مربع الوتر", "📐", .answerQuestion, .math, false),
        e("أعد: الخلية هي الوحدة الأساسية للحياة.", "أعد", "الخلية هي الوحدة الأساسية للحياة", "🔬", .repeatAfterMe, .science, true),
        e("في أي عام بدأت الحرب العالمية الأولى؟", "أجب", "1914", "📚", .answerQuestion, .science, false),
        e("ما الصيغة الكيميائية للماء؟", "أجب", "H₂O", "💧", .answerQuestion, .science, true),
        e("اذكر حقين من حقوق الطفل.", "أجب", "الحق في التعليم والصحة", "📜", .answerQuestion, .social, false),
        e("صف يومك المثالي في جملة واحدة.", "أجب بحرية", "يومي المثالي سيكون...", "🌟", .answerQuestion, .oral, true),
        e("أعد: أعتقد أن كل شخص يستحق الاحترام.", "أعد", "أعتقد أن كل شخص يستحق الاحترام", "🤝", .repeatAfterMe, .social, false),
    ] }

    // MARK: - DUTCH
    private static func dutch(_ level: SchoolLevel, _ module: ModuleType) -> [CurriculumExercise] {
        switch level {
        case .level0: return nlLevel0()
        case .level1: return nlLevel1()
        case .level2: return nlLevel2()
        case .level3: return nlLevel3()
        }
    }

    private static func nlLevel0() -> [CurriculumExercise] { [
        e("Zeg hallo!", "Herhaal dit woord", "Hallo", "👋", .repeatAfterMe, .oral, true),
        e("Tot ziens!", "Herhaal dit woord", "Tot ziens", "👋", .repeatAfterMe, .oral, false),
        e("Dank je wel!", "Herhaal dit woord", "Dank je wel", "🙏", .repeatAfterMe, .oral, true),
        e("Alsjeblieft.", "Herhaal", "Alsjeblieft", "🙏", .repeatAfterMe, .oral, false),
        e("Ja.", "Herhaal dit woord", "Ja", "✅", .repeatAfterMe, .oral, true),
        e("Nee.", "Herhaal dit woord", "Nee", "❌", .repeatAfterMe, .oral, false),
        e("Hoe heet jij?", "Beantwoord de vraag", "Ik heet...", "🧒", .answerQuestion, .social, false),
        e("Ik heb honger.", "Herhaal deze zin", "Ik heb honger", "🍽️", .repeatAfterMe, .oral, true),
        e("Ik heb dorst.", "Herhaal deze zin", "Ik heb dorst", "💧", .repeatAfterMe, .oral, false),
        e("Ik heb pijn.", "Herhaal deze zin", "Ik heb pijn", "🤕", .repeatAfterMe, .oral, true),
        e("Ik wil spelen.", "Herhaal deze zin", "Ik wil spelen", "🎮", .repeatAfterMe, .oral, false),
        e("Ik wil eten.", "Herhaal deze zin", "Ik wil eten", "🍎", .repeatAfterMe, .oral, true),
        e("Help me alsjeblieft.", "Herhaal", "Help me alsjeblieft", "🤝", .repeatAfterMe, .social, false),
        e("Ik ben blij.", "Herhaal", "Ik ben blij", "😊", .repeatAfterMe, .social, true),
        e("Ik ben verdrietig.", "Herhaal", "Ik ben verdrietig", "😢", .repeatAfterMe, .social, false),
        e("Het is rood!", "Herhaal de kleur", "Rood", "🔴", .repeatAfterMe, .oral, true),
        e("Het is blauw!", "Herhaal de kleur", "Blauw", "🔵", .repeatAfterMe, .oral, false),
        e("Het is geel!", "Herhaal de kleur", "Geel", "🟡", .repeatAfterMe, .oral, true),
        e("Het is groen!", "Herhaal de kleur", "Groen", "🟢", .repeatAfterMe, .oral, false),
        e("Één, twee, drie!", "Herhaal de getallen", "Één, twee, drie", "🔢", .repeatAfterMe, .math, true),
        e("Vier, vijf!", "Herhaal de getallen", "Vier, vijf", "🔢", .repeatAfterMe, .math, false),
        e("De kat zegt miauw.", "Herhaal", "De kat zegt miauw", "🐱", .repeatAfterMe, .oral, true),
        e("De hond zegt waf.", "Herhaal", "De hond zegt waf", "🐶", .repeatAfterMe, .oral, false),
        e("Mama.", "Herhaal dit woord", "Mama", "👩", .repeatAfterMe, .oral, true),
        e("Papa.", "Herhaal dit woord", "Papa", "👨", .repeatAfterMe, .oral, false),
        e("Meer!", "Herhaal dit woord", "Meer", "🔁", .repeatAfterMe, .oral, true),
        e("Klaar!", "Herhaal dit woord", "Klaar", "🏁", .repeatAfterMe, .oral, false),
        e("Het is warm!", "Herhaal", "Het is warm", "🔥", .repeatAfterMe, .oral, true),
        e("Het is koud!", "Herhaal", "Het is koud", "❄️", .repeatAfterMe, .oral, false),
        e("Welterusten!", "Herhaal", "Welterusten", "😴", .repeatAfterMe, .social, true),
    ] }

    private static func nlLevel1() -> [CurriculumExercise] { [
        e("Herhaal: De kat eet een muis.", "Herhaal de zin", "De kat eet een muis", "🐱", .repeatAfterMe, .oral, true),
        e("Herhaal: Het meisje speelt in de tuin.", "Herhaal de zin", "Het meisje speelt in de tuin", "🌸", .repeatAfterMe, .oral, false),
        e("De klank A — zoals in APPEL.", "Herhaal de klank en het woord", "A — Appel", "🍎", .repeatAfterMe, .reading, true),
        e("Lees: MA-MA.", "Lees de lettergrepen", "Mama", "👩", .repeatAfterMe, .reading, false),
        e("Lees: HUIS.", "Lees het woord", "Huis", "🏠", .repeatAfterMe, .reading, true),
        e("Hoeveel is 2 plus 3?", "Antwoord hardop", "5", "🔢", .answerQuestion, .math, false),
        e("Hoeveel is 4 plus 1?", "Antwoord hardop", "5", "🔢", .answerQuestion, .math, true),
        e("Tel tot 10.", "Tel hardop", "1 2 3 4 5 6 7 8 9 10", "🔢", .repeatAfterMe, .math, false),
        e("Hoeveel is 5 min 2?", "Antwoord", "3", "🔢", .answerQuestion, .math, true),
        e("Wat zeg je als je aankomt?", "Antwoord", "Hallo", "🏫", .answerQuestion, .social, false),
        e("Wat zeg je als je weggaat?", "Antwoord", "Tot ziens", "👋", .answerQuestion, .social, true),
        e("Herhaal: Ik steek mijn hand op om te praten.", "Herhaal de regel", "Ik steek mijn hand op om te praten", "✋", .repeatAfterMe, .social, false),
        e("Herhaal: Ik deel met mijn vrienden.", "Herhaal", "Ik deel met mijn vrienden", "🤝", .repeatAfterMe, .social, true),
        e("Is 7 groter dan 3?", "Antwoord", "Ja 7 is groter dan 3", "🔢", .answerQuestion, .math, false),
        e("Lees: VLINDER.", "Lees het woord", "Vlinder", "🦋", .repeatAfterMe, .reading, true),
        e("Lees: OLI-FANT.", "Lees de lettergrepen", "Olifant", "🐘", .repeatAfterMe, .reading, false),
        e("Hoeveel is 3 plus 3?", "Antwoord", "6", "🔢", .answerQuestion, .math, true),
        e("Wat zie je?", "Kijk naar 🐶 en antwoord", "Ik zie een hond", "🐶", .answerQuestion, .oral, false),
        e("Welke kleur is het?", "Kijk naar 🍎 en antwoord", "Het is rood", "🍎", .answerQuestion, .oral, true),
        e("Herhaal: Ik lees elke dag een boek.", "Herhaal", "Ik lees elke dag een boek", "📖", .repeatAfterMe, .reading, false),
    ] }

    private static func nlLevel2() -> [CurriculumExercise] { [
        e("Herhaal: De hond rent achter de rode bal aan.", "Herhaal de zin", "De hond rent achter de rode bal aan", "🐕", .repeatAfterMe, .oral, true),
        e("Wat is het onderwerp van: De vogels zingen?", "Antwoord", "De vogels", "🐦", .answerQuestion, .reading, false),
        e("Vervoeg GAAN in de tegenwoordige tijd: ik...", "Vul aan", "Ik ga", "📝", .answerQuestion, .writing, true),
        e("Vervoeg ZIJN in de tegenwoordige tijd: hij...", "Vul aan", "Hij is", "📝", .answerQuestion, .writing, false),
        e("Wat is het meervoud van KIND?", "Antwoord", "Kinderen", "👶", .answerQuestion, .writing, true),
        e("Geef een synoniem voor BLIJ.", "Antwoord", "Gelukkig", "😊", .answerQuestion, .writing, false),
        e("Hoeveel is 7 keer 8?", "Antwoord", "56", "🔢", .answerQuestion, .math, true),
        e("Hoeveel is 6 keer 9?", "Antwoord", "54", "🔢", .answerQuestion, .math, false),
        e("Wat is de hoofdstad van Nederland?", "Antwoord", "Amsterdam", "🏛️", .answerQuestion, .science, true),
        e("Noem drie planeten.", "Antwoord", "Mercurius Venus Mars", "🪐", .answerQuestion, .science, false),
        e("Wat hebben planten nodig om te groeien?", "Antwoord", "Water licht en aarde", "🌱", .answerQuestion, .science, true),
        e("Wat zijn de drie aggregatietoestanden van water?", "Antwoord", "Vloeibaar vast gasvormig", "💧", .answerQuestion, .science, false),
        e("Herhaal: Bloemen bloeien in de lente.", "Herhaal", "Bloemen bloeien in de lente", "🌸", .repeatAfterMe, .oral, true),
        e("Hoeveel is 45 gedeeld door 9?", "Antwoord", "5", "🔢", .answerQuestion, .math, false),
        e("Wat is de helft van 80?", "Antwoord", "40", "🔢", .answerQuestion, .math, true),
        e("Herhaal: Wij leven op de planeet Aarde.", "Herhaal", "Wij leven op de planeet Aarde", "🌍", .repeatAfterMe, .science, false),
        e("Hoeveel is 234 plus 156?", "Bereken en antwoord", "390", "🔢", .answerQuestion, .math, true),
        e("Herhaal: Wij eten elke ochtend vers fruit.", "Herhaal", "Wij eten elke ochtend vers fruit", "🍎", .repeatAfterMe, .oral, false),
        e("Vervoeg HEBBEN in de tegenwoordige tijd: wij...", "Vul aan", "Wij hebben", "📝", .answerQuestion, .writing, true),
        e("Herhaal: Ik doe altijd mijn best.", "Herhaal", "Ik doe altijd mijn best", "🌟", .repeatAfterMe, .social, false),
    ] }

    private static func nlLevel3() -> [CurriculumExercise] { [
        e("Herhaal: Vrijheid van meningsuiting is een grondrecht.", "Herhaal", "Vrijheid van meningsuiting is een grondrecht", "📜", .repeatAfterMe, .oral, true),
        e("Wat is een metafoor? Geef een voorbeeld.", "Antwoord", "Een vergelijking zonder zoals. Bv: Hij is een leeuw", "📖", .answerQuestion, .reading, false),
        e("Los op: 2x plus 6 is gelijk aan 14.", "Antwoord", "x is gelijk aan 4", "🔢", .answerQuestion, .math, true),
        e("Noem de stelling van Pythagoras.", "Antwoord", "In een rechthoekige driehoek geldt a² plus b² is gelijk aan c²", "📐", .answerQuestion, .math, false),
        e("Herhaal: De cel is de basiseenheid van het leven.", "Herhaal", "De cel is de basiseenheid van het leven", "🔬", .repeatAfterMe, .science, true),
        e("In welk jaar begon de Eerste Wereldoorlog?", "Antwoord", "1914", "📚", .answerQuestion, .science, false),
        e("Wat is de chemische formule van water?", "Antwoord", "H twee O", "💧", .answerQuestion, .science, true),
        e("Noem twee kinderrechten.", "Antwoord", "Het recht op onderwijs en gezondheid", "📜", .answerQuestion, .social, false),
        e("Beschrijf jouw ideale dag in één zin.", "Antwoord vrij", "Mijn ideale dag zou zijn...", "🌟", .answerQuestion, .oral, true),
        e("Herhaal: Ik geloof dat ieder mens respect verdient.", "Herhaal", "Ik geloof dat ieder mens respect verdient", "🤝", .repeatAfterMe, .social, false),
    ] }

    // Backward compat
    static func questions(for module: ModuleType, level: SchoolLevel, count: Int = 8) -> [Question] { [] }
}
