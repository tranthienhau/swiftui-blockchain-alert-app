import SwiftUI

// Domain models for the blockchain alert app. Mockup data only, no live chain.
enum EntityKind: String, CaseIterable, Identifiable {
    case wallet = "Wallets"
    case token = "Tokens"
    case contract = "Contracts"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .wallet: return "wallet.bifold"
        case .token: return "circle.hexagongrid.fill"
        case .contract: return "doc.text.fill"
        }
    }
}

enum AlertCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case whales = "Whales"
    case mints = "Mints"
    case transfers = "Transfers"
    var id: String { rawValue }
}

enum RuleDirection: String, CaseIterable, Identifiable {
    case inbound = "In"
    case outbound = "Out"
    case both = "Both"
    var id: String { rawValue }
}

struct TrackedEntity: Identifiable {
    let id = UUID()
    var kind: EntityKind
    var name: String
    var address: String        // 0x2b6...45f
    var avatarColor: Color
    var monogram: String
    var balanceUSD: String      // "$28.4M"
    var alerts24h: Int
    var rules: [AlertRule]
}

struct AlertRule: Identifiable {
    let id = UUID()
    var condition: String       // "Transfer > $50,000"
    var thresholdUSD: Double
    var direction: RuleDirection
    var transfers: Bool
    var mints: Bool
    var swaps: Bool
    var approvals: Bool
}

struct AlertEvent: Identifiable {
    let id = UUID()
    var category: AlertCategory
    var title: String           // "Whale moved 1,200 ETH"
    var amountUSD: String       // "$4.1M"
    var amountNative: String    // "1,200 ETH"
    var entityName: String      // "Vitalik.eth"
    var entityMonogram: String
    var avatarColor: Color
    var relativeTime: String    // "12s ago"
    var thresholdTag: String    // "Transfer > $1M"
    var txHash: String          // "0x9f2a...c41"
    var fromAddress: String
    var toAddress: String
    var blockNumber: String
    var gasFee: String
    var direction: RuleDirection
    var unread: Bool
}

struct SubscriptionPlan: Identifiable {
    let id = UUID()
    var name: String            // "Yearly"
    var price: String           // "$59.99"
    var period: String          // "/yr"
    var subtitle: String        // "then $59.99/yr"
    var bestValue: Bool
}
