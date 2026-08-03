import SwiftUI

// RevenueCat-style paywall shown after onboarding, before the app.
struct PaywallScreen: View {
    @Environment(AppState.self) private var app
    @State private var selected = 0
    var onContinue: () -> Void = {}
    let benefits = ["Unlimited tracked entities", "Real-time sub-2s alerts", "Custom threshold rules", "Priority push delivery"]

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 18).fill(Palette.accentTint)
                    .frame(width: 66, height: 66)
                    .overlay(Image(systemName: "bolt.fill").font(.system(size: 28)).foregroundStyle(Palette.accent))
                Text("Start your 7-day free trial").font(AppFont.heading)
                    .multilineTextAlignment(.center).foregroundStyle(Palette.textPrimary)
                Text("Full access to ChainAlert Pro. Cancel anytime.")
                    .font(AppFont.body).foregroundStyle(Palette.textSecondary)
            }
            .padding(.top, 20)

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(benefits, id: \.self) { b in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(Palette.accent)
                            Text(b).font(AppFont.body).foregroundStyle(Palette.textPrimary)
                        }
                    }
                }
            }

            VStack(spacing: 12) {
                ForEach(Array(app.plans.enumerated()), id: \.element.id) { i, plan in
                    PlanCard(plan: plan, selected: selected == i).onTapGesture { selected = i }
                }
            }

            Spacer()
            VStack(spacing: 10) {
                PrimaryButton(title: "Start Free Trial", action: onContinue)
                Text("then \(app.plans[selected].price)\(app.plans[selected].period) - auto-renews")
                    .font(AppFont.inter(12, .medium)).foregroundStyle(Palette.textSecondary)
                HStack(spacing: 18) {
                    Button("Restore Purchases") {}
                    Button("Terms") {}
                }
                .font(AppFont.caption).foregroundStyle(Palette.textSecondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
    }
}

struct PlanCard: View {
    var plan: SubscriptionPlan
    var selected: Bool
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                .font(.system(size: 22)).foregroundStyle(selected ? Palette.accent : Palette.border)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(plan.name).font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                    if plan.bestValue { TagChip(text: "Best value", color: Palette.accent) }
                }
                Text(plan.subtitle).caption()
            }
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(plan.price).font(AppFont.inter(20, .bold)).monospacedDigit()
                Text(plan.period).font(AppFont.caption)
            }
            .foregroundStyle(Palette.textPrimary)
        }
        .padding(16)
        .background(selected ? Palette.accentTint.opacity(0.5) : Palette.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(selected ? Palette.accent : Palette.border, lineWidth: selected ? 2 : 1))
    }
}

// Manage RevenueCat subscription (13).
struct SubscriptionManageScreen: View {
    @Environment(AppState.self) private var app
    var onBack: () -> Void = {}
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            BackHeader(title: "Subscription", onBack: onBack)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Card {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Pro Yearly").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                                Spacer(); TagChip(text: "Active", color: Palette.accent)
                            }
                            Text("Renews Feb 12, 2027").caption()
                            Divider().background(Palette.border)
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("$59.99").font(AppFont.inter(24, .bold)).monospacedDigit()
                                    .foregroundStyle(Palette.textPrimary)
                                Text("/yr").caption()
                            }
                        }
                    }
                    Text("Change plan").font(AppFont.cardTitle).foregroundStyle(Palette.textPrimary)
                    ForEach(app.plans) { plan in
                        PlanCard(plan: plan, selected: plan.name == "Yearly")
                    }
                    VStack(spacing: 12) {
                        SecondaryButton(title: "Restore Purchases")
                        Button("Cancel subscription") {}
                            .font(AppFont.inter(15, .semibold)).foregroundStyle(Palette.negative)
                            .frame(maxWidth: .infinity).padding(.vertical, 6)
                    }
                    Text("Billing is managed by the App Store.").caption().frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.background)
    }
}

// Back header used by modal/detail screens (no tab bar on these).
struct BackHeader: View {
    var title: String
    var onBack: () -> Void = {}
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image(systemName: "chevron.left").font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Palette.textPrimary)
            }
            Text(title).font(AppFont.heading).foregroundStyle(Palette.textPrimary)
            Spacer()
        }
    }
}
