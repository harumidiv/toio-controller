//
//  ConnectView.swift
//  ToioController
//

import Lottie
import SwiftUI

/// 接続画面の状態
enum ConnectPhase {
    /// 最初の状態(cubeを探す)
    case idle
    /// 検索中
    case scanning
    /// タイムアウトやエラーの後(もう一度探す)
    case retry
}

@Observable
final class ConnectViewState {
    var phase: ConnectPhase = .idle
}

struct ConnectView: View {
    let state: ConnectViewState
    var onSearch: () -> Void = {}
    var onInformation: () -> Void = {}

    var body: some View {
        RailScreen(top: .mark) {
            RailButton(systemImage: "info.circle", label: R.string.localizeString.navigationInformation(), onTap: onInformation)
        } content: {
            HStack(spacing: 48) {
                indicator
                VStack(alignment: .leading, spacing: 14) {
                    RailTitle(text: R.string.localizeString.navigationbarConnection())
                    Text(description)
                        .font(.system(size: 15))
                        .foregroundStyle(Palette.secondaryInk)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                    searchButton
                        .padding(.top, 8)
                }
                .frame(maxWidth: 320, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var description: String {
        state.phase == .scanning
            ? R.string.localizeString.connectionDescriotionScanning()
            : R.string.localizeString.connectionDescriptionPrev()
    }

    /// 検索中はLottieの波紋アニメーション、それ以外はcubeのイラスト
    private var indicator: some View {
        ZStack {
            if state.phase == .scanning {
                LottieView(animation: .named("448-ripple-loading-animation"))
                    .playing(loopMode: .loop)
                    .resizable()
            } else {
                Circle().stroke(Color(hex: 0xBFEFFB), lineWidth: 2)
                Circle().stroke(Color(hex: 0x7FDDF6), lineWidth: 2).padding(36)
                Circle().fill(Color(hex: 0xDDF6FD)).padding(72)
                Image(systemName: "cube")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(Color(hex: 0x0B6E87))
            }
        }
        .frame(width: 230, height: 230)
        .accessibilityHidden(true)
    }

    @ViewBuilder private var searchButton: some View {
        if state.phase != .scanning {
            Button { onSearch() } label: {
                Label(state.phase == .retry
                    ? R.string.localizeString.connectionButtonRescan()
                    : R.string.localizeString.connectionSearchbutton(),
                    systemImage: "magnifyingglass")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(state.phase == .retry ? Palette.ink : Palette.actionInk)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(state.phase == .retry ? Palette.retry : Palette.action, in: Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview(traits: .landscapeRight) {
    ConnectView(state: ConnectViewState())
}
