//
//  SettingView.swift
//  ToioController
//

import SwiftUI

/// 十字キーの各方向のスピード(0〜100%)
struct SpeedSetting: Equatable {
    var up: Int
    var down: Int
    var left: Int
    var right: Int
}

struct SettingView: View {
    let title: String
    @State var speed: SpeedSetting
    var onBack: () -> Void = {}
    var onSave: (SpeedSetting) -> Void = { _ in }

    var body: some View {
        RailScreen(top: .back(label: R.string.localizeString.commonBack(), action: onBack)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 14) {
                    RailTitle(text: title)
                    Text(R.string.localizeString.settingDescription())
                        .font(.system(size: 12))
                        .foregroundStyle(Palette.secondaryInk)
                }
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        SpeedCard(direction: .up, value: $speed.up)
                        SpeedCard(direction: .down, value: $speed.down)
                    }
                    GridRow {
                        SpeedCard(direction: .left, value: $speed.left)
                        SpeedCard(direction: .right, value: $speed.right)
                    }
                }
                HStack {
                    Spacer()
                    Button {
                        onSave(speed)
                    } label: {
                        Text(R.string.localizeString.settingButtonTitle())
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundStyle(Palette.actionInk)
                            .padding(.horizontal, 32)
                            .frame(height: 52)
                            .background(Palette.action, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 6)
            .padding(.trailing, 4)
        }
    }
}

private struct SpeedCard: View {
    let direction: ControlDirection
    @Binding var value: Int

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: direction.settingSymbol)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Palette.padInk)
                    .frame(width: 36, height: 36)
                    .background(Palette.pad, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .accessibilityHidden(true)
                Text(direction.settingLabel)
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(Palette.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(value)%")
                    .font(.system(size: 18, weight: .heavy))
                    .monospacedDigit()
                    .foregroundStyle(Palette.ink)
            }
            Slider(value: Binding(get: { Double(value) }, set: { value = Int($0) }), in: 0 ... 100)
                .tint(Palette.pad)
                .accessibilityLabel(direction.settingLabel)
                .accessibilityValue("\(value)%")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.padBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private extension ControlDirection {
    var settingSymbol: String {
        switch self {
        case .up: return "arrowtriangle.up.fill"
        case .down: return "arrowtriangle.down.fill"
        case .left: return "arrowtriangle.left.fill"
        case .right: return "arrowtriangle.right.fill"
        }
    }

    var settingLabel: String {
        switch self {
        case .up: return R.string.localizeString.controllerDirectionUp()
        case .down: return R.string.localizeString.controllerDirectionDown()
        case .left: return R.string.localizeString.controllerDirectionLeft()
        case .right: return R.string.localizeString.controllerDirectionRight()
        }
    }
}

#Preview(traits: .landscapeRight) {
    SettingView(title: "設定", speed: SpeedSetting(up: 60, down: 60, left: 60, right: 60))
}
