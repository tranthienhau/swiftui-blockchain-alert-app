import SwiftUI

// Mandatory 3-tab bar, identical across the three primary screens (DESIGN.md).
enum MainTab: Int, CaseIterable { case feed, tracked, settings
    var title: String { ["Feed", "Tracked", "Settings"][rawValue] }
    var icon: String { ["bell.fill", "eye.fill", "gearshape.fill"][rawValue] }
}

struct BottomTabBar: View {
    @Binding var selected: MainTab
    var body: some View {
        HStack {
            ForEach(MainTab.allCases, id: \.rawValue) { tab in
                let active = tab == selected
                Button { selected = tab } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon).font(.system(size: 20))
                        Text(tab.title).font(AppFont.inter(11, .medium))
                    }
                    .foregroundStyle(active ? Palette.accent : Palette.textSecondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 2)
        .background(
            Palette.surface
                .overlay(Rectangle().fill(Palette.border).frame(height: 1), alignment: .top)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// Emerald "Live" chip shown on streaming screens.
struct LiveChip: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Palette.accent).frame(width: 8, height: 8)
            Text("Live").font(AppFont.inter(13, .semibold)).foregroundStyle(Palette.accent)
        }
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(Palette.accentTint)
        .clipShape(Capsule())
    }
}

struct PrimaryButton: View {
    var title: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Text(title).font(AppFont.inter(16, .semibold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 15)
                .background(Palette.accent).clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    var title: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Text(title).font(AppFont.inter(16, .semibold)).foregroundStyle(Palette.textPrimary)
                .frame(maxWidth: .infinity).padding(.vertical, 15)
                .background(Palette.surface)
                .overlay(Capsule().stroke(Palette.border, lineWidth: 1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// Avatar disc with a monogram, used for entities and alert sources.
struct Avatar: View {
    var monogram: String
    var color: Color
    var size: CGFloat = 44
    var body: some View {
        Circle().fill(color.opacity(0.16))
            .frame(width: size, height: size)
            .overlay(
                Text(monogram).font(AppFont.inter(size * 0.36, .bold)).foregroundStyle(color)
            )
    }
}

struct TagChip: View {
    var text: String
    var color: Color = Palette.warning
    var body: some View {
        Text(text)
            .font(AppFont.inter(12, .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 9).padding(.vertical, 4)
            .background(color.opacity(0.14))
            .clipShape(Capsule())
    }
}

// Generic pill segmented control (feed filter, entity kind).
struct SegmentedPills<T: Hashable & Identifiable>: View {
    var items: [T]
    var label: (T) -> String
    @Binding var selection: T
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items) { item in
                    let active = item == selection
                    Text(label(item))
                        .font(AppFont.inter(14, .semibold))
                        .foregroundStyle(active ? .white : Palette.textSecondary)
                        .padding(.horizontal, 16).padding(.vertical, 9)
                        .background(active ? Palette.accent : Palette.surface)
                        .overlay(Capsule().stroke(active ? .clear : Palette.border, lineWidth: 1))
                        .clipShape(Capsule())
                        .onTapGesture { selection = item }
                }
            }
        }
    }
}

// Light near-white screen header with a bold title, optional live chip + trailing.
struct ScreenHeader<Trailing: View>: View {
    var title: String
    var showLive: Bool = false
    @ViewBuilder var trailing: Trailing
    var body: some View {
        HStack(alignment: .center) {
            Text(title).font(AppFont.largeTitle).foregroundStyle(Palette.textPrimary)
            if showLive { LiveChip() }
            Spacer()
            trailing
        }
    }
}

extension ScreenHeader where Trailing == EmptyView {
    init(title: String, showLive: Bool = false) {
        self.init(title: title, showLive: showLive) { EmptyView() }
    }
}

// Page dots for onboarding (step of 4).
struct PageDots: View {
    var index: Int
    var count: Int = 4
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { i in
                Capsule().fill(i == index ? Palette.accent : Palette.border)
                    .frame(width: i == index ? 22 : 8, height: 8)
            }
        }
    }
}
