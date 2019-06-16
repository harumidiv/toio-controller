//
//  RoundButton.swift
//  ToioController
//
//  Created by 佐川晴海 on 2019/06/16.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
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
        layer.cornerRadius = frame.width / 2
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundColor = UIColor(appColor: .search)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 50.0)
    }
}
