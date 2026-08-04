import SwiftUI

@main
struct ChainAlertApp: App {
    @State private var app = AppState()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(app)
                .tint(Palette.accent)
        }
    }
}

// App phases. Onboarding -> paywall -> main tabs.
enum AppPhase { case onboarding, paywall, main }

struct RootView: View {
    @State private var phase: AppPhase = .onboarding

    var body: some View {
        // The screenshot harness deep-links to any screen via `-SCREEN <key>`
        // passed as a launch argument (read here as a UserDefaults value).
        if UserDefaults.standard.bool(forKey: "DEMO") {
            DemoTour()
        } else if let key = UserDefaults.standard.string(forKey: "SCREEN"), !key.isEmpty {
            ScreenRouter(key: key)
        } else {
            switch phase {
            case .onboarding: OnboardingFlow { phase = .paywall }
            case .paywall: PaywallScreen { phase = .main }
            case .main: MainShell()
            }
        }
    }
}

// Mandatory 3-tab shell. Only the three primary screens show the bottom bar.
struct MainShell: View {
    @State private var tab: MainTab = .feed
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tab {
                case .feed: FeedScreen()
                case .tracked: TrackedEntitiesScreen()
                case .settings: SettingsScreen()
                }
            }
            BottomTabBar(selected: $tab)
        }
        .background(Palette.background)
    }
}

// Direct routes for the screenshot harness. Keys match the design screen names.
struct ScreenRouter: View {
    @Environment(AppState.self) private var app
    var key: String
    var body: some View {
        switch key {
        case "01-onboarding-welcome": OnboardingWelcome(onNext: {}, onSkip: {})
        case "02-onboarding-track": OnboardingTrack(onNext: {})
        case "03-onboarding-rules": OnboardingRules(onNext: {})
        case "04-onboarding-notifications": OnboardingNotifications(onNext: {}, onSkip: {})
        case "05-paywall": PaywallScreen()
        case "06-feed": tabbed(.feed)
        case "07-alert-detail": AlertDetailScreen(alert: app.alerts[0])
        case "08-tracked-entities": tabbed(.tracked)
        case "09-add-entity": AddEntityScreen()
        case "10-entity-detail": EntityDetailScreen(entity: app.entities[0])
        case "11-alert-rules": AlertRulesScreen(entity: app.entities[0])
        case "12-settings": tabbed(.settings)
        case "13-subscription-manage": SubscriptionManageScreen()
        default: MainShell()
        }
    }

    // Renders a primary screen with the mandatory tab bar pinned to a given tab.
    @ViewBuilder func tabbed(_ t: MainTab) -> some View {
        VStack(spacing: 0) {
            Group {
                switch t {
                case .feed: FeedScreen()
                case .tracked: TrackedEntitiesScreen()
                case .settings: SettingsScreen()
                }
            }
            BottomTabBar(selected: .constant(t))
        }
        .background(Palette.background)
    }
}

// Auto-advancing tour used only to record the demo GIF (`-DEMO YES`).
struct DemoTour: View {
    @Environment(AppState.self) private var app
    @State private var i = 0
    private let keys = ["01-onboarding-welcome", "02-onboarding-track", "05-paywall",
                        "06-feed", "07-alert-detail", "08-tracked-entities",
                        "10-entity-detail", "11-alert-rules", "12-settings"]
    var body: some View {
        ScreenRouter(key: keys[i])
            .transition(.opacity)
            .id(i)
            .task {
                while true {
                    try? await Task.sleep(nanoseconds: 1_400_000_000)
                    withAnimation(.easeInOut(duration: 0.35)) { i = (i + 1) % keys.count }
                }
            }
    }
}
