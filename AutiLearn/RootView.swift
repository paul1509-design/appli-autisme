import SwiftUI
import SwiftData

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var subscriptionService: SubscriptionService
    @Query private var children: [ChildProfile]

    var body: some View {
        Group {
            switch appState.currentScreen {
            case .splash:
                SplashView(onGetStarted: {
                    appState.hasSeenSplash = true
                    if children.isEmpty {
                        appState.currentScreen = .onboarding
                    } else if children.count == 1 {
                        appState.selectedChild = children.first
                        appState.currentScreen = .home
                    } else {
                        appState.currentScreen = .childSelector
                    }
                })
            case .onboarding:
                OnboardingView()
            case .childSelector:
                ChildSelectorView()
            case .home:
                if let child = appState.selectedChild ?? children.first {
                    HomeView(child: child)
                } else {
                    OnboardingView()
                }
            case .learning:
                if let child = appState.selectedChild ?? children.first {
                    LearningSessionView(child: child, moduleType: appState.selectedModule, language: appState.currentLanguage)
                } else {
                    OnboardingView()
                }
            case .parentDashboard:
                if let child = appState.selectedChild ?? children.first {
                    ParentDashboardView(child: child)
                } else {
                    OnboardingView()
                }
            case .paywall:
                PaywallView()
            }
        }
        .onAppear {
            // Splash shown once; après, on va direct au contenu
            guard appState.hasSeenSplash else { return }
            if children.isEmpty {
                appState.currentScreen = .onboarding
            } else if children.count == 1 {
                appState.selectedChild = children.first
                appState.currentScreen = .home
            } else {
                appState.currentScreen = .childSelector
            }
        }
    }
}
