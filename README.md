# AutiLearn — iOS App
## Setup Xcode — Étape par étape

### 1. Créer le projet Xcode

1. Ouvre **Xcode** → "Create New Project"
2. Choisis **iOS → App**
3. Remplis :
   - **Product Name** : AutiLearn
   - **Team** : None (pour l'instant)
   - **Organization Identifier** : com.tonnom.autilearn
   - **Interface** : SwiftUI
   - **Storage** : SwiftData ✅
   - **Language** : Swift
4. Clique **Next** → choisis ton dossier de destination → **Create**

---

### 2. Remplacer les fichiers générés

Xcode génère automatiquement `ContentView.swift` et `AutiLearnApp.swift`.
**Remplace leur contenu** par les fichiers de ce projet :

```
AutiLearn/
├── App/
│   ├── AutiLearnApp.swift      → Remplace le .swift généré par Xcode
│   └── AppState.swift          → Nouveau fichier à créer
├── Models/
│   └── Models.swift
├── Views/
│   ├── RootView.swift
│   ├── MainTabView.swift
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Learning/
│   │   └── LearningSessionView.swift
│   └── Parent/
│       └── ParentDashboardView.swift
├── ViewModels/
│   └── LearningSessionVM.swift
└── Services/
    ├── Services.swift
    └── ContentLibrary.swift
```

**Pour ajouter un fichier dans Xcode :**
- Clic droit sur le dossier cible → "New File" → "Swift File"
- Copie/colle le contenu du fichier correspondant

---

### 3. Ajouter les couleurs (Assets.xcassets)

Dans Xcode, ouvre `Assets.xcassets` et ajoute ces couleurs :

| Nom                | Light Mode      | Dark Mode       |
|--------------------|-----------------|-----------------|
| backgroundSoft     | #F8F6FF         | #1A1A2E         |
| cardBackground     | #FFFFFF         | #252540         |
| textPrimary        | #1A1A2E         | #F0EFFF         |
| textSecondary      | #6B6B8A         | #9999BB         |
| borderLight        | #E8E6F5         | #3A3A5C         |
| accentPurple       | #7F77DD         | #9B94E8         |
| accentGreen        | #1D9E75         | #25C48F         |
| accentBlue         | #378ADD         | #5BA3F5         |
| accentOrange       | #EF9F27         | #F5B44D         |
| accentRed          | #E24B4A         | #F06160         |
| accentPink         | #D4537E         | #E87AA0         |
| accentYellow       | #F5D020         | #F7DB4F         |

**Comment ajouter une couleur :**
1. Clique sur `+` en bas du panneau Assets
2. "New Color Set"
3. Nomme-la exactement comme dans le tableau
4. Double-clique sur le carré blanc → entre le hex code

---

### 4. Permissions à ajouter (Info.plist)

Dans `Info.plist`, ajoute ces clés :

```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>AutiLearn utilise la reconnaissance vocale pour que votre enfant puisse répondre à voix haute.</string>

<key>NSMicrophoneUsageDescription</key>
<string>AutiLearn utilise le micro pour les exercices de diction et de lecture à voix haute.</string>
```

---

### 5. Tester sur simulateur

1. En haut à gauche de Xcode → choisis un simulateur iPhone 15 Pro
2. Clique sur ▶️ (bouton play)
3. L'app se compile et s'ouvre dans le simulateur

---

### 6. Prochaines étapes (Session 2)

- [ ] Intégrer RevenueCat SDK (via Swift Package Manager)
- [ ] Configurer les produits in-app dans App Store Connect
- [ ] Ajouter module Karaoké (AVAudioEngine)
- [ ] Ajouter module Dessin (PencilKit)
- [ ] Implémenter SFSpeechRecognizer (réponse vocale)
- [ ] Ajouter ARASAAC pictogrammes
- [ ] Localisation EN (Localizable.strings)
- [ ] Générer rapports PDF parents
- [ ] Préparer les screenshots App Store

---

### Aide rapide si erreur Xcode

**"Cannot find type 'X' in scope"** → Le fichier Swift n'a pas été ajouté au projet.
Solution : Clic droit dossier → Add Files to AutiLearn → sélectionne le fichier.

**"No such module 'X'"** → Dépendance manquante.
Solution : File → Add Package Dependencies.

**Build failed — erreur SwiftData** → Vérifie que le déploiement minimum est iOS 17+.
Solution : Project Settings → Deployment Info → iOS 17.0
