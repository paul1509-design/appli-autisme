import SwiftUI
import SwiftData

enum AppScreen {
    case onboarding
    case childSelector
    case home
    case learning
    case parentDashboard
    case paywall
}

@MainActor
class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .home
    @Published var selectedChild: ChildProfile?
    @Published var currentLanguage: AppLanguage = .french
    @Published var isOnboardingComplete: Bool = false
    @Published var selectedModule: ModuleType = .vocabulary

    func selectChild(_ child: ChildProfile) {
        selectedChild = child
        currentScreen = .home
    }

    func completeOnboarding() {
        isOnboardingComplete = true
        currentScreen = .home
    }
}
