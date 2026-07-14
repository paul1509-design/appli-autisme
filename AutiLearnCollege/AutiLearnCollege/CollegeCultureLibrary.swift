import Foundation

// MARK: - Bibliothèque Culture & Histoires (multi-langue, format ABA)
struct CollegeCultureLibrary {

    static func lessonSlides(level: CollegeLevel, language: CollegeLanguage) -> [CollegeExercise] {
        switch language {
        case .english:    return englishStories(level: level)
        case .spanish:    return spanishStories(level: level)
        case .portuguese: return portugueseStories(level: level)
        case .italian:    return italianStories(level: level)
        case .german:     return germanStories(level: level)
        case .arabic:     return arabicStories(level: level)
        case .dutch:      return dutchStories(level: level)
        default:          return frenchStories(level: level)
        }
    }

    static func exercises(level: CollegeLevel, language: CollegeLanguage) -> [CollegeExercise] {
        switch language {
        case .english:    return englishExercises(level: level)
        case .spanish:    return spanishExercises(level: level)
        case .portuguese: return portugueseExercises(level: level)
        case .italian:    return italianExercises(level: level)
        case .german:     return germanExercises(level: level)
        case .arabic:     return arabicExercises(level: level)
        case .dutch:      return dutchExercises(level: level)
        default:          return frenchExercises(level: level)
        }
    }

    // MARK: - Raccourci construction exercice
    private static func ex(_ mode: CollegeExerciseMode, _ question: String,
                           _ choices: [String], _ answer: String,
                           _ explanation: String, _ emoji: String, _ diff: Int) -> CollegeExercise {
        CollegeExercise(subject: .culture, mode: mode, question: question,
                        choices: choices, correctAnswer: answer,
                        explanation: explanation, emoji: emoji, difficulty: diff)
    }

    // MARK: - FRANÇAIS -------------------------------------------------------

    private static func frenchStories(level: CollegeLevel) -> [CollegeExercise] {
        var slides: [CollegeExercise] = [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "Le lion et la souris — une fable d'Ésope",
                    body: "Un jour, un **lion** dormait sous un arbre. Une petite **souris** lui courut sur le nez et le réveilla. Furieux, le lion s'apprêtait à la croquer. « Épargne-moi ! » supplia la souris. « Un jour, je te renverrai la pareille. » Le lion rit — lui, avoir besoin d'une souris ? — mais il la laissa partir. Quelques jours plus tard, le lion tomba dans un **filet de chasseurs**. Il rugissait de rage quand la souris arriva, rongea les cordes, et **le libéra**. Morale : personne n'est trop petit pour rendre service.",
                    narration: "Je vais te raconter une histoire vieille de 2 500 ans — et dont la leçon est toujours vraie aujourd'hui."),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "Neil Armstrong : un pas pour l'humanité",
                    body: "Le **20 juillet 1969**, le monde retient son souffle. À bord d'**Apollo 11**, l'astronaute américain **Neil Armstrong** pose le pied sur la Lune — pour la toute première fois dans l'histoire humaine. Il dit alors une phrase célèbre : « C'est un **petit pas** pour l'homme, un **grand pas** pour l'humanité. » Mission accomplie en 8 jours, 3 heures et 18 minutes. Depuis la Terre, **600 millions** de personnes regardaient en direct à la télévision. Aujourd'hui, la NASA prépare le retour humain sur la Lune avec la mission **Artemis**.",
                    narration: "En 1969, l'humanité a réalisé l'impossible. Je te raconte comment trois hommes sont allés jusqu'à la Lune."),
            .lesson(subject: .culture, emoji: "🎨",
                    title: "Léonard de Vinci : le génie universel",
                    body: "**Léonard de Vinci** (1452–1519) était peintre, sculpteur, architecte, musicien, mathématicien, ingénieur et **inventeur**. Dans ses carnets secrets, il dessina des **ailes volantes** (ancêtres des avions), un **tank**, une **machine à plonger** et même un **robot**... en **1495** ! Son tableau le plus célèbre, la **Joconde**, est aujourd'hui protégé par une vitre blindée au Louvre à Paris. Si Léonard revenait aujourd'hui, il s'intéresserait probablement à l'intelligence artificielle — il adorait les puzzles impossibles.",
                    narration: "Il y a 500 ans, un homme a inventé l'avion, le char d'assaut et le robot. Son nom ? Léonard de Vinci."),
            .lesson(subject: .culture, emoji: "🌊",
                    title: "Marie Curie : la femme qui a changé la science",
                    body: "**Marie Curie** (1867–1934) est la seule personne de l'histoire à avoir gagné le **Prix Nobel** dans **deux** sciences différentes : la physique (1903) et la chimie (1911). Née en **Pologne**, elle étudia en secret car les femmes n'avaient pas le droit d'aller à l'université dans son pays. Elle découvrit deux éléments du tableau périodique : le **polonium** (nommé en l'honneur de sa patrie) et le **radium**. Ses recherches sur la radioactivité ont permis d'inventer la **radiothérapie** contre le cancer.",
                    narration: "Elle a brisé toutes les barrières — de genre, de nationalité, de science. Je vais te parler de la femme la plus brillante du XXe siècle."),
        ]
        if level.isLycee {
            slides += [
                .lesson(subject: .culture, emoji: "🤖",
                        title: "Intelligence artificielle : ami ou ennemi ?",
                        body: "En **2022**, une IA nommée **ChatGPT** a stupéfait le monde en parlant comme un humain, en écrivant des poèmes et en résolvant des problèmes de maths. Mais l'IA n'est pas magique : c'est un programme qui apprend des **milliards d'exemples** et prédit quelle réponse est la plus probable. Elle se trompe, invente des faits, et ne « comprend » rien. Le vrai enjeu : l'IA va transformer des millions de **métiers** (chauffeurs, comptables, juristes), mais créera aussi de nouveaux. La question centrale : comment garder les **humains aux commandes** ?",
                        narration: "L'intelligence artificielle est la plus grande révolution de notre époque. Je t'explique comment ça marche vraiment."),
                .lesson(subject: .culture, emoji: "🌍",
                        title: "Le changement climatique expliqué simplement",
                        body: "La Terre a une **couverture invisible** : les gaz à effet de serre (CO₂, méthane...) retiennent la chaleur du soleil, comme une serre. Sans eux, la température serait de **−18°C** — trop froid pour vivre ! Mais depuis 1850 et la **révolution industrielle**, les humains brûlent du pétrole, du charbon et du gaz, rejetant **trop** de CO₂. Résultat : la couverture devient trop épaisse, la Terre se réchauffe de **+1,1°C** en moyenne. Conséquences : glaciers qui fondent, océans qui montent, événements météo extrêmes. La solution passe par les **énergies renouvelables** et moins de gaspillage.",
                        narration: "Le changement climatique c'est la question de ta génération. Je t'explique la science en quelques minutes."),
            ]
        }
        return slides
    }

    private static func frenchExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            // Culture générale
            ex(.multipleChoice, "Qui a peint la Joconde ?",
               ["Léonard de Vinci", "Michel-Ange", "Raphaël", "Picasso"], "Léonard de Vinci",
               "La Joconde a été peinte vers 1503-1519 par Léonard de Vinci. Elle est exposée au Louvre à Paris.", "🎨", 1),
            ex(.multipleChoice, "Combien de continents y a-t-il sur Terre ?",
               ["5", "6", "7", "8"], "7",
               "Les 7 continents sont : Afrique, Antarctique, Amérique du Nord, Amérique du Sud, Asie, Europe, Océanie.", "🌍", 1),
            ex(.trueFalse, "La baleine bleue est le plus grand animal jamais connu sur Terre.",
               ["Vrai", "Faux"], "Vrai",
               "La baleine bleue peut mesurer jusqu'à 30 m et peser 180 tonnes — plus grand que n'importe quel dinosaure !", "🐋", 1),
            ex(.multipleChoice, "Quel est l'os le plus long du corps humain ?",
               ["Le fémur", "Le tibia", "Le radius", "L'humérus"], "Le fémur",
               "Le fémur (os de la cuisse) est le plus long et le plus solide des os humains. Il peut supporter le poids d'une voiture !", "🦴", 2),
            ex(.trueFalse, "Les pieuvres ont trois cœurs.",
               ["Vrai", "Faux"], "Vrai",
               "Les pieuvres ont 3 cœurs : un principal qui pompe le sang dans le corps, et deux branchiaux pour les branchies. Elles ont aussi du sang bleu !", "🐙", 2),
            ex(.multipleChoice, "Quelle planète est surnommée la 'planète rouge' ?",
               ["Mars", "Jupiter", "Venus", "Saturne"], "Mars",
               "Mars doit sa couleur rouge à l'oxyde de fer (rouille) qui recouvre son sol. Elle est deux fois plus petite que la Terre.", "🔴", 1),
            ex(.fillBlank, "Le prix Nobel de la Paix est remis à Oslo chaque année le ___ décembre.",
               [], "10",
               "Le 10 décembre est la date anniversaire de la mort d'Alfred Nobel (1896). Tous les prix sont remis ce jour-là.", "🏅", 2),
            ex(.multipleChoice, "Dans quel pays se trouve la Grande Muraille ?",
               ["Chine", "Inde", "Mongolie", "Japon"], "Chine",
               "La Grande Muraille de Chine s'étend sur plus de 21 000 km. Elle a été construite sur plusieurs siècles pour protéger l'Empire.", "🏯", 1),
            ex(.trueFalse, "On utilise seulement 10% de notre cerveau.",
               ["Vrai", "Faux"], "Faux",
               "C'est un mythe ! Les IRM montrent que nous utilisons la quasi-totalité de notre cerveau, avec des zones différentes selon les activités.", "🧠", 2),
            ex(.multipleChoice, "Qui a inventé la dynamite et créé le prix Nobel ?",
               ["Alfred Nobel", "Thomas Edison", "Nikola Tesla", "Louis Pasteur"], "Alfred Nobel",
               "Alfred Nobel (1833–1896) inventa la dynamite, devint millionnaire, puis, remords aidant, légua sa fortune pour créer les Prix Nobel.", "💥", 2),
            ex(.multipleChoice, "Quelle est la plus haute montagne du monde ?",
               ["L'Everest", "Le K2", "Le Kilimandjaro", "Le Mont Blanc"], "L'Everest",
               "L'Everest culmine à 8 849 m dans l'Himalaya. Il a été gravi pour la première fois en 1953 par Edmund Hillary et Tenzing Norgay.", "⛰️", 1),
            ex(.multipleChoice, "Quel scientifique a découvert la pénicilline (premier antibiotique) ?",
               ["Alexander Fleming", "Louis Pasteur", "Marie Curie", "Albert Einstein"], "Alexander Fleming",
               "En 1928, Alexander Fleming remarqua qu'une moisissure (Penicillium) tuait les bactéries dans sa boîte de Petri. Une découverte qui a sauvé des millions de vies.", "🔬", 2),
            ex(.oral, "Explique à voix haute pourquoi tu penses que Marie Curie est un modèle inspirant.",
               [], "Marie Curie a surmonté les inégalités de genre et de nationalité pour devenir la première femme à obtenir un prix Nobel.",
               "Marie Curie a reçu 2 Prix Nobel (physique 1903, chimie 1911) malgré les obstacles liés au fait d'être une femme au XIXe siècle.", "👩‍🔬", 1),
            ex(.multipleChoice, "Combien de langues sont parlées dans le monde ?",
               ["Environ 7 000", "Environ 1 000", "Environ 200", "Environ 50 000"], "Environ 7 000",
               "Il existe environ 7 000 langues vivantes dans le monde. Le mandarin est la plus parlée (par le nombre de locuteurs natifs).", "🗣️", 2),
            ex(.trueFalse, "Le soleil est une étoile.",
               ["Vrai", "Faux"], "Vrai",
               "Le Soleil est une étoile de taille moyenne, à 150 millions de km de la Terre. Il représente 99,8% de la masse totale du système solaire.", "☀️", 1),
        ]
        if level.isLycee {
            pool += [
                ex(.multipleChoice, "En quelle année a été signé la Déclaration universelle des droits de l'Homme ?",
                   ["1948", "1945", "1789", "1919"], "1948",
                   "La DUDH a été adoptée le 10 décembre 1948 par l'ONU, juste après la Seconde Guerre mondiale, pour que les horreurs ne se reproduisent plus.", "📜", 2),
                ex(.multipleChoice, "Quel est le pays le plus grand du monde en superficie ?",
                   ["La Russie", "Le Canada", "Les États-Unis", "La Chine"], "La Russie",
                   "La Russie couvre 17,1 millions de km² — soit plus de 30 fois la France. Elle s'étend sur 11 fuseaux horaires.", "🗺️", 2),
                ex(.fillBlank, "L'ADN contient les instructions génétiques sous forme de 4 bases : A, T, G et ___.",
                   [], "C",
                   "Les 4 bases azotées de l'ADN sont : Adénine (A), Thymine (T), Guanine (G) et Cytosine (C). A s'associe à T, et G à C.", "🧬", 3),
                ex(.multipleChoice, "Quelle est la vitesse de la lumière dans le vide ?",
                   ["300 000 km/s", "150 000 km/s", "3 000 km/s", "1 000 000 km/s"], "300 000 km/s",
                   "La lumière parcourt 299 792 km par seconde. Elle met 8 minutes pour arriver du Soleil à la Terre, et 4 ans depuis l'étoile la plus proche.", "💡", 3),
                ex(.trueFalse, "Internet a été inventé pour un usage militaire avant de devenir public.",
                   ["Vrai", "Faux"], "Vrai",
                   "ARPANET (1969), ancêtre d'Internet, était financé par l'armée américaine. Le Web public tel qu'on le connaît a été inventé par Tim Berners-Lee en 1991.", "💻", 2),
            ]
        }
        return pool
    }

    // MARK: - ENGLISH --------------------------------------------------------

    private static func englishStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "The Lion and the Mouse",
                    body: "One day, a **lion** was sleeping under a tree. A little **mouse** ran across his nose and woke him up. Furious, the lion was about to eat her. 'Please spare me!' begged the mouse. 'One day I will repay you.' The lion laughed — him, need a mouse? — but he let her go. Days later, the lion fell into a **hunter's net**. He roared with rage when the mouse arrived, **gnawed through the ropes**, and set him free. Moral: **no one is too small to help**.",
                    narration: "Here's a story that is 2,500 years old — and still true today. Listen carefully!"),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "Neil Armstrong: One Giant Leap",
                    body: "On **July 20, 1969**, the world held its breath. Astronaut **Neil Armstrong** stepped onto the Moon — the first human being ever to do so. He said: 'That's one **small step** for man, one **giant leap** for mankind.' The mission lasted 8 days. On Earth, **600 million** people watched on TV. The spacecraft was called **Apollo 11**. Today, NASA is preparing to return to the Moon with the **Artemis** mission.",
                    narration: "In 1969, humanity did the impossible. Let me tell you how three brave astronauts went all the way to the Moon."),
            .lesson(subject: .culture, emoji: "🎨",
                    title: "Leonardo da Vinci: The Ultimate Genius",
                    body: "**Leonardo da Vinci** (1452–1519) was a painter, sculptor, architect, musician, mathematician, engineer and **inventor**. In his secret notebooks, he sketched **flying machines** (early airplanes), a **tank**, a **diving suit**, and even a **robot** — in **1495**! His most famous painting, the **Mona Lisa**, is now protected by bulletproof glass at the Louvre in Paris. If Leonardo came back today, he'd probably be working in **artificial intelligence**.",
                    narration: "500 years ago, one man invented the airplane, the tank, and the robot. His name? Leonardo da Vinci. Incredible but true!"),
        ]
    }

    private static func englishExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "Who painted the Mona Lisa?",
               ["Leonardo da Vinci", "Michelangelo", "Raphael", "Picasso"], "Leonardo da Vinci",
               "The Mona Lisa was painted around 1503–1519 by Leonardo da Vinci. It is displayed at the Louvre Museum in Paris.", "🎨", 1),
            ex(.multipleChoice, "How many continents are there on Earth?",
               ["5", "6", "7", "8"], "7",
               "The 7 continents are: Africa, Antarctica, North America, South America, Asia, Europe, and Oceania.", "🌍", 1),
            ex(.trueFalse, "The blue whale is the largest animal ever known on Earth.",
               ["True", "False"], "True",
               "The blue whale can reach 30 m in length and weigh 180 tonnes — bigger than any dinosaur!", "🐋", 1),
            ex(.multipleChoice, "Which planet is called the 'Red Planet'?",
               ["Mars", "Jupiter", "Venus", "Saturn"], "Mars",
               "Mars gets its red colour from iron oxide (rust) on its surface. It is roughly half the size of Earth.", "🔴", 1),
            ex(.trueFalse, "Octopuses have three hearts.",
               ["True", "False"], "True",
               "Octopuses have 3 hearts: one main heart and two gill hearts. They also have blue blood!", "🐙", 2),
            ex(.multipleChoice, "Who discovered the first antibiotic (penicillin)?",
               ["Alexander Fleming", "Louis Pasteur", "Marie Curie", "Albert Einstein"], "Alexander Fleming",
               "In 1928, Alexander Fleming noticed mould killing bacteria in his petri dish. That discovery has saved hundreds of millions of lives.", "🔬", 2),
            ex(.multipleChoice, "What is the longest bone in the human body?",
               ["The femur", "The tibia", "The radius", "The humerus"], "The femur",
               "The femur (thigh bone) is the longest and strongest bone. It can support the weight of a car!", "🦴", 2),
            ex(.trueFalse, "We only use 10% of our brain.",
               ["True", "False"], "False",
               "This is a myth! Brain scans show we use virtually all of our brain — different areas for different tasks.", "🧠", 2),
            ex(.multipleChoice, "What is the speed of light in a vacuum?",
               ["300,000 km/s", "150,000 km/s", "3,000 km/s", "1,000,000 km/s"], "300,000 km/s",
               "Light travels at 299,792 km per second. It takes 8 minutes to travel from the Sun to the Earth.", "💡", 2),
            ex(.oral, "Tell in two sentences what you found most surprising about Leonardo da Vinci.",
               [], "Leonardo da Vinci sketched a flying machine and a robot in the 1490s — 400 years before they were built.",
               "Da Vinci's notebooks contained designs for helicopters, tanks, solar energy and robots — centuries ahead of their time.", "🎨", 1),
            ex(.multipleChoice, "How many languages are spoken in the world?",
               ["About 7,000", "About 1,000", "About 200", "About 50,000"], "About 7,000",
               "There are approximately 7,000 living languages worldwide. Mandarin Chinese has the most native speakers.", "🗣️", 2),
            ex(.trueFalse, "The Sun is a star.",
               ["True", "False"], "True",
               "The Sun is a medium-sized star located 150 million km from Earth. It makes up 99.8% of the solar system's mass.", "☀️", 1),
        ]
        if level.isLycee {
            pool += [
                ex(.multipleChoice, "In which year was the Universal Declaration of Human Rights signed?",
                   ["1948", "1945", "1789", "1919"], "1948",
                   "The UDHR was adopted on 10 December 1948 by the United Nations, after World War II.", "📜", 2),
                ex(.multipleChoice, "Which country is the largest in the world by area?",
                   ["Russia", "Canada", "USA", "China"], "Russia",
                   "Russia covers 17.1 million km² — more than 11% of Earth's total land area.", "🗺️", 2),
                ex(.trueFalse, "The Internet was originally invented for military use.",
                   ["True", "False"], "True",
                   "ARPANET (1969), the Internet's ancestor, was funded by the US military. The public World Wide Web was invented by Tim Berners-Lee in 1991.", "💻", 2),
            ]
        }
        return pool
    }

    // MARK: - ESPAÑOL --------------------------------------------------------

    private static func spanishStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "El León y el Ratón",
                    body: "Un día, un **león** dormía bajo un árbol. Un pequeño **ratón** corrió por su nariz y lo despertó. Furioso, el león iba a comérselo. '¡Por favor, perdóname!' suplicó el ratón. 'Algún día te lo pagaré.' El león se rió — ¿él, necesitar a un ratón? — pero lo dejó ir. Días después, el león cayó en una **red de cazadores**. Rugía de rabia cuando llegó el ratón, **royó las cuerdas** y lo liberó. Moraleja: **nadie es demasiado pequeño para ayudar**.",
                    narration: "Esta es una historia de 2 500 años que sigue siendo verdad hoy. ¡Escucha con atención!"),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "Neil Armstrong: Un gran salto",
                    body: "El **20 de julio de 1969**, el mundo contuvo la respiración. El astronauta **Neil Armstrong** pisó la Luna — el primer ser humano en hacerlo. Dijo: 'Es un **pequeño paso** para el hombre, un **gran salto** para la humanidad.' La misión duró 8 días. En la Tierra, **600 millones** de personas lo vieron por televisión. La nave se llamaba **Apollo 11**.",
                    narration: "En 1969, la humanidad hizo lo imposible. Te cuento cómo tres valientes astronautas llegaron hasta la Luna."),
        ]
    }

    private static func spanishExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "¿Quién pintó la Mona Lisa?",
               ["Leonardo da Vinci", "Miguel Ángel", "Rafael", "Picasso"], "Leonardo da Vinci",
               "La Mona Lisa fue pintada entre 1503 y 1519 por Leonardo da Vinci. Está expuesta en el Museo del Louvre en París.", "🎨", 1),
            ex(.multipleChoice, "¿Cuántos continentes hay en la Tierra?",
               ["5", "6", "7", "8"], "7",
               "Los 7 continentes son: África, Antártida, América del Norte, América del Sur, Asia, Europa y Oceanía.", "🌍", 1),
            ex(.trueFalse, "La ballena azul es el animal más grande que ha existido en la Tierra.",
               ["Verdadero", "Falso"], "Verdadero",
               "La ballena azul puede medir hasta 30 m y pesar 180 toneladas — ¡más que cualquier dinosaurio!", "🐋", 1),
            ex(.multipleChoice, "¿Qué planeta se llama el 'Planeta Rojo'?",
               ["Marte", "Júpiter", "Venus", "Saturno"], "Marte",
               "Marte debe su color rojo al óxido de hierro (óxido) que cubre su superficie. Es aproximadamente la mitad del tamaño de la Tierra.", "🔴", 1),
            ex(.trueFalse, "Los pulpos tienen tres corazones.",
               ["Verdadero", "Falso"], "Verdadero",
               "Los pulpos tienen 3 corazones: uno principal y dos branquiales. También tienen sangre azul.", "🐙", 2),
            ex(.multipleChoice, "¿Quién descubrió el primer antibiótico (la penicilina)?",
               ["Alexander Fleming", "Louis Pasteur", "Marie Curie", "Albert Einstein"], "Alexander Fleming",
               "En 1928, Alexander Fleming notó que un moho mataba bacterias en su placa de Petri. Esa historia salvó cientos de millones de vidas.", "🔬", 2),
            ex(.multipleChoice, "¿Cuál es el hueso más largo del cuerpo humano?",
               ["El fémur", "La tibia", "El radio", "El húmero"], "El fémur",
               "El fémur (hueso del muslo) es el más largo y fuerte. ¡Puede soportar el peso de un coche!", "🦴", 2),
            ex(.multipleChoice, "¿En qué país se encuentra la Gran Muralla?",
               ["China", "India", "Mongolia", "Japón"], "China",
               "La Gran Muralla China se extiende más de 21 000 km. Fue construida durante siglos para proteger el Imperio.", "🏯", 1),
            ex(.oral, "Explica en voz alta por qué crees que Marie Curie es un modelo a seguir.",
               [], "Marie Curie superó las desigualdades de género para convertirse en la primera mujer en ganar el Premio Nobel.",
               "Marie Curie recibió 2 Premios Nobel (física 1903, química 1911) a pesar de los obstáculos por ser mujer.", "👩‍🔬", 1),
        ]
        return pool
    }

    // MARK: - PORTUGUÊS ------------------------------------------------------

    private static func portugueseStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "O Leão e o Rato",
                    body: "Um dia, um **leão** dormia sob uma árvore. Um pequeno **rato** correu pelo seu nariz e o acordou. Furioso, o leão ia devorá-lo. 'Por favor, poupa-me!' suplicou o rato. 'Um dia, te pagarei.' O leão riu — ele, precisar de um rato? — mas deixou-o ir. Dias depois, o leão caiu numa **rede de caçadores**. Rugia de raiva quando o rato chegou, **roeu as cordas** e libertou-o. Moral: **ninguém é pequeno demais para ajudar**.",
                    narration: "Esta é uma história com 2 500 anos que ainda é verdade hoje. Ouve com atenção!"),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "Neil Armstrong: Um Grande Salto",
                    body: "No dia **20 de julho de 1969**, o mundo ficou em silêncio. O astronauta **Neil Armstrong** pisou na Lua — o primeiro ser humano a fazê-lo. Disse: 'É um **pequeno passo** para o homem, um **grande salto** para a humanidade.' A missão durou 8 dias. Na Terra, **600 milhões** de pessoas assistiram pela televisão. A nave chamava-se **Apollo 11**.",
                    narration: "Em 1969, a humanidade fez o impossível. Vou contar-te como três corajosos astronautas chegaram até à Lua."),
        ]
    }

    private static func portugueseExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "Quem pintou a Mona Lisa?",
               ["Leonardo da Vinci", "Miguel Ângelo", "Rafael", "Picasso"], "Leonardo da Vinci",
               "A Mona Lisa foi pintada por volta de 1503–1519 por Leonardo da Vinci. Está exposta no Museu do Louvre em Paris.", "🎨", 1),
            ex(.multipleChoice, "Quantos continentes existem na Terra?",
               ["5", "6", "7", "8"], "7",
               "Os 7 continentes são: África, Antártida, América do Norte, América do Sul, Ásia, Europa e Oceânia.", "🌍", 1),
            ex(.trueFalse, "A baleia azul é o maior animal que já existiu na Terra.",
               ["Verdadeiro", "Falso"], "Verdadeiro",
               "A baleia azul pode medir até 30 m e pesar 180 toneladas — maior do que qualquer dinossauro!", "🐋", 1),
            ex(.multipleChoice, "Qual planeta é chamado de 'Planeta Vermelho'?",
               ["Marte", "Júpiter", "Vênus", "Saturno"], "Marte",
               "Marte deve sua cor vermelha ao óxido de ferro (ferrugem) que cobre sua superfície.", "🔴", 1),
            ex(.trueFalse, "Os polvos têm três corações.",
               ["Verdadeiro", "Falso"], "Verdadeiro",
               "Os polvos têm 3 corações: um principal e dois branquiais. Eles também têm sangue azul!", "🐙", 2),
            ex(.multipleChoice, "Qual é o osso mais longo do corpo humano?",
               ["O fêmur", "A tíbia", "O rádio", "O úmero"], "O fêmur",
               "O fêmur (osso da coxa) é o mais longo e resistente. Pode suportar o peso de um carro!", "🦴", 2),
            ex(.multipleChoice, "Em que país fica a Grande Muralha?",
               ["China", "Índia", "Mongólia", "Japão"], "China",
               "A Grande Muralha da China estende-se por mais de 21 000 km, construída durante séculos para proteger o Império.", "🏯", 1),
            ex(.oral, "Explica em voz alta por que achas que Marie Curie é um modelo inspirador.",
               [], "Marie Curie superou as desigualdades de género e tornou-se a primeira mulher a ganhar o Prémio Nobel.",
               "Marie Curie recebeu 2 Prémios Nobel (física 1903, química 1911) apesar dos obstáculos por ser mulher.", "👩‍🔬", 1),
        ]
        return pool
    }

    // MARK: - ITALIANO -------------------------------------------------------

    private static func italianStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "Il Leone e il Topo",
                    body: "Un giorno, un **leone** dormiva sotto un albero. Un piccolo **topo** gli corse sul naso e lo svegliò. Furioso, il leone stava per mangiarlo. 'Ti prego, risparmiami!' implorò il topo. 'Un giorno ti ricambierò.' Il leone rise — lui, aver bisogno di un topo? — ma lo lasciò andare. Giorni dopo, il leone cadde in una **rete di cacciatori**. Ruggiva di rabbia quando arrivò il topo, **rosicchiò le corde** e lo liberò. Morale: **nessuno è troppo piccolo per aiutare**.",
                    narration: "Questa storia ha 2 500 anni — e la sua lezione è ancora vera oggi. Ascolta bene!"),
            .lesson(subject: .culture, emoji: "🎨",
                    title: "Leonardo da Vinci: Il Genio Universale",
                    body: "**Leonardo da Vinci** (1452–1519) era pittore, scultore, architetto, musicista, matematico, ingegnere e **inventore**. Nei suoi taccuini segreti disegnò **macchine volanti** (antenate degli aerei), un **carro armato**, una **tuta subacquea** e persino un **robot**... nel **1495**! Il suo quadro più famoso, la **Gioconda**, è oggi protetta da un vetro blindato al Louvre di Parigi.",
                    narration: "500 anni fa, un uomo inventò l'aereo, il carro armato e il robot. Il suo nome? Leonardo da Vinci."),
        ]
    }

    private static func italianExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "Chi ha dipinto la Gioconda?",
               ["Leonardo da Vinci", "Michelangelo", "Raffaello", "Picasso"], "Leonardo da Vinci",
               "La Gioconda fu dipinta intorno al 1503–1519 da Leonardo da Vinci. È esposta al Museo del Louvre a Parigi.", "🎨", 1),
            ex(.multipleChoice, "Quanti continenti ci sono sulla Terra?",
               ["5", "6", "7", "8"], "7",
               "I 7 continenti sono: Africa, Antartide, America del Nord, America del Sud, Asia, Europa e Oceania.", "🌍", 1),
            ex(.trueFalse, "La balenottera azzurra è il più grande animale mai conosciuto sulla Terra.",
               ["Vero", "Falso"], "Vero",
               "La balenottera azzurra può misurare fino a 30 m e pesare 180 tonnellate — più grande di qualsiasi dinosauro!", "🐋", 1),
            ex(.multipleChoice, "Quale pianeta è chiamato 'Pianeta Rosso'?",
               ["Marte", "Giove", "Venere", "Saturno"], "Marte",
               "Marte deve il suo colore rosso all'ossido di ferro (ruggine) che ricopre la sua superficie.", "🔴", 1),
            ex(.trueFalse, "I polpi hanno tre cuori.",
               ["Vero", "Falso"], "Vero",
               "I polpi hanno 3 cuori: uno principale e due branchiali. Hanno anche il sangue blu!", "🐙", 2),
            ex(.multipleChoice, "Qual è l'osso più lungo del corpo umano?",
               ["Il femore", "La tibia", "Il radio", "L'omero"], "Il femore",
               "Il femore (osso della coscia) è il più lungo e resistente. Può supportare il peso di un'automobile!", "🦴", 2),
            ex(.oral, "Spiega ad alta voce perché pensi che Marie Curie sia un modello ispiratore.",
               [], "Marie Curie ha superato le disuguaglianze di genere diventando la prima donna a vincere il Premio Nobel.",
               "Marie Curie ha ricevuto 2 Premi Nobel (fisica 1903, chimica 1911) nonostante gli ostacoli legati all'essere donna.", "👩‍🔬", 1),
        ]
        return pool
    }

    // MARK: - DEUTSCH --------------------------------------------------------

    private static func germanStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "Der Löwe und die Maus",
                    body: "Eines Tages schlief ein **Löwe** unter einem Baum. Eine kleine **Maus** lief über seine Nase und weckte ihn auf. Wütend wollte der Löwe sie fressen. 'Bitte verschone mich!' bat die Maus. 'Eines Tages werde ich es dir zurückzahlen.' Der Löwe lachte — er, eine Maus brauchen? — aber er ließ sie gehen. Tage später fiel der Löwe in ein **Jägernetz**. Er brüllte vor Wut, als die Maus kam, **die Seile zernagt** und ihn befreite. Moral: **Niemand ist zu klein, um zu helfen**.",
                    narration: "Diese Geschichte ist 2 500 Jahre alt — und ihre Botschaft gilt noch heute. Hör gut zu!"),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "Neil Armstrong: Ein Riesenschritt",
                    body: "Am **20. Juli 1969** hielt die Welt den Atem an. Astronaut **Neil Armstrong** betrat den Mond — als erster Mensch überhaupt. Er sagte: 'Das ist ein **kleiner Schritt** für einen Menschen, aber ein **großer Sprung** für die Menschheit.' Die Mission dauerte 8 Tage. Auf der Erde schauten **600 Millionen** Menschen im Fernsehen zu. Das Raumschiff hieß **Apollo 11**.",
                    narration: "1969 tat die Menschheit das Unmögliche. Ich erzähle dir, wie drei mutige Astronauten bis zum Mond flogen."),
        ]
    }

    private static func germanExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "Wer hat die Mona Lisa gemalt?",
               ["Leonardo da Vinci", "Michelangelo", "Raphael", "Picasso"], "Leonardo da Vinci",
               "Die Mona Lisa wurde um 1503–1519 von Leonardo da Vinci gemalt. Sie wird im Louvre in Paris ausgestellt.", "🎨", 1),
            ex(.multipleChoice, "Wie viele Kontinente gibt es auf der Erde?",
               ["5", "6", "7", "8"], "7",
               "Die 7 Kontinente sind: Afrika, Antarktis, Nordamerika, Südamerika, Asien, Europa und Ozeanien.", "🌍", 1),
            ex(.trueFalse, "Der Blauwal ist das größte Tier, das je auf der Erde gelebt hat.",
               ["Wahr", "Falsch"], "Wahr",
               "Der Blauwal kann bis zu 30 m lang werden und 180 Tonnen wiegen — größer als jeder Dinosaurier!", "🐋", 1),
            ex(.multipleChoice, "Welcher Planet wird als 'Roter Planet' bezeichnet?",
               ["Mars", "Jupiter", "Venus", "Saturn"], "Mars",
               "Der Mars verdankt seine rote Farbe dem Eisenoxid (Rost), das seine Oberfläche bedeckt.", "🔴", 1),
            ex(.trueFalse, "Tintenfische haben drei Herzen.",
               ["Wahr", "Falsch"], "Wahr",
               "Tintenfische haben 3 Herzen: eines Hauptherz und zwei Kiemenherzen. Außerdem haben sie blaues Blut!", "🐙", 2),
            ex(.multipleChoice, "Was ist der längste Knochen im menschlichen Körper?",
               ["Das Oberschenkelbein", "Das Schienbein", "Die Speiche", "Der Oberarmknochen"], "Das Oberschenkelbein",
               "Der Oberschenkelknochen (Femur) ist der längste und stärkste Knochen. Er kann das Gewicht eines Autos tragen!", "🦴", 2),
            ex(.multipleChoice, "In welchem Land befindet sich die Chinesische Mauer?",
               ["China", "Indien", "Mongolei", "Japan"], "China",
               "Die Chinesische Mauer erstreckt sich über mehr als 21 000 km und wurde über Jahrhunderte zum Schutz des Reiches gebaut.", "🏯", 1),
            ex(.oral, "Erkläre laut, warum du denkst, dass Marie Curie ein inspirierendes Vorbild ist.",
               [], "Marie Curie überwand Ungleichheiten und wurde die erste Frau, die den Nobelpreis erhielt.",
               "Marie Curie erhielt 2 Nobelpreise (Physik 1903, Chemie 1911) trotz der Hindernisse als Frau im 19. Jahrhundert.", "👩‍🔬", 1),
        ]
        return pool
    }

    // MARK: - ARABIC ---------------------------------------------------------

    private static func arabicStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "الأسد والفأر",
                    body: "ذات يوم، كان **أسد** نائماً تحت شجرة. جرى **فأر** صغير فوق أنفه وأيقظه. غاضباً، كاد الأسد يأكله. قال الفأر: 'أرجوك اعفُ عني! يوماً ما سأردّ لك الجميل.' ضحك الأسد — هو يحتاج فأراً؟ — لكنه تركه يذهب. بعد أيام، وقع الأسد في **شبكة صيادين**. كان يزأر من الغضب عندما جاء الفأر، **قضم الحبال** وحرّره. الحكمة: **لا أحد صغير جداً على تقديم المساعدة**.",
                    narration: "هذه قصة عمرها ٢٥٠٠ عام — وحكمتها لا تزال صحيحة اليوم. استمع جيداً!"),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "نيل أرمسترونج: خطوة عملاقة",
                    body: "في **٢٠ يوليو ١٩٦٩**، حبس العالم أنفاسه. وطأ رائد الفضاء **نيل أرمسترونج** سطح القمر — كأول إنسان في التاريخ. قال: 'إنها **خطوة صغيرة** للإنسان، **قفزة عملاقة** للبشرية.' استغرقت المهمة ٨ أيام. على الأرض، تابع **٦٠٠ مليون** شخص الحدث على التلفاز. سُمّيت المركبة **أبولو ١١**.",
                    narration: "في عام ١٩٦٩، حقّقت البشرية المستحيل. سأحكي لك كيف وصل ثلاثة رواد فضاء شجعان إلى القمر."),
        ]
    }

    private static func arabicExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "من رسم لوحة الموناليزا؟",
               ["ليوناردو دافنشي", "مايكل أنجلو", "رافائيل", "بيكاسو"], "ليوناردو دافنشي",
               "رُسمت الموناليزا بين عامَي ١٥٠٣ و١٥١٩ على يد ليوناردو دافنشي. تُعرض في متحف اللوفر بباريس.", "🎨", 1),
            ex(.multipleChoice, "كم عدد القارات على كوكب الأرض؟",
               ["٥", "٦", "٧", "٨"], "٧",
               "القارات السبع هي: أفريقيا، القطب الجنوبي، أمريكا الشمالية، أمريكا الجنوبية، آسيا، أوروبا وأوقيانوسيا.", "🌍", 1),
            ex(.trueFalse, "الحوت الأزرق هو أكبر حيوان عُرف على وجه الأرض.",
               ["صحيح", "خطأ"], "صحيح",
               "يصل طول الحوت الأزرق إلى ٣٠ متراً ووزنه ١٨٠ طناً — أضخم من أي ديناصور!", "🐋", 1),
            ex(.multipleChoice, "أيُّ كوكب يُعرف بـ'الكوكب الأحمر'؟",
               ["المريخ", "المشتري", "الزهرة", "زحل"], "المريخ",
               "يكتسب المريخ لونه الأحمر من أكسيد الحديد (الصدأ) الذي يُغطي سطحه.", "🔴", 1),
            ex(.trueFalse, "للأخطبوط ثلاثة قلوب.",
               ["صحيح", "خطأ"], "صحيح",
               "للأخطبوط ٣ قلوب: قلب رئيسي وقلبان خيشوميان. وكذلك دمه أزرق!", "🐙", 2),
            ex(.multipleChoice, "ما أطول عظمة في جسم الإنسان؟",
               ["عظمة الفخذ", "عظمة الظنبوب", "عظمة الكعبرة", "عظمة العضد"], "عظمة الفخذ",
               "عظمة الفخذ هي أطول العظام وأقواها، وتستطيع تحمّل وزن سيارة!", "🦴", 2),
            ex(.oral, "اشرح بصوت عالٍ لماذا تعتقد أن ماري كوري نموذج ملهم.",
               [], "تجاوزت ماري كوري التمييز بين الجنسين لتصبح أول امرأة تفوز بجائزة نوبل.",
               "نالت ماري كوري جائزتَي نوبل (فيزياء ١٩٠٣، كيمياء ١٩١١) رغم العقبات التي واجهتها.", "👩‍🔬", 1),
        ]
        return pool
    }

    // MARK: - DUTCH ----------------------------------------------------------

    private static func dutchStories(level: CollegeLevel) -> [CollegeExercise] {
        [
            .lesson(subject: .culture, emoji: "🦁",
                    title: "De Leeuw en de Muis",
                    body: "Op een dag sliep een **leeuw** onder een boom. Een klein **muisje** rende over zijn neus en maakte hem wakker. Woedend wilde de leeuw hem opeten. 'Alsjeblieft, spaar me!' smeekte de muis. 'Ooit zal ik je helpen.' De leeuw lachte — hij, een muis nodig? — maar liet haar gaan. Dagen later viel de leeuw in een **jachtnet**. Hij brulde van woede toen de muis arriveerde, **de touwen doorknaagde** en hem bevrijdde. Moraal: **niemand is te klein om te helpen**.",
                    narration: "Dit verhaal is 2 500 jaar oud — en de les geldt nog steeds vandaag. Luister goed!"),
            .lesson(subject: .culture, emoji: "🚀",
                    title: "Neil Armstrong: Een Reuzensprong",
                    body: "Op **20 juli 1969** hield de wereld zijn adem in. Astronaut **Neil Armstrong** zette voet op de Maan — als eerste mens ooit. Hij zei: 'Dit is een **kleine stap** voor een mens, maar een **reuzensprong** voor de mensheid.' De missie duurde 8 dagen. Op Aarde keken **600 miljoen** mensen op tv. Het ruimteschip heette **Apollo 11**.",
                    narration: "In 1969 deed de mensheid het onmogelijke. Ik vertel je hoe drie moedige astronauten tot op de Maan kwamen."),
        ]
    }

    private static func dutchExercises(level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex(.multipleChoice, "Wie schilderde de Mona Lisa?",
               ["Leonardo da Vinci", "Michelangelo", "Rafaël", "Picasso"], "Leonardo da Vinci",
               "De Mona Lisa werd rond 1503–1519 geschilderd door Leonardo da Vinci. Ze hangt in het Louvre in Parijs.", "🎨", 1),
            ex(.multipleChoice, "Hoeveel continenten zijn er op Aarde?",
               ["5", "6", "7", "8"], "7",
               "De 7 continenten zijn: Afrika, Antarctica, Noord-Amerika, Zuid-Amerika, Azië, Europa en Oceanië.", "🌍", 1),
            ex(.trueFalse, "De blauwe vinvis is het grootste dier dat ooit op Aarde heeft geleefd.",
               ["Waar", "Onwaar"], "Waar",
               "De blauwe vinvis kan 30 m lang worden en 180 ton wegen — groter dan welke dinosauriër ook!", "🐋", 1),
            ex(.multipleChoice, "Welke planeet wordt de 'Rode Planeet' genoemd?",
               ["Mars", "Jupiter", "Venus", "Saturnus"], "Mars",
               "Mars dankt zijn rode kleur aan ijzeroxide (roest) dat het oppervlak bedekt.", "🔴", 1),
            ex(.trueFalse, "Octopussen hebben drie harten.",
               ["Waar", "Onwaar"], "Waar",
               "Octopussen hebben 3 harten: één hoofdhart en twee kieuwenharten. Ze hebben ook blauw bloed!", "🐙", 2),
            ex(.multipleChoice, "Wat is het langste bot in het menselijk lichaam?",
               ["Het dijbeen", "Het scheenbeen", "De spaak", "Het opperarmbeen"], "Het dijbeen",
               "Het dijbeen (femur) is het langste en sterkste bot. Het kan het gewicht van een auto dragen!", "🦴", 2),
            ex(.oral, "Leg hardop uit waarom jij denkt dat Marie Curie een inspirerend voorbeeld is.",
               [], "Marie Curie overwon genderongelijkheid en werd de eerste vrouw die de Nobelprijs won.",
               "Marie Curie ontving 2 Nobelprijzen (natuurkunde 1903, scheikunde 1911) ondanks de obstakels als vrouw.", "👩‍🔬", 1),
        ]
        return pool
    }
}
