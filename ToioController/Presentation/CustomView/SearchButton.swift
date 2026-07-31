//
//  SearchButton.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

@IBDesignable
class SearchButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttribute()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupAttribute()
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard state == .normal else {
            super.setTitle(title, for: state)
            return
        }
        var config = configuration ?? UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(
            title ?? "",
            attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 16.0)])
        )
        configuration = config
    }

    override var backgroundColor: UIColor? {
        get { layer.backgroundColor.map { UIColor(cgColor: $0) } }
        set { layer.backgroundColor = newValue?.cgColor }
    }

    private func setupAttribute() {
        layer.cornerRadius = frame.height / 6
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.backgroundColor = UIColor(appColor: .search).cgColor

        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        config.baseForegroundColor = .white
        config.attributedTitle = AttributedString(
            R.string.localizeString.connectionSearchbutton(),
            attributes: AttributeContainer([.font: UIFont.boldSystemFont(ofSize: 16.0)])
        )
        config.background.backgroundColor = .clear
        configuration = config
    }
}
