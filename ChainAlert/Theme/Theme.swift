import SwiftUI

// ChainAlert design system, ported from the Stitch design (DESIGN.md).
// Bright fintech: near-white canvas, single vivid emerald accent, Inter type.
enum Palette {
    static let background = Color(hex: 0xF6F8FB)
    static let surface = Color(hex: 0xFFFFFF)
    static let accent = Color(hex: 0x0E9F6E)
    static let accentTint = Color(hex: 0xD9F5EA)
    static let positive = Color(hex: 0x0E9F6E)
    static let negative = Color(hex: 0xE5484D)
    static let warning = Color(hex: 0xF5A623)
    static let textPrimary = Color(hex: 0x0F172A)
    static let textSecondary = Color(hex: 0x64748B)
    static let border = Color(hex: 0xE6EAF0)
}

// Inter type scale from DESIGN.md. Uses the bundled static weights.
enum AppFont {
    static func inter(_ size: CGFloat, _ weight: Weight) -> Font {
        .custom(weight.psName, size: size)
    }
    enum Weight {
        case regular, medium, semibold, bold
        var psName: String {
            switch self {
            case .regular: return "Inter-Regular"
            case .medium: return "Inter-Medium"
            case .semibold: return "Inter-SemiBold"
            case .bold: return "Inter-Bold"
            }
        }
    }

    static let largeTitle = inter(28, .bold)
    static let heading = inter(22, .bold)
    static let cardTitle = inter(16, .semibold)
    static let body = inter(15, .regular)
    static let caption = inter(13, .medium)
    static let amount = inter(16, .semibold) // tabular numerals applied at use site
}

extension Text {
    func caption() -> some View { self.font(AppFont.caption).foregroundStyle(Palette.textSecondary) }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

// Reusable soft card container matching the design (16 radius, y2 blur12 shadow).
struct Card<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Palette.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color(hex: 0x0F172A).opacity(0.06), radius: 12, x: 0, y: 2)
    }
}
