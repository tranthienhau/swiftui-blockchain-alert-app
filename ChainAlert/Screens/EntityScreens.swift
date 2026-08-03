import SwiftUI

// Primary watchlist of tracked wallets/tokens/contracts (8).
struct TrackedEntitiesScreen: View {
    @Environment(AppState.self) private var app
    @State private var search = ""
    @State private var showAdd = false
    @State private var openEntity: TrackedEntity?
    var body: some View {
        @Bindable var app = app
        VStack(spacing: 14) {
            ScreenHeader(title: "Tracked") {
                Button { showAdd = true } label: {
                    Image(systemName: "plus").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                        .frame(width: 36, height: 36).background(Palette.accent).clipShape(Circle())
                }
            }
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(Palette.textSecondary)
                TextField("Search wallets, tokens, contracts", text: $search)
                    .font(AppFont.body)
            }
            .padding(.horizontal, 14).padding(.vertical, 11)
            .background(Palette.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.border, lineWidth: 1))

            SegmentedPills(items: EntityKind.allCases, label: { $0.rawValue }, selection: $app.selectedEntityKind)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(app.entities(of: app.selectedEntityKind)) { e in
                        EntityRow(entity: e).onTapGesture { openEntity = e }
                    }
                }
            }
        }
        .padding(.horizontal, 20).padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
        .sheet(isPresented: $showAdd) { AddEntityScreen() }
        .sheet(item: $openEntity) { EntityDetailScreen(entity: $0) }
    }
}

struct EntityRow: View {
    var entity: TrackedEntity
    var body: some View {
        Card {
            HStack(spacing: 12) {
                Avatar(monogram: entity.monogram, color: entity.avatarColor)
                VStack(alignment: .leading, spacing: 4) {
                    Text(entity.name).font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                    Text(entity.address).font(AppFont.inter(13, .medium)).monospaced()
                        .foregroundStyle(Palette.textSecondary)
                    HStack(spacing: 8) {
                        TagChip(text: "\(entity.rules.count) rules", color: Palette.accent)
                        if entity.alerts24h > 0 {
                            TagChip(text: "\(entity.alerts24h) alerts / 24h", color: Palette.warning)
                        }
                    }
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(Palette.textSecondary).font(.system(size: 13))
            }
        }
    }
}

// Add-entity modal (9).
struct AddEntityScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var kind: EntityKind = .wallet
    @State private var addr = ""
    @State private var starterRule = true
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Capsule().fill(Palette.border).frame(width: 40, height: 5)
                    .frame(maxWidth: .infinity)
            }
            Text("Track new entity").font(AppFont.heading).foregroundStyle(Palette.textPrimary)

            Text("Type").caption()
            SegmentedPills(items: EntityKind.allCases, label: { String($0.rawValue.dropLast()) }, selection: $kind)

            Text("Address or ENS").caption()
            HStack {
                TextField("0x... or name.eth", text: $addr).font(AppFont.body).monospaced()
            }
            .padding(.horizontal, 14).padding(.vertical, 13)
            .background(Palette.surface).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.border, lineWidth: 1))

            Text("Suggested").caption()
            HStack(spacing: 8) {
                ForEach(["Vitalik.eth", "PEPE", "Blur"], id: \.self) { s in
                    TagChip(text: s, color: Palette.accent).onTapGesture { addr = s }
                }
            }

            Card {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Starter rule").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                        Text("Alert on transfers > $100k").caption()
                    }
                    Spacer()
                    Toggle("", isOn: $starterRule).labelsHidden().tint(Palette.accent)
                }
            }
            Spacer()
            PrimaryButton(title: "Add to watchlist") { dismiss() }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
    }
}

// Entity detail with stats + rules preview (10).
struct EntityDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var app
    var entity: TrackedEntity
    @State private var openRules = false
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            BackHeader(title: "Entity") { dismiss() }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Avatar(monogram: entity.monogram, color: entity.avatarColor, size: 56)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(entity.name).font(AppFont.heading).foregroundStyle(Palette.textPrimary)
                            HStack(spacing: 6) {
                                Text(entity.address).font(AppFont.inter(13, .medium)).monospaced()
                                    .foregroundStyle(Palette.textSecondary)
                                Image(systemName: "doc.on.doc").font(.system(size: 12)).foregroundStyle(Palette.textSecondary)
                            }
                        }
                    }
                    Card {
                        HStack {
                            StatCell(value: entity.balanceUSD, label: "Balance")
                            Divider().frame(height: 34).background(Palette.border)
                            StatCell(value: "\(entity.alerts24h)", label: "24h alerts")
                            Divider().frame(height: 34).background(Palette.border)
                            StatCell(value: "\(entity.rules.count)", label: "Rules")
                        }
                    }
                    HStack {
                        Text("Recent alerts").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                        Spacer()
                    }
                    ForEach(app.alerts.prefix(2)) { AlertCard(alert: $0) }
                    HStack {
                        Text("Alert rules").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                        Spacer()
                        Button("Add rule") { openRules = true }
                            .font(AppFont.caption).foregroundStyle(Palette.accent)
                    }
                    ForEach(entity.rules) { RuleCardMini(rule: $0) }
                    Button("Remove from watchlist") {}
                        .font(AppFont.inter(15, .semibold)).foregroundStyle(Palette.negative)
                        .frame(maxWidth: .infinity).padding(.vertical, 6)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
        .sheet(isPresented: $openRules) { AlertRulesScreen(entity: entity) }
    }
}

struct StatCell: View {
    var value: String
    var label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(AppFont.inter(17, .bold)).monospacedDigit().foregroundStyle(Palette.textPrimary)
            Text(label).caption()
        }
        .frame(maxWidth: .infinity)
    }
}

struct RuleCardMini: View {
    var rule: AlertRule
    var body: some View {
        Card(padding: 14) {
            HStack {
                Image(systemName: "slider.horizontal.3").foregroundStyle(Palette.accent)
                Text(rule.condition).font(AppFont.body).foregroundStyle(Palette.textPrimary)
                Spacer()
                TagChip(text: rule.direction.rawValue, color: Palette.accent)
            }
        }
    }
}
