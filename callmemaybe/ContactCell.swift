//
//  ContactCell.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 06/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit
import Stevia

class ContactCell: UITableViewCell {
    
    let userAvatar = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        configureLayout()
    }
    private func configureLayout() {
        subviews(userAvatar)
        userAvatar.right(21).centerVertically()
    }
}
