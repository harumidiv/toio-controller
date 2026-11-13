//
//  ControlView.swift
//  ToioController
//

import SwiftUI

enum ControlDirection: CaseIterable {
    case up, down, left, right
}

enum ControlAction: CaseIterable {
    case back, horn, spin, zigzag
}

/// 画面の表示状態。ControlViewControllerが更新する
@Observable
final class ControlViewState {
    /// 押している最中のアクション。押している間は他のボタンを無効にする
    var activeAction: ControlAction?
    /// ゲームコントローラ(Dualshock等)が端末に接続されているか
    var isGamepadConnected = false
}

/// コントローラ画面。押した/離したタイミングをコールバックで通知する
struct ControlView: View {
    let state: ControlViewState
    var onDirection: (ControlDirection, _ isPressed: Bool) -> Void = { _, _ in }
    var onAction: (ControlAction, _ isPressed: Bool) -> Void = { _, _ in }
    var onBack: () -> Void = {}
    var onGamepad: () -> Void = {}
    var onSettings: () -> Void = {}

    var body: some View {
        RailScreen(top: .back(label: R.string.localizeString.controllerRailBack(), action: onBack)) {
            railItems
        } content: {
            GeometryReader { geometry in
                // 十字キー + 間隔16 + アクション2列(直径×2 + 間隔14)が幅に収まる大きさにする
                // 直径 = (padSide - 14) / 2 なので、合計幅は padSide * 2 + 16
                let padSide = min(geometry.size.height, 300, (geometry.size.width - 16) / 2)
                HStack {
                    DirectionPad(side: padSide, isDisabled: state.activeAction != nil, onDirection: onDirection)
                    Spacer(minLength: 16)
                    actionGrid(height: padSide)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }

    // MARK: - サイドレール

    @ViewBuilder private var railItems: some View {
        RailButton(systemImage: state.isGamepadConnected ? "gamecontroller.fill" : "gamecontroller",
                   label: state.isGamepadConnected
                       ? R.string.localizeString.controllerRailGamepadConnected()
                       : R.string.localizeString.controllerRailGamepadDisconnected(),
                   onTap: onGamepad)
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(state.isGamepadConnected ? Palette.connected : Palette.disconnected)
                    .frame(width: 9, height: 9)
                    .overlay(Circle().stroke(Palette.rail, lineWidth: 2))
                    .offset(x: -8, y: 8)
                    .accessibilityHidden(true)
            }
        RailButton(systemImage: "slider.horizontal.3", label: R.string.localizeString.informationListControllerSetting(), onTap: onSettings)
    }

    // MARK: - アクションボタン

    private func actionGrid(height: CGFloat) -> some View {
        let spacing: CGFloat = 14
        // 2段で十字キーと同じ高さに収まる直径の正円にする
        let diameter = min((height - spacing) / 2, 130)
        let columns = [GridItem(.fixed(diameter), spacing: spacing), GridItem(.fixed(diameter), spacing: spacing)]
        return LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(ControlAction.allCases, id: \.self) { action in
                ActionButton(action: action, diameter: diameter) { isPressed in
                    onAction(action, isPressed)
                }
                .disabled(state.activeAction != nil && state.activeAction != action)
            }
        }
        .frame(width: diameter * 2 + spacing)
    }
}

// MARK: - 押している間を通知するボタンスタイル

/// 指が触れた時にtrue、離れた時(ボタン外で離した・キャンセルも含む)にfalseを通知する
struct PressReportingButtonStyle: ButtonStyle {
    let onPressChanged: (Bool) -> Void

    func makeBody(configuration: Configuration) -> some View {
        PressReportingBody(configuration: configuration, onPressChanged: onPressChanged)
    }

    private struct PressReportingBody: View {
        let configuration: Configuration
        let onPressChanged: (Bool) -> Void

        var body: some View {
            // 無効時の見た目は各ボタンが色を切り替えて表す(透過すると背景とアイコンが重なって色ムラになるため)
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
                .onChange(of: configuration.isPressed) { _, isPressed in
                    onPressChanged(isPressed)
                }
        }
    }
}

// MARK: - 部品

private struct DirectionPad: View {
    let side: CGFloat
    let isDisabled: Bool
    let onDirection: (ControlDirection, Bool) -> Void

    var body: some View {
        // 端数があるとマスの間に細いすき間が見えるので、整数に丸める
        let cell = (side / 3).rounded(.down)
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                Color.clear.frame(width: cell, height: cell)
                key(.up, cell: cell)
                Color.clear.frame(width: cell, height: cell)
            }
            GridRow {
                key(.left, cell: cell)
                padColor.frame(width: cell, height: cell)
                key(.right, cell: cell)
            }
            GridRow {
                Color.clear.frame(width: cell, height: cell)
                key(.down, cell: cell)
                Color.clear.frame(width: cell, height: cell)
            }
        }
        .frame(width: side, height: side)
        .animation(.easeOut(duration: 0.12), value: isDisabled)
    }

    private var padColor: Color { isDisabled ? Palette.disabled : Palette.pad }

    private func key(_ direction: ControlDirection, cell: CGFloat) -> some View {
        Button {} label: {
            Image(systemName: direction.systemImage)
                .font(.system(size: cell * 0.34, weight: .bold))
                .foregroundStyle(isDisabled ? Palette.disabledInk : Palette.padInk)
                .frame(width: cell, height: cell)
                .background(padColor, in: UnevenRoundedRectangle(cornerRadii: direction.cornerRadii(cell * 0.22), style: .continuous))
        }
        .buttonStyle(PressReportingButtonStyle { onDirection(direction, $0) })
        .disabled(isDisabled)
        .accessibilityLabel(direction.label)
    }
}

private struct ActionButton: View {
    let action: ControlAction
    let diameter: CGFloat
    let onPressChanged: (Bool) -> Void
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {} label: {
            VStack(spacing: 6) {
                action.icon
                    .frame(width: 34, height: 34)
                Text(action.label)
                    .font(.system(size: 13, weight: .heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(isEnabled ? Palette.actionInk : Palette.disabledInk)
            .frame(width: diameter, height: diameter)
            .background(isEnabled ? Palette.action : Palette.disabled, in: Circle())
            .contentShape(Circle())
            .animation(.easeOut(duration: 0.12), value: isEnabled)
        }
        .buttonStyle(PressReportingButtonStyle(onPressChanged: onPressChanged))
    }
}

/// ジグザグのアイコン(対応するSF Symbolが無いため描画する)
private struct ZigzagShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points: [(CGFloat, CGFloat)] = [(3, 17), (8, 7), (12, 17), (16, 7), (21, 17)]
        for (index, point) in points.enumerated() {
            let p = CGPoint(x: rect.minX + rect.width * point.0 / 24, y: rect.minY + rect.height * point.1 / 24)
            index == 0 ? path.move(to: p) : path.addLine(to: p)
        }
        return path
    }
}

private extension ControlDirection {
    var systemImage: String {
        switch self {
        case .up: return "arrowtriangle.up.fill"
        case .down: return "arrowtriangle.down.fill"
        case .left: return "arrowtriangle.left.fill"
        case .right: return "arrowtriangle.right.fill"
        }
    }

    var label: String {
        switch self {
        case .up: return R.string.localizeString.controllerDirectionUp()
        case .down: return R.string.localizeString.controllerDirectionDown()
        case .left: return R.string.localizeString.controllerDirectionLeft()
        case .right: return R.string.localizeString.controllerDirectionRight()
        }
    }

    /// 十字の外側だけ角を丸める
    func cornerRadii(_ r: CGFloat) -> RectangleCornerRadii {
        switch self {
        case .up: return RectangleCornerRadii(topLeading: r, topTrailing: r)
        case .down: return RectangleCornerRadii(bottomLeading: r, bottomTrailing: r)
        case .left: return RectangleCornerRadii(topLeading: r, bottomLeading: r)
        case .right: return RectangleCornerRadii(bottomTrailing: r, topTrailing: r)
        }
    }
}

private extension ControlAction {
    var label: String {
        switch self {
        case .back: return R.string.localizeString.controllerActionBack()
        case .horn: return R.string.localizeString.controllerActionHorn()
        case .spin: return R.string.localizeString.controllerActionSpin()
        case .zigzag: return R.string.localizeString.controllerActionZigzag()
        }
    }

    @ViewBuilder var icon: some View {
        switch self {
        case .back:
            Image(systemName: "arrow.uturn.backward").font(.system(size: 28, weight: .bold))
        case .horn:
            Image(systemName: "speaker.wave.2.fill").font(.system(size: 26, weight: .bold))
        case .spin:
            Image(systemName: "arrow.clockwise").font(.system(size: 28, weight: .bold))
        case .zigzag:
            ZigzagShape()
                .stroke(style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
        }
    }
}

#Preview(traits: .landscapeRight) {
    ControlView(state: ControlViewState())
}

#Preview("アクション中", traits: .landscapeRight) {
    let state = ControlViewState()
    state.activeAction = .spin
    return ControlView(state: state)
}
