//
//  DateCollectionViewCell.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/26.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    var days: UILabel!
    let myBlue = UIColor (red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted || isSelected ? myBlue: .white
            days.textColor = isHighlighted || isSelected ? .white: myBlue
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        days = UILabel()
        days.translatesAutoresizingMaskIntoConstraints = false
        days.textAlignment = .center
        days.textColor = myBlue
        days.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(days)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            days.topAnchor.constraint(equalTo: contentView.topAnchor),
            days.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            days.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            days.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        
        contentView.backgroundColor = .white
        super.updateConstraints()
    }
    
    func configure(for eachDay: Calendar){
        days.text = eachDay.dateName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
