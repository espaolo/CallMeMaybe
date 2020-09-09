//
//  UserCallView.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 08/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import UIKit
import Stevia


class UserCallView: UIView {
    var imageview = UIImageView()
    var labelName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        imageview = UIImageView(frame: CGRect(x: 8, y: 50, width: 80, height: 80))
        labelName = UILabel(frame: CGRect(x: 8, y: 120, width: 150, height: 40))
        imageview.image = UIImage(named: "BlueAvatar")
        labelName.text = "Puppa Pupparini"
        labelName.font = UIFont.boldSystemFont(ofSize: 16.0)
        addSubview(imageview)
        addSubview(labelName)


    }
}
