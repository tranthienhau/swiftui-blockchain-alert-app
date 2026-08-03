import SwiftUI

// 4-step interactive onboarding flow. Each step is standalone so the screenshot
// harness can deep-link to it, and OnboardingFlow chains them for real use.
struct OnboardingFlow: View {
    @State private var step = 0
    var onFinish: () -> Void
    var body: some View {
        ZStack {
            switch step {
            case 0: OnboardingWelcome { step = 1 } onSkip: { onFinish() }
            case 1: OnboardingTrack { step = 2 }
            case 2: OnboardingRules { step = 3 }
            default: OnboardingNotifications { onFinish() } onSkip: { onFinish() }
            }
        }
        .animation(.easeInOut, value: step)
    }
}

private struct OnboardHero: View {
    var symbol: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(colors: [Palette.accentTint, Palette.background],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
            // Abstract node graph
            GeometryReader { geo in
                let pts = [CGPoint(x: 0.25, y: 0.30), CGPoint(x: 0.70, y: 0.22),
                           CGPoint(x: 0.50, y: 0.55), CGPoint(x: 0.30, y: 0.78),
                           CGPoint(x: 0.78, y: 0.70)]
                Path { p in
                    let a = pts.map { CGPoint(x: $0.x * geo.size.width, y: $0.y * geo.size.height) }
                    for i in 0..<a.count { for j in (i+1)..<a.count {
                        p.move(to: a[i]); p.addLine(to: a[j]) } }
                }.stroke(Palette.accent.opacity(0.25), lineWidth: 1.5)
                ForEach(0..<pts.count, id: \.self) { i in
                    Circle().fill(Palette.accent)
                        .frame(width: i == 2 ? 18 : 11, height: i == 2 ? 18 : 11)
                        .position(x: pts[i].x * geo.size.width, y: pts[i].y * geo.size.height)
                }
            }
            Image(systemName: symbol).font(.system(size: 52, weight: .semibold))
                .foregroundStyle(Palette.accent)
        }
        .frame(height: 300)
    }
}

private struct OnboardScaffold<Content: View>: View {
    var step: Int
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 24) {
            content
            Spacer()
            PageDots(index: step)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
    }
}

struct OnboardingWelcome: View {
    var onNext: () -> Void
    var onSkip: () -> Void
    var body: some View {
        OnboardScaffold(step: 0) {
            HStack { Spacer(); Button("Skip", action: onSkip)
                .font(AppFont.caption).foregroundStyle(Palette.textSecondary) }
            OnboardHero(symbol: "point.3.filled.connected.trianglepath.dotted")
            VStack(spacing: 12) {
                Text("Never miss an on-chain move").font(AppFont.largeTitle)
                    .multilineTextAlignment(.center).foregroundStyle(Palette.textPrimary)
                Text("Real-time alerts on wallets, tokens and contracts, delivered to your phone in under 2 seconds.")
                    .font(AppFont.body).multilineTextAlignment(.center)
                    .foregroundStyle(Palette.textSecondary)
            }
            PrimaryButton(title: "Get Started", action: onNext)
        }
    }
}

struct OnboardingTrack: View {
    var onNext: () -> Void
    var body: some View {
        OnboardScaffold(step: 1) {
            OnboardHero(symbol: "wallet.bifold.fill")
            VStack(spacing: 12) {
                Text("Track any wallet, token or contract").font(AppFont.heading)
                    .multilineTextAlignment(.center).foregroundStyle(Palette.textPrimary)
                Text("Follow the addresses that matter and let ChainAlert watch them around the clock.")
                    .font(AppFont.body).multilineTextAlignment(.center).foregroundStyle(Palette.textSecondary)
            }
            HStack(spacing: 8) {
                ForEach(["Vitalik.eth", "USDC", "Uniswap V3"], id: \.self) { TagChip(text: $0, color: Palette.accent) }
            }
            PrimaryButton(title: "Continue", action: onNext)
        }
    }
}

struct OnboardingRules: View {
    var onNext: () -> Void
    var body: some View {
        OnboardScaffold(step: 2) {
            OnboardHero(symbol: "slider.horizontal.3")
            VStack(spacing: 12) {
                Text("Set your own alert rules").font(AppFont.heading)
                    .multilineTextAlignment(.center).foregroundStyle(Palette.textPrimary)
                Text("Filter the noise. Only get pinged on the events that cross your thresholds.")
                    .font(AppFont.body).multilineTextAlignment(.center).foregroundStyle(Palette.textSecondary)
            }
            Card {
                HStack {
                    Image(systemName: "arrow.left.arrow.right").foregroundStyle(Palette.accent)
                    Text("Transfer > $50,000").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                    Spacer()
                    Toggle("", isOn: .constant(true)).labelsHidden().tint(Palette.accent)
                }
            }
            HStack(spacing: 8) {
                ForEach(["Large transfers", "New mints", "Whale moves"], id: \.self) { TagChip(text: $0, color: Palette.accent) }
            }
            PrimaryButton(title: "Continue", action: onNext)
        }
    }
}

struct OnboardingNotifications: View {
    var onNext: () -> Void
    var onSkip: () -> Void
    var body: some View {
        OnboardScaffold(step: 3) {
            OnboardHero(symbol: "bell.badge.fill")
            VStack(spacing: 12) {
                Text("Get alerts in under 2 seconds").font(AppFont.heading)
                    .multilineTextAlignment(.center).foregroundStyle(Palette.textPrimary)
                Text("Enable push notifications so nothing slips by while the market moves.")
                    .font(AppFont.body).multilineTextAlignment(.center).foregroundStyle(Palette.textSecondary)
            }
            // Mock iOS notification preview
            Card {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 9).fill(Palette.accent)
                        .frame(width: 34, height: 34)
                        .overlay(Image(systemName: "bell.fill").foregroundStyle(.white).font(.system(size: 16)))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ChainAlert").font(AppFont.inter(14, .semibold)).foregroundStyle(Palette.textPrimary)
                        Text("Whale moved 1,200 ETH ($4.1M)").font(AppFont.caption).foregroundStyle(Palette.textSecondary)
                    }
                    Spacer()
                    Text("now").caption()
                }
            }
            VStack(spacing: 10) {
                PrimaryButton(title: "Enable Notifications", action: onNext)
                Button("Not now", action: onSkip).font(AppFont.caption).foregroundStyle(Palette.textSecondary)
            }
        }
    }
}
