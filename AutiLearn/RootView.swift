import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var subscriptionService: SubscriptionService
    @EnvironmentObject private var dataStore: DataStore

    private func freshChild(for stored: ChildProfile?) -> ChildProfile? {
        guard let stored else { return nil }
        return dataStore.children.first(where: { $0.id == stored.id }) ?? stored
    }

    var body: some View {
        Group {
            switch appState.currentScreen {
            case .splash:
                SplashView(onGetStarted: {
                    appState.hasSeenSplash = true
                    let children = dataStore.children
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
                let child = freshChild(for: appState.selectedChild) ?? dataStore.children.first
                if let child {
                    HomeView(child: child)
                } else {
                    OnboardingView()
                }
            case .learning:
                let child = freshChild(for: appState.selectedChild) ?? dataStore.children.first
                if let child {
                    LearningSessionView(child: child, moduleType: appState.selectedModule, language: appState.currentLanguage)
                } else {
                    OnboardingView()
                }
            case .parentDashboard:
                let child = freshChild(for: appState.selectedChild) ?? dataStore.children.first
                if let child {
                    ParentDashboardView(child: child)
                } else {
                    OnboardingView()
                }
            case .paywall:
                PaywallView()
            }
        }
        .onAppear {
            guard appState.hasSeenSplash else { return }
            subscriptionService.checkSubscriptionStatus()
            if subscriptionService.trialExpired && !subscriptionService.isSubscribed {
                appState.currentScreen = .paywall
                return
            }
            let children = dataStore.children
            if children.isEmpty {
                appState.currentScreen = .onboarding
            } else if children.count == 1 {
                appState.selectedChild = children.first
                appState.currentScreen = .home
            } else {
                appState.currentScreen = .childSelector
            }
        }
        .onChange(of: subscriptionService.trialExpired) { expired in
            if expired && !subscriptionService.isSubscribed {
                appState.currentScreen = .paywall
            }
        }
    }
}
