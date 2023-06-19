//
//  TypeCollectionViewCell.swift
//  Pods
//
//  Created by 韩倩云 on 2022/9/28.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
