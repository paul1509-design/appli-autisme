import SwiftUI

enum CollegeScreen {
    case splash, onboarding, home, paywall
}

@MainActor
class CollegeAppState: ObservableObject {
    @Published var screen: CollegeScreen = .splash
    @Published var currentStudent: CollegeProfile?
}

struct CollegeRootView: View {
    @StateObject private var appState = CollegeAppState()
    @EnvironmentObject private var sub: CollegeSubscriptionService
    @EnvironmentObject private var dataStore: CollegeDataStore

    var body: some View {
        Group {
            switch appState.screen {
            case .splash:
                CollegeSplashView {
                    sub.checkSubscriptionStatus()
                    if sub.trialExpired && !sub.isSubscribed {
                        appState.screen = .paywall
                    } else if let existing = dataStore.students.first {
                        appState.currentStudent = existing
                        appState.screen = .home
                    } else {
                        appState.screen = .onboarding
                    }
                }
            case .onboarding:
                CollegeOnboardingView { profile in
                    appState.currentStudent = profile
                    appState.screen = .home
                }
                .environmentObject(sub)
                .environmentObject(appState)
                .environmentObject(dataStore)
            case .home:
                if let student = freshStudent() {
                    CollegeHomeView(student: student)
                        .environmentObject(appState)
                        .environmentObject(sub)
                        .environmentObject(dataStore)
                } else {
                    CollegeOnboardingView { profile in
                        appState.currentStudent = profile
                        appState.screen = .home
                    }
                    .environmentObject(sub)
                    .environmentObject(appState)
                    .environmentObject(dataStore)
                }
            case .paywall:
                CollegePaywallView()
                    .environmentObject(sub)
                    .environmentObject(appState)
            }
        }
        .onChange(of: sub.trialExpired) { expired in
            if expired && !sub.isSubscribed { appState.screen = .paywall }
        }
    }

    private func freshStudent() -> CollegeProfile? {
        if let id = appState.currentStudent?.id,
           let found = dataStore.students.first(where: { $0.id == id }) {
            return found
        }
        return dataStore.students.first
    }
}
