import SwiftUI

// Central app state + seeded mockup data. No network, no chain, deterministic.
@Observable
final class AppState {
    var alerts: [AlertEvent] = MockData.alerts
    var entities: [TrackedEntity] = MockData.entities
    var plans: [SubscriptionPlan] = MockData.plans
    var pushEnabled = true
    var quietHours = false
    var selectedFeedFilter: AlertCategory = .all
    var selectedEntityKind: EntityKind = .wallet

    var filteredAlerts: [AlertEvent] {
        switch selectedFeedFilter {
        case .all: return alerts
        default: return alerts.filter { $0.category == selectedFeedFilter }
        }
    }

    func entities(of kind: EntityKind) -> [TrackedEntity] {
        entities.filter { $0.kind == kind }
    }
}

enum MockData {
    static let cEmerald = Palette.accent
    static let cBlue = Color(hex: 0x3B82F6)
    static let cPurple = Color(hex: 0x8B5CF6)
    static let cAmber = Color(hex: 0xF59E0B)
    static let cPink = Color(hex: 0xEC4899)

    static let alerts: [AlertEvent] = [
        AlertEvent(category: .whales, title: "Whale moved 1,200 ETH", amountUSD: "$4.1M", amountNative: "1,200 ETH",
                   entityName: "Vitalik.eth", entityMonogram: "V", avatarColor: cBlue, relativeTime: "12s ago",
                   thresholdTag: "Transfer > $1M", txHash: "0x9f2a...c41",
                   fromAddress: "0xd8dA...6045", toAddress: "0x2b6f...b45f", blockNumber: "20,412,889",
                   gasFee: "0.0021 ETH", direction: .outbound, unread: true),
        AlertEvent(category: .mints, title: "New mint: 5,000,000 PEPE", amountUSD: "$62.4K", amountNative: "5.0M PEPE",
                   entityName: "PEPE", entityMonogram: "P", avatarColor: cEmerald, relativeTime: "48s ago",
                   thresholdTag: "New mint", txHash: "0x71bd...a09", fromAddress: "0x0000...0000",
                   toAddress: "0x4a3c...9f21", blockNumber: "20,412,884", gasFee: "0.0009 ETH",
                   direction: .inbound, unread: true),
        AlertEvent(category: .transfers, title: "USDC transfer 2,400,000", amountUSD: "$2.4M", amountNative: "2.4M USDC",
                   entityName: "Uniswap V3", entityMonogram: "U", avatarColor: cPink, relativeTime: "2m ago",
                   thresholdTag: "Transfer > $1M", txHash: "0xa17c...4d2", fromAddress: "0x1f98...9f84",
                   toAddress: "0x8ba1...2c77", blockNumber: "20,412,871", gasFee: "0.0014 ETH",
                   direction: .outbound, unread: false),
        AlertEvent(category: .whales, title: "Whale added 480 WBTC", amountUSD: "$31.2M", amountNative: "480 WBTC",
                   entityName: "0x7a25...e9c", entityMonogram: "0x", avatarColor: cAmber, relativeTime: "6m ago",
                   thresholdTag: "Transfer > $10M", txHash: "0x33ef...b18", fromAddress: "0x28c6...11ab",
                   toAddress: "0x7a25...e9c1", blockNumber: "20,412,802", gasFee: "0.0031 ETH",
                   direction: .inbound, unread: false),
        AlertEvent(category: .transfers, title: "Blur bid 88 ETH", amountUSD: "$301K", amountNative: "88 ETH",
                   entityName: "Blur", entityMonogram: "B", avatarColor: cPurple, relativeTime: "11m ago",
                   thresholdTag: "Transfer > $100k", txHash: "0x5c02...7ff", fromAddress: "0x0000...dead",
                   toAddress: "0xb2ff...0c31", blockNumber: "20,412,744", gasFee: "0.0018 ETH",
                   direction: .outbound, unread: false),
    ]

    static func rule(_ cond: String, _ th: Double, _ dir: RuleDirection = .both,
                     transfers: Bool = true, mints: Bool = false, swaps: Bool = false, approvals: Bool = false) -> AlertRule {
        AlertRule(condition: cond, thresholdUSD: th, direction: dir,
                  transfers: transfers, mints: mints, swaps: swaps, approvals: approvals)
    }

    static let entities: [TrackedEntity] = [
        TrackedEntity(kind: .wallet, name: "Vitalik.eth", address: "0x2b6f...b45f", avatarColor: cBlue, monogram: "V",
                      balanceUSD: "$28.4M", alerts24h: 7,
                      rules: [rule("Transfer > $50,000", 50_000, .both), rule("Whale moves", 1_000_000, .outbound), rule("New mints", 0, .inbound, transfers: false, mints: true)]),
        TrackedEntity(kind: .wallet, name: "0x7a25...e9c", address: "0x7a25...e9c1", avatarColor: cAmber, monogram: "0x",
                      balanceUSD: "$52.9M", alerts24h: 3, rules: [rule("Transfer > $1M", 1_000_000, .both)]),
        TrackedEntity(kind: .token, name: "USDC", address: "0xa0b8...eb48", avatarColor: cEmerald, monogram: "$",
                      balanceUSD: "$41.2B", alerts24h: 12, rules: [rule("Transfer > $1M", 1_000_000, .both), rule("New mints", 0, .inbound, transfers: false, mints: true)]),
        TrackedEntity(kind: .token, name: "PEPE", address: "0x6982...b933", avatarColor: cEmerald, monogram: "P",
                      balanceUSD: "$1.9B", alerts24h: 5, rules: [rule("New mints", 0, .inbound, transfers: false, mints: true)]),
        TrackedEntity(kind: .contract, name: "Uniswap V3", address: "0x1f98...9f84", avatarColor: cPink, monogram: "U",
                      balanceUSD: "$3.4B", alerts24h: 9, rules: [rule("Swaps > $500k", 500_000, .both, transfers: false, swaps: true)]),
    ]

    static let plans: [SubscriptionPlan] = [
        SubscriptionPlan(name: "Yearly", price: "$59.99", period: "/yr", subtitle: "then $59.99/yr", bestValue: true),
        SubscriptionPlan(name: "Monthly", price: "$9.99", period: "/mo", subtitle: "billed monthly", bestValue: false),
    ]
}
