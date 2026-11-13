//
//  SideRail.swift
//  ToioController
//

import SwiftUI

// MARK: - 色

enum Palette {
    static let rail = Color(hex: 0x00C8F4)
    static let railInk = Color(hex: 0x06323D)
    static let ink = Color(hex: 0x14262E)
    static let secondaryInk = Color(hex: 0x4A5A61)
    static let chevron = Color(hex: 0x8A979C)
    static let subtleBackground = Color(hex: 0xF5F8F9)
    static let border = Color(hex: 0xE3EAED)
    static let pad = Color(hex: 0xF4B400)
    static let padInk = Color(hex: 0x3A2A00)
    static let padBackground = Color(hex: 0xFFF8E1)
    static let action = Color(hex: 0x98BA42)
    static let actionInk = Color(hex: 0x1E2A0C)
    static let retry = Color(hex: 0xE3E8EA)
    static let connected = Color(hex: 0x1E9E5A)
    static let disconnected = Color(hex: 0x8A979C)
}

extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }
}

// MARK: - サイドレール付きの画面

/// レールの一番上に置くもの
enum RailTop {
    /// 前の画面に戻るボタン
    case back(label: String, action: () -> Void)
    /// 戻り先のない画面(最初の画面)。押せるものと誤解されないよう何も置かない
    case none
}

/// 左端にサイドレール、右側に内容を置く画面の共通レイアウト
struct RailScreen<Bottom: View, Content: View>: View {
    private let top: RailTop
    private let background: Color
    private let bottom: Bottom
    private let content: Content

    init(top: RailTop,
         background: Color = .white,
         @ViewBuilder bottom: () -> Bottom,
         @ViewBuilder content: () -> Content) {
        self.top = top
        self.background = background
        self.bottom = bottom()
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 24) {
            SideRail(top: top) { bottom }
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(.vertical, 12)
        .background(background.ignoresSafeArea())
    }
}

extension RailScreen where Bottom == EmptyView {
    init(top: RailTop, background: Color = .white, @ViewBuilder content: () -> Content) {
        self.init(top: top, background: background, bottom: { EmptyView() }, content: content)
    }
}

/// 左端の縦長のメニュー
struct SideRail<Bottom: View>: View {
    let top: RailTop
    @ViewBuilder let bottom: Bottom

    var body: some View {
        VStack {
            switch top {
            case let .back(label, action):
                RailButton(systemImage: "chevron.left", label: label, isHighlighted: true, onTap: action)
            case .none:
                EmptyView()
            }
            Spacer()
            VStack(spacing: 8) {
                bottom
            }
        }
        .padding(.vertical, 10)
        .frame(width: 68)
        .frame(maxHeight: .infinity)
        .background(Palette.rail, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}

/// サイドレールに置くアイコンボタン
struct RailButton: View {
    let systemImage: String
    let label: String
    var isHighlighted = false
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Palette.railInk)
                .frame(width: 48, height: 48)
                .background(isHighlighted ? Color.white.opacity(0.55) : Color.clear,
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

/// 内容エリアの見出し
struct RailTitle: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 22, weight: .heavy))
            .foregroundStyle(Palette.ink)
            .accessibilityAddTraits(.isHeader)
    }
}
