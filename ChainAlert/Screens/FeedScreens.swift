import SwiftUI

// Primary real-time feed of on-chain alerts (6). Shows the mandatory tab bar via MainShell.
struct FeedScreen: View {
    @Environment(AppState.self) private var app
    @State private var openAlert: AlertEvent?
    var body: some View {
        @Bindable var app = app
        VStack(spacing: 14) {
            ScreenHeader(title: "Feed", showLive: true)
            SegmentedPills(items: AlertCategory.allCases, label: { $0.rawValue }, selection: $app.selectedFeedFilter)
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(app.filteredAlerts) { alert in
                        AlertCard(alert: alert).onTapGesture { openAlert = alert }
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .padding(.horizontal, 20).padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
        .sheet(item: $openAlert) { AlertDetailScreen(alert: $0) }
    }
}

struct AlertCard: View {
    var alert: AlertEvent
    var body: some View {
        Card {
            HStack(alignment: .top, spacing: 12) {
                Avatar(monogram: alert.entityMonogram, color: alert.avatarColor)
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 6) {
                        Text(alert.title).font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                            .lineLimit(1)
                        if alert.unread { Circle().fill(Palette.accent).frame(width: 8, height: 8) }
                    }
                    HStack(spacing: 6) {
                        Text(alert.amountUSD).font(AppFont.inter(15, .bold)).monospacedDigit()
                            .foregroundStyle(alert.direction == .outbound ? Palette.negative : Palette.positive)
                        Text(alert.amountNative).caption()
                    }
                    HStack(spacing: 8) {
                        Text(alert.entityName).font(AppFont.caption).foregroundStyle(Palette.textSecondary)
                        Text("-").caption()
                        Text(alert.relativeTime).caption()
                    }
                    HStack(spacing: 8) {
                        TagChip(text: alert.thresholdTag)
                        Text(alert.txHash).font(AppFont.inter(12, .medium)).foregroundStyle(Palette.textSecondary)
                            .monospaced()
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
}

// Single alert detail (7). Presented modally, no tab bar.
struct AlertDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    var alert: AlertEvent
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            BackHeader(title: "Alert detail") { dismiss() }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Avatar(monogram: alert.entityMonogram, color: alert.avatarColor, size: 52)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(alert.title).font(AppFont.heading).foregroundStyle(Palette.textPrimary)
                            Text(alert.entityName).caption()
                        }
                    }
                    Card {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Amount").caption()
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(alert.amountUSD).font(AppFont.inter(28, .bold)).monospacedDigit()
                                    .foregroundStyle(alert.direction == .outbound ? Palette.negative : Palette.positive)
                                Text(alert.amountNative).font(AppFont.body).foregroundStyle(Palette.textSecondary)
                            }
                        }
                    }
                    Card {
                        VStack(spacing: 12) {
                            AddressRow(label: "From", value: alert.fromAddress)
                            Divider().background(Palette.border)
                            AddressRow(label: "To", value: alert.toAddress)
                        }
                    }
                    HStack { Text("Matched rule").caption(); Spacer(); TagChip(text: alert.thresholdTag) }
                    Card {
                        VStack(spacing: 12) {
                            MetaRow(label: "Block", value: alert.blockNumber)
                            Divider().background(Palette.border)
                            MetaRow(label: "Tx hash", value: alert.txHash)
                            Divider().background(Palette.border)
                            MetaRow(label: "Gas fee", value: alert.gasFee)
                        }
                    }
                    VStack(spacing: 10) {
                        SecondaryButton(title: "View on Etherscan")
                        Button("Mute this entity") {}
                            .font(AppFont.inter(15, .semibold)).foregroundStyle(Palette.negative)
                            .frame(maxWidth: .infinity).padding(.vertical, 6)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
    }
}

struct AddressRow: View {
    var label: String
    var value: String
    var body: some View {
        HStack {
            Text(label).caption()
            Spacer()
            Text(value).font(AppFont.inter(14, .semibold)).monospaced().foregroundStyle(Palette.textPrimary)
            Image(systemName: "doc.on.doc").font(.system(size: 13)).foregroundStyle(Palette.textSecondary)
        }
    }
}

struct MetaRow: View {
    var label: String
    var value: String
    var body: some View {
        HStack {
            Text(label).caption()
            Spacer()
            Text(value).font(AppFont.inter(14, .semibold)).monospacedDigit().foregroundStyle(Palette.textPrimary)
        }
    }
}
