//
//  StoreDownloadCell.swift
//  ToioController
//
//  Created by 佐川 晴海 on 2020/05/24.
//  Copyright © 2020 佐川晴海. All rights reserved.
//

import UIKit

class StoreDownloadCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var appDescription: UILabel!

    func setup(title: String, description: String) {
        self.title.text = title
        appDescription.text = description
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
