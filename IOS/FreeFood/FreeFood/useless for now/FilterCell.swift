//
//  FilterCell.swift
//  FreeFood
//
//  Created by Wenyi Guo on 11/26/18.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell{
    var filter: UILabel!
    let myBlue = UIColor (red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted || isSelected ? myBlue: .white
            filter.textColor = isHighlighted || isSelected ? .white: myBlue
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        filter = UILabel()
        filter.translatesAutoresizingMaskIntoConstraints = false
        filter.textAlignment = .center
        filter.textColor = myBlue
        filter.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(filter)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            filter.topAnchor.constraint(equalTo: contentView.topAnchor),
            filter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            filter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filter.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        
        contentView.backgroundColor = .white
        super.updateConstraints()
    }
    
    func configure(for eachFilter: Filter){
        filter.text = eachFilter.filterName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

