//
//  DirectionalPadDownButton.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/14.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

@IBDesignable
class DirectionalPadDownButton: UIButton {
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

    private func setupAttribute() {
        layer.cornerRadius = frame.height / 6
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        setTitle("▼", for: .normal)
        backgroundColor = UIColor(hex: "#F4B400")
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 40.0)
    }
}
