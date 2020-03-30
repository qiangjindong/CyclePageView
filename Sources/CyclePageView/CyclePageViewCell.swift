//
//  CyclePageViewCell.swift
//  CyclePageView
//
//  Created by QiangJindong on 2019/6/16.
//  Copyright © 2019 QiangJindong. All rights reserved.
//

import UIKit

open class CyclePageViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open lazy var textLabel: UILabel = {
        let label = UILabel()
        label.frame = contentView.bounds
        self.contentView.addSubview(label)
        return label
    }()
    
    open lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = contentView.bounds
        self.contentView.addSubview(imageView)
        return imageView
    }()
}
