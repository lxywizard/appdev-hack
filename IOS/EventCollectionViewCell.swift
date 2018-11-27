//
//  EventCollectionViewCell.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/25.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    var eventImageView: UIImageView!
    var eventName: UILabel!
    var eventLocation: UILabel!
    var eventTime: UILabel!
    var eventFood: UILabel!
    let padding: CGFloat = 4
    //var whiteLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        eventImageView = UIImageView(frame: .zero)
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.contentMode = .scaleAspectFill
        contentView.addSubview(eventImageView)
        
        eventName = UILabel()
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventName.textAlignment = .left
        eventName.font = .systemFont(ofSize: 16, weight: .bold)
        eventName.layer.zPosition = 1
        contentView.addSubview(eventName)
        
        eventLocation = UILabel()
        eventLocation.translatesAutoresizingMaskIntoConstraints = false
        eventLocation.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        eventLocation.textAlignment = .left
        eventLocation.layer.zPosition = 1
        contentView.addSubview(eventLocation)
        
        eventTime = UILabel()
        eventTime.translatesAutoresizingMaskIntoConstraints = false
        eventTime.textAlignment = .left
        eventTime.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        eventTime.layer.zPosition = 1
        contentView.addSubview(eventTime)
        
        eventFood = UILabel()
        eventFood.translatesAutoresizingMaskIntoConstraints = false
        eventFood.textColor = UIColor.lightGray
        eventFood.textAlignment = .left
        eventFood.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        eventFood.layer.zPosition = 1
        contentView.addSubview(eventFood)
        
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 90),
            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            eventName.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventName.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            eventName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        
        NSLayoutConstraint.activate([
            eventTime.topAnchor.constraint(equalTo: eventName.bottomAnchor, constant: padding),
            eventTime.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            eventTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        
        NSLayoutConstraint.activate([
            eventLocation.topAnchor.constraint(equalTo: eventTime.bottomAnchor, constant: padding),
            eventLocation.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            eventLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        
        NSLayoutConstraint.activate([
            eventFood.topAnchor.constraint(equalTo: eventLocation.bottomAnchor, constant: padding),
            eventFood.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            eventFood.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        
        contentView.backgroundColor = .white
        super.updateConstraints()
    }
    
    func configure(for event: Event){
        eventImageView.image = UIImage(named: event.eventImgName)
        eventName.text = event.eventName
        eventTime.text = event.eventTime
        eventLocation.text = event.eventLocation
        eventFood.text = event.eventFood
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
