//
//  InformationView.swift
//  ToioController
//

import SwiftUI

struct InformationView: View {
    let items: [InformationData]
    var onBack: () -> Void = {}
    var onSelect: (InformationData) -> Void = { _ in }
    var onDownload: () -> Void = {}

    private var linkItems: [InformationData] {
        items.filter { if case .download = $0.type { return false } else { return true } }
    }

    private var downloadItem: InformationData? {
        items.first { if case .download = $0.type { return true } else { return false } }
    }

    var body: some View {
        RailScreen(top: .back(label: R.string.localizeString.commonBack(), action: onBack), background: Palette.subtleBackground) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    RailTitle(text: R.string.localizeString.navigationInformation())
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(linkItems.indices, id: \.self) { index in
                            InformationRow(item: linkItems[index]) {
                                onSelect(linkItems[index])
                            }
                        }
                    }
                    if let downloadItem {
                        DownloadCard(item: downloadItem, onDownload: onDownload)
                    }
                }
                .padding(.top, 6)
                .padding(.trailing, 4)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

private struct InformationRow: View {
    let item: InformationData
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            HStack(spacing: 12) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(item.iconColor)
                    .frame(width: 32, height: 32)
                    .background(item.iconBackground, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                Text(item.label)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Palette.ink)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Palette.chevron)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 54)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct DownloadCard: View {
    let item: InformationData
    let onDownload: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(Palette.ink)
                Text(item.label)
                    .font(.system(size: 12))
                    .foregroundStyle(Palette.secondaryInk)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button { onDownload() } label: {
                Text(R.string.localizeString.informationListToioUpdateButton())
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(Palette.railInk)
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .background(Palette.rail, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color(hex: 0xBFEFFB), lineWidth: 2))
    }
}

private extension InformationData {
    var iconColor: Color {
        switch tint {
        case .setting: return Color(hex: 0x7A5600)
        case .gamepad: return Color(hex: 0x2E3F99)
        case .toio: return Color(hex: 0x0B5D73)
        case .apps: return Color(hex: 0x3F5A0E)
        case .privacy: return Color(hex: 0x3E4C52)
        }
    }

    var iconBackground: Color {
        switch tint {
        case .setting: return Color(hex: 0xFDF0C7)
        case .gamepad: return Color(hex: 0xE5E9FB)
        case .toio: return Color(hex: 0xDDF6FD)
        case .apps: return Color(hex: 0xE9F2D2)
        case .privacy: return Color(hex: 0xEEF0F1)
        }
    }
}

#Preview(traits: .landscapeRight) {
    InformationView(items: [
        InformationData(label: "コントローラ設定", title: "設定", type: .normal, systemImage: "slider.horizontal.3", tint: .setting),
        InformationData(label: "toioについて", title: "toio", type: .webView(url: URL(string: "https://toio.io/")!), systemImage: "cube", tint: .toio),
        InformationData(label: "toio アップデートアプリの説明", title: "toio アップデートアプリ", type: .download, systemImage: "arrow.down.circle", tint: .toio),
    ])
}
