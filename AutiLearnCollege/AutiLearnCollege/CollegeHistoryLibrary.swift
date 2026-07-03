import Foundation

// MARK: - Histoire par pays — programmes scolaires localisés
struct CollegeHistoryLibrary {

    static func exercises(level: CollegeLevel, language: CollegeLanguage) -> [CollegeExercise] {
        switch language {
        case .french:     return french(level)
        case .english:    return english(level)
        case .spanish:    return spanish(level)
        case .portuguese: return portuguese(level)
        case .italian:    return italian(level)
        case .german:     return german(level)
        case .arabic:     return arabic(level)
        case .dutch:      return dutch(level)
        }
    }

    private static func ex(_ q: String, _ choices: [String], _ answer: String,
                            _ explanation: String, _ emoji: String, _ diff: Int) -> CollegeExercise {
        CollegeExercise(subject: .histoire,
                        mode: choices.isEmpty ? .shortAnswer : (choices.count == 2 && (choices.contains("Vrai") || choices.contains("True") || choices.contains("Verdad")) ? .trueFalse : .multipleChoice),
                        question: q, choices: choices, correctAnswer: answer,
                        explanation: explanation, emoji: emoji, difficulty: diff)
    }

    // MARK: - 🇫🇷 France
    private static func french(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("La Révolution française a eu lieu en :", ["1789", "1815", "1848", "1870"], "1789",
               "La Révolution française débute le 14 juillet 1789 avec la prise de la Bastille.", "🗼", 1),
            ex("Quel est le plus grand pays du monde ?", ["Russie", "Canada", "Chine", "USA"], "Russie",
               "La Russie s'étend sur 17 millions de km², elle est la plus grande du monde.", "🌍", 1),
            ex("Charlemagne a été couronné empereur en :", ["800", "987", "1066", "732"], "800",
               "Charlemagne est couronné le 25 décembre 800 par le pape Léon III à Rome.", "👑", 1),
            ex("En quelle année a débuté la Première Guerre mondiale ?", ["1914", "1918", "1939", "1905"], "1914",
               "La Grande Guerre (1914-1918) débute après l'assassinat de François-Ferdinand à Sarajevo.", "🏛️", 2),
            ex("La Déclaration des droits de l'homme date de :", ["1789", "1792", "1804", "1815"], "1789",
               "La DDHC est adoptée par l'Assemblée nationale le 26 août 1789.", "📜", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Le mur de Berlin est tombé en :", ["1989", "1979", "1991", "1985"], "1989",
                   "Le mur de Berlin tombe le 9 novembre 1989, symbolisant la fin de la Guerre froide.", "🧱", 2),
                ex("Cite deux causes de la Seconde Guerre mondiale.", [], "Montée du nazisme / Crise de 1929 / Traité de Versailles",
                   "Le traité de Versailles humiliant, la crise économique et la montée du nazisme sont les causes majeures.", "📜", 3),
                ex("Napoléon Bonaparte a été exilé à :", ["Sainte-Hélène", "l'île d'Elbe (2e exil)", "Corse", "Waterloo"], "Sainte-Hélène",
                   "Après Waterloo (1815), Napoléon est exilé à Sainte-Hélène où il meurt en 1821.", "⚔️", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("La décolonisation africaine s'est principalement déroulée dans les années :", ["1950-1970", "1920-1930", "1900-1910", "1980-1990"], "1950-1970",
                   "Les années 1950-1960 voient une vague d'indépendances africaines, dont l'Algérie en 1962.", "🌍", 3),
                ex("Cite deux enjeux géopolitiques majeurs du XXIe siècle.", [], "Réchauffement climatique / Montée de la Chine / Terrorisme",
                   "Le changement climatique, la rivalité USA-Chine et les crises sanitaires définissent notre époque.", "🌐", 3),
                ex("La Ve République française a été fondée en :", ["1958", "1946", "1944", "1968"], "1958",
                   "La Ve République est créée par de Gaulle en 1958, avec une nouvelle Constitution renforçant l'exécutif.", "🇫🇷", 2),
            ]
        }
        return pool
    }

    // MARK: - 🇬🇧 United Kingdom
    private static func english(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("When was the Magna Carta signed?", ["1215", "1066", "1348", "1509"], "1215",
               "The Magna Carta (1215) limited the king's power and is a foundation of British constitutional law.", "📜", 1),
            ex("The Norman Conquest of England took place in:", ["1066", "1215", "1348", "1485"], "1066",
               "William the Conqueror defeated Harold II at the Battle of Hastings on 14 October 1066.", "⚔️", 1),
            ex("True or False: The Black Death killed about a third of Europe's population.", ["True", "False"], "True",
               "The Black Death (1347-1351) killed an estimated 30-50% of Europe's population.", "🐀", 2),
            ex("Who was the first Tudor monarch?", ["Henry VII", "Henry VIII", "Elizabeth I", "Edward VI"], "Henry VII",
               "Henry VII became king after defeating Richard III at Bosworth Field in 1485.", "👑", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("In what year did World War I begin?", ["1914", "1939", "1918", "1905"], "1914",
                   "WWI began in 1914 after the assassination of Archduke Franz Ferdinand in Sarajevo.", "🏛️", 2),
                ex("The Battle of Britain took place in:", ["1940", "1939", "1941", "1944"], "1940",
                   "The Battle of Britain (summer 1940) was a key air campaign in which the RAF defended the UK against the Luftwaffe.", "✈️", 2),
                ex("Name two causes of World War II.", [], "Rise of Nazi Germany / Great Depression / Treaty of Versailles",
                   "The harsh terms of Versailles, economic depression and the rise of fascism led to WWII.", "📜", 3),
                ex("The Berlin Wall fell in:", ["1989", "1979", "1991", "1985"], "1989",
                   "The Berlin Wall fell on 9 November 1989, ending the Cold War division of Europe.", "🧱", 2),
            ]
        }
        if level.isLycee {
            pool += [
                ex("When did India gain independence from Britain?", ["1947", "1956", "1939", "1960"], "1947",
                   "India gained independence on 15 August 1947, partitioned into India and Pakistan.", "🇮🇳", 3),
                ex("What was the significance of the 1973 oil crisis?", [], "OPEC embargo caused energy shortages, recession, end of post-war boom",
                   "The 1973 OPEC oil embargo triggered inflation, recession and transformed global energy policy.", "🛢️", 3),
                ex("Brexit referendum took place in:", ["2016", "2019", "2020", "2015"], "2016",
                   "The UK voted 52% to 48% to leave the EU on 23 June 2016.", "🇬🇧", 2),
            ]
        }
        return pool
    }

    // MARK: - 🇪🇸 España
    private static func spanish(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("¿En qué año llegó Colón a América?", ["1492", "1516", "1478", "1588"], "1492",
               "Cristóbal Colón llegó a América el 12 de octubre de 1492, financiado por los Reyes Católicos.", "⛵", 1),
            ex("¿Qué fue la Reconquista?", ["La recuperación de la Península Ibérica del dominio musulmán", "Una cruzada en Tierra Santa", "La conquista de América", "Una guerra civil"], "La recuperación de la Península Ibérica del dominio musulmán",
               "La Reconquista (718-1492) fue el proceso por el que los reinos cristianos recuperaron la Península Ibérica.", "🏰", 1),
            ex("¿En qué año se expulsaron los judíos de España?", ["1492", "1478", "1516", "1588"], "1492",
               "El Edicto de Granada (1492) de los Reyes Católicos expulsó a los judíos de España.", "📜", 2),
            ex("¿Cuándo fue la Armada Invencible derrotada?", ["1588", "1492", "1519", "1605"], "1588",
               "La Armada Invencible fue derrotada por Inglaterra en 1588, iniciando el declive del poder español.", "⚓", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("¿Cuándo comenzó la Guerra Civil Española?", ["1936", "1931", "1939", "1923"], "1936",
                   "La Guerra Civil Española comenzó el 18 de julio de 1936 con el levantamiento militar de Franco.", "⚔️", 2),
                ex("¿Quién fue Francisco Franco?", ["Dictador de España (1939-1975)", "Presidente democrático", "Rey de España", "General republicano"], "Dictador de España (1939-1975)",
                   "Francisco Franco gobernó España como dictador desde el fin de la Guerra Civil hasta su muerte en 1975.", "🎖️", 3),
                ex("La Constitución española democrática se aprobó en:", ["1978", "1975", "1931", "1982"], "1978",
                   "La Constitución de 1978 estableció la democracia parlamentaria tras la muerte de Franco.", "📜", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("¿Cuándo ingresó España en la Unión Europea?", ["1986", "1975", "1992", "1999"], "1986",
                   "España ingresó en la Comunidad Económica Europea el 1 de enero de 1986.", "🇪🇺", 2),
                ex("Cita dos consecuencias del colonialismo español en América.", [], "Mestizaje / Evangelización / Explotación de recursos / Enfermedades",
                   "El colonialismo español generó mestizaje cultural, evangelización forzada y explotación de recursos.", "🌎", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇵🇹 Portugal
    private static func portuguese(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Quem foi Vasco da Gama?", ["O navegador que descobriu a rota marítima para a Índia", "Um rei português", "Um explorador espanhol", "Um pirata famoso"], "O navegador que descobriu a rota marítima para a Índia",
               "Vasco da Gama chegou à Índia em 1498, abrindo a rota marítima para o Oriente.", "⛵", 1),
            ex("Em que ano ocorreu a Revolução dos Cravos?", ["1974", "1968", "1926", "1910"], "1974",
               "A Revolução dos Cravos (25 de abril de 1974) pôs fim à ditadura do Estado Novo.", "🌸", 1),
            ex("Pedro Álvares Cabral chegou ao Brasil em:", ["1500", "1492", "1519", "1488"], "1500",
               "Pedro Álvares Cabral chegou ao Brasil em 22 de abril de 1500, reivindicando o território para Portugal.", "🌊", 2),
            ex("A ditadura de Salazar durou aproximadamente:", ["40 anos", "10 anos", "20 anos", "5 anos"], "40 anos",
               "António de Oliveira Salazar governou Portugal de 1932 a 1968, num total de cerca de 40 anos.", "🏛️", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Portugal aderiu à CEE (atual UE) em:", ["1986", "1974", "1992", "1999"], "1986",
                   "Portugal aderiu à Comunidade Económica Europeia em 1986, juntamente com a Espanha.", "🇪🇺", 2),
                ex("O que foi o Tratado de Tordesilhas?", ["Um acordo entre Portugal e Espanha para dividir o mundo", "Um tratado de paz europeu", "Uma aliança militar", "Um acordo comercial com a Índia"], "Um acordo entre Portugal e Espanha para dividir o mundo",
                   "O Tratado de Tordesilhas (1494) dividiu o mundo colonial entre Portugal e Espanha.", "🗺️", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇮🇹 Italia
    private static func italian(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Cosa fu il Rinascimento?", ["Un periodo di fioritura artistica e culturale (XIV-XVI sec.)", "Una guerra medievale", "Una rivoluzione politica", "Una dinastia reale"], "Un periodo di fioritura artistica e culturale (XIV-XVI sec.)",
               "Il Rinascimento (XIV-XVI sec.) fu un movimento culturale e artistico che ebbe origine in Italia.", "🎨", 1),
            ex("Chi dipinse la Cappella Sistina?", ["Michelangelo", "Leonardo da Vinci", "Raffaello", "Botticelli"], "Michelangelo",
               "Michelangelo dipinse la volta della Cappella Sistina tra il 1508 e il 1512.", "🖌️", 1),
            ex("Il Risorgimento italiano portò all'unificazione nel:", ["1861", "1848", "1815", "1871"], "1861",
               "Il Regno d'Italia fu proclamato il 17 marzo 1861 con Vittorio Emanuele II come primo re.", "🇮🇹", 2),
            ex("Chi fu Benito Mussolini?", ["Il fondatore del fascismo e dittatore d'Italia (1922-1943)", "Un re d'Italia", "Un generale della Prima Guerra Mondiale", "Un politico democratico"], "Il fondatore del fascismo e dittatore d'Italia (1922-1943)",
               "Mussolini fondò il Partito Fascista e governò l'Italia come duce dal 1922 al 1943.", "🎖️", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("L'Italia è diventata una Repubblica nel:", ["1946", "1948", "1943", "1922"], "1946",
                   "Il referendum del 2 giugno 1946 decise la forma repubblicana dell'Italia.", "🗳️", 2),
                ex("Cita due conseguenze della Seconda Guerra Mondiale per l'Italia.", [], "Perdita di territori / Fine della monarchia / Piano Marshall / Costituzione 1948",
                   "L'Italia perse territori, divenne Repubblica, ricevette aiuti dal Piano Marshall e adottò la Costituzione nel 1948.", "📜", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇩🇪 Deutschland
    private static func german(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Wann begann die Reformation in Deutschland?", ["1517", "1648", "1415", "1555"], "1517",
               "Martin Luther veröffentlichte 1517 seine 95 Thesen und leitete damit die Reformation ein.", "⛪", 1),
            ex("Wann wurde das Deutsche Reich gegründet?", ["1871", "1848", "1815", "1866"], "1871",
               "Das Deutsche Reich wurde am 18. Januar 1871 im Spiegelsaal von Versailles ausgerufen.", "🇩🇪", 1),
            ex("Wann begann der Erste Weltkrieg?", ["1914", "1939", "1918", "1905"], "1914",
               "Der Erste Weltkrieg begann 1914 nach dem Attentat auf Erzherzog Franz Ferdinand.", "🏛️", 2),
            ex("Adolf Hitler wurde Reichskanzler im Jahr:", ["1933", "1939", "1929", "1936"], "1933",
               "Hitler wurde am 30. Januar 1933 Reichskanzler und errichtete die nationalsozialistische Diktatur.", "📜", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Wann fiel die Berliner Mauer?", ["1989", "1991", "1979", "1985"], "1989",
                   "Die Berliner Mauer fiel am 9. November 1989 und symbolisierte das Ende des Kalten Krieges.", "🧱", 2),
                ex("Die Wiedervereinigung Deutschlands fand statt im:", ["1990", "1989", "1991", "1992"], "1990",
                   "Die deutsche Wiedervereinigung erfolgte offiziell am 3. Oktober 1990.", "🇩🇪", 2),
                ex("Nenne zwei Ursachen des Zweiten Weltkriegs.", [], "Aufstieg des Nationalsozialismus / Weltwirtschaftskrise / Versailler Vertrag",
                   "Der Vertrag von Versailles, die Weltwirtschaftskrise und der Aufstieg der NSDAP führten zum Krieg.", "📜", 3),
            ]
        }
        if level.isLycee {
            pool += [
                ex("Was ist das Grundgesetz?", ["Die Verfassung der Bundesrepublik Deutschland (1949)", "Ein Schulgesetz", "Ein Handelsvertrag", "Eine Verfassung der DDR"], "Die Verfassung der Bundesrepublik Deutschland (1949)",
                   "Das Grundgesetz (1949) ist die Verfassung Deutschlands und Grundlage der demokratischen Ordnung.", "📋", 2),
            ]
        }
        return pool
    }

    // MARK: - 🇸🇦 العالم العربي
    private static func arabic(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("متى بدأ الإسلام؟", ["في القرن السابع الميلادي (610 م)", "في القرن الخامس", "في القرن الثامن", "في القرن العاشر"], "في القرن السابع الميلادي (610 م)",
               "بدأ الإسلام بنزول الوحي على النبي محمد ﷺ عام 610 م في غار حراء بمكة المكرمة.", "🕌", 1),
            ex("ما هي عاصمة الخلافة العباسية؟", ["بغداد", "دمشق", "القاهرة", "مكة"], "بغداد",
               "بغداد أسسها الخليفة المنصور عام 762 م وكانت مركز العلم والحضارة الإسلامية.", "🏛️", 1),
            ex("من فتح مصر للعرب؟", ["عمرو بن العاص", "خالد بن الوليد", "أبو بكر الصديق", "صلاح الدين"], "عمرو بن العاص",
               "فتح عمرو بن العاص مصر بين عامَي 639 و641 م في عهد الخليفة عمر بن الخطاب.", "⚔️", 2),
            ex("متى كانت معركة حطين؟", ["1187", "1099", "1258", "1453"], "1187",
               "في معركة حطين (1187م) انتصر صلاح الدين الأيوبي على الصليبيين واستعاد القدس.", "🏰", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("متى سقطت الخلافة العثمانية؟", ["1924", "1918", "1908", "1945"], "1924",
                   "ألغى مصطفى كمال أتاتورك الخلافة العثمانية في مارس 1924 وأعلن الجمهورية التركية.", "🗺️", 2),
                ex("اذكر نتيجتين للاستعمار الأوروبي في العالم العربي.", [], "تفتيت الوحدة العربية / رسم حدود اصطناعية / استغلال الموارد / نشر اللغات الأوروبية",
                   "خلّف الاستعمار حدوداً اصطناعية وتبعية اقتصادية وصراعات لا تزال مستمرة.", "📜", 3),
            ]
        }
        return pool
    }

    // MARK: - 🇳🇱 Nederland
    private static func dutch(_ level: CollegeLevel) -> [CollegeExercise] {
        var pool: [CollegeExercise] = [
            ex("Wanneer was de Gouden Eeuw van Nederland?", ["17e eeuw", "16e eeuw", "18e eeuw", "15e eeuw"], "17e eeuw",
               "De Gouden Eeuw (17e eeuw) was een periode van grote welvaart, kunst en handelsexpansie voor Nederland.", "🌟", 1),
            ex("Wat was de VOC?", ["De Vereenigde Oost-Indische Compagnie — eerste multinational ter wereld", "Een militaire vloot", "Een politieke partij", "Een kunstverzameling"], "De Vereenigde Oost-Indische Compagnie — eerste multinational ter wereld",
               "De VOC (1602) was 's werelds eerste naamloze vennootschap en domineerde de Aziatische handel.", "⛵", 1),
            ex("Wanneer werd Nederland onafhankelijk van Spanje?", ["1648", "1588", "1515", "1700"], "1648",
               "De Vrede van Münster (1648) erkende officieel de onafhankelijkheid van de Republiek der Zeven Verenigde Nederlanden.", "📜", 2),
            ex("Wanneer was de bevrijding van Nederland in WOII?", ["1945", "1944", "1943", "1940"], "1945",
               "Nederland werd in mei 1945 bevrijd door geallieerde troepen, na vijf jaar Duitse bezetting.", "🌷", 2),
        ]
        if level.rawValue >= CollegeLevel.quatrieme.rawValue {
            pool += [
                ex("Wanneer trad Nederland toe tot de EEG?", ["1957", "1973", "1945", "1986"], "1957",
                   "Nederland was een van de zes oprichtende leden van de EEG bij het Verdrag van Rome (1957).", "🇪🇺", 2),
                ex("Noem twee gevolgen van de Nederlandse kolonisatie.", [], "Handel en welvaart / Slavernij / Culturele uitwisseling / Verlies inheemse culturen",
                   "De Nederlandse kolonisatie bracht welvaart via handel maar ook slavernij en onderdrukking van inheemse volken.", "🌍", 3),
            ]
        }
        return pool
    }
}
