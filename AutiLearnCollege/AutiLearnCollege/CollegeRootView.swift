import SwiftUI
import SwiftData

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
    @StateObject private var sub = CollegeSubscriptionService()
    @Query private var students: [CollegeProfile]

    var body: some View {
        Group {
            switch appState.screen {
            case .splash:
                CollegeSplashView {
                    sub.checkSubscriptionStatus()
                    if sub.trialExpired && !sub.isSubscribed {
                        appState.screen = .paywall
                    } else if let existing = students.first {
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
            case .home:
                if let student = appState.currentStudent ?? students.first {
                    CollegeHomeView(student: student)
                        .environmentObject(appState)
                        .environmentObject(sub)
                } else {
                    CollegeOnboardingView { profile in
                        appState.currentStudent = profile
                        appState.screen = .home
                    }
                    .environmentObject(sub)
                    .environmentObject(appState)
                }
            case .paywall:
                CollegePaywallView()
                    .environmentObject(sub)
                    .environmentObject(appState)
            }
        }
        .onChange(of: sub.trialExpired) { _, expired in
            if expired && !sub.isSubscribed { appState.screen = .paywall }
        }
    }
}
