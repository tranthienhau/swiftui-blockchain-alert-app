import SwiftUI

// Configure threshold + filter rules for an entity (11).
struct AlertRulesScreen: View {
    @Environment(\.dismiss) private var dismiss
    var entity: TrackedEntity
    @State private var threshold: Double = 50_000
    @State private var direction: RuleDirection = .both
    @State private var transfers = true
    @State private var mints = false
    @State private var swaps = false
    @State private var approvals = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            BackHeader(title: "Alert rules") { dismiss() }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(entity.rules) { RuleCardMini(rule: $0) }

                    Text("New rule").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                    Card {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Event types").caption()
                            VStack(spacing: 10) {
                                RuleToggle(title: "Transfers", isOn: $transfers)
                                RuleToggle(title: "Mints", isOn: $mints)
                                RuleToggle(title: "Swaps", isOn: $swaps)
                                RuleToggle(title: "Approvals", isOn: $approvals)
                            }
                            Divider().background(Palette.border)
                            HStack {
                                Text("Threshold").caption()
                                Spacer()
                                Text("$\(Int(threshold).formatted(.number.grouping(.automatic).locale(Locale(identifier: "en_US"))))")
                                    .font(AppFont.inter(15, .bold)).monospacedDigit().foregroundStyle(Palette.accent)
                            }
                            Slider(value: $threshold, in: 1_000...1_000_000, step: 1_000).tint(Palette.accent)
                            Text("Direction").caption()
                            SegmentedPills(items: RuleDirection.allCases, label: { $0.rawValue }, selection: $direction)
                        }
                    }
                    Text("Swipe a rule left to delete.").caption()
                    PrimaryButton(title: "Save rule") { dismiss() }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
    }
}

struct RuleToggle: View {
    var title: String
    @Binding var isOn: Bool
    var body: some View {
        HStack {
            Text(title).font(AppFont.body).foregroundStyle(Palette.textPrimary)
            Spacer()
            Toggle("", isOn: $isOn).labelsHidden().tint(Palette.accent)
        }
    }
}

// Primary settings + account screen (12).
struct SettingsScreen: View {
    @Environment(AppState.self) private var app
    @State private var openSub = false
    var body: some View {
        @Bindable var app = app
        VStack(spacing: 16) {
            ScreenHeader(title: "Settings")
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Card {
                        HStack(spacing: 12) {
                            Avatar(monogram: "H", color: MockData.cBlue, size: 52)
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 8) {
                                    Text("Hau Tran").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                                    TagChip(text: "PRO", color: Palette.accent)
                                }
                                Text("hau@chainalert.app").caption()
                            }
                            Spacer()
                        }
                    }

                    SettingsSection(title: "Notifications") {
                        SettingsToggleRow(icon: "bell.fill", title: "Push alerts", isOn: $app.pushEnabled)
                        Divider().background(Palette.border)
                        SettingsToggleRow(icon: "moon.fill", title: "Quiet hours", isOn: $app.quietHours)
                    }

                    SettingsSection(title: "Subscription") {
                        SettingsNavRow(icon: "creditcard.fill", title: "Manage plan", value: "Pro Yearly") { openSub = true }
                    }

                    SettingsSection(title: "Data & streams") {
                        SettingsNavRow(icon: "antenna.radiowaves.left.and.right", title: "Connected", value: "Alchemy webhook")
                        Divider().background(Palette.border)
                        SettingsNavRow(icon: "arrow.clockwise", title: "Refresh watchlist", value: "00:00 UTC")
                    }

                    SettingsSection(title: "About") {
                        SettingsNavRow(icon: "paintbrush.fill", title: "Appearance", value: "Light")
                        Divider().background(Palette.border)
                        SettingsNavRow(icon: "info.circle.fill", title: "About", value: "v1.0")
                    }

                    Button("Sign out") {}
                        .font(AppFont.inter(15, .semibold)).foregroundStyle(Palette.negative)
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal, 20).padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
        .sheet(isPresented: $openSub) { SubscriptionManageScreen { openSub = false } }
    }
}

struct SettingsSection<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(AppFont.inter(13, .semibold)).foregroundStyle(Palette.textSecondary)
                .padding(.leading, 4)
            Card(padding: 4) {
                VStack(spacing: 0) { content }
            }
        }
    }
}

struct SettingsToggleRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool
    var body: some View {
        HStack(spacing: 12) {
            SettingsIcon(icon)
            Text(title).font(AppFont.body).foregroundStyle(Palette.textPrimary)
            Spacer()
            Toggle("", isOn: $isOn).labelsHidden().tint(Palette.accent)
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
    }
}

struct SettingsNavRow: View {
    var icon: String
    var title: String
    var value: String = ""
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                SettingsIcon(icon)
                Text(title).font(AppFont.body).foregroundStyle(Palette.textPrimary)
                Spacer()
                Text(value).caption()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Palette.textSecondary)
            }
            .padding(.horizontal, 12).padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

struct SettingsIcon: View {
    var name: String
    init(_ name: String) { self.name = name }
    var body: some View {
        Image(systemName: name).font(.system(size: 14)).foregroundStyle(Palette.accent)
            .frame(width: 30, height: 30).background(Palette.accentTint).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
