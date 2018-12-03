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
    var eventDate: UILabel!
    var eventFood: UILabel!
    let padding: CGFloat = 4
    let green = UIColor(red: 12/255, green: 105/255, blue: 92/255, alpha: 1.0)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        eventImageView = UIImageView(frame: .zero)
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        contentView.addSubview(eventImageView)
        
        eventName = UILabel()
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventName.textAlignment = .left
        eventName.font = UIFont(name: "Helvetica", size: 18)
        eventName.textColor = green
        eventName.layer.zPosition = 1
        contentView.addSubview(eventName)
        
        eventLocation = UILabel()
        eventLocation.translatesAutoresizingMaskIntoConstraints = false
        eventLocation.font = UIFont(name: "Helvetica", size: 15)
        eventLocation.textAlignment = .left
        eventLocation.layer.zPosition = 1
        contentView.addSubview(eventLocation)
        
        eventDate = UILabel()
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        eventDate.textAlignment = .left
        eventDate.font = UIFont(name: "Helvetica", size: 15)
        eventDate.layer.zPosition = 1
        contentView.addSubview(eventDate)
        
        eventFood = UILabel()
        eventFood.translatesAutoresizingMaskIntoConstraints = false
        eventFood.textColor = UIColor.lightGray
        eventFood.textAlignment = .left
        eventFood.font = UIFont(name: "Helvetica", size: 15)
        eventFood.layer.zPosition = 1
        contentView.addSubview(eventFood)
        
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 100),
            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            eventName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            eventName.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            eventName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        
        NSLayoutConstraint.activate([
            eventDate.topAnchor.constraint(equalTo: eventName.bottomAnchor, constant: 6),
            eventDate.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            eventDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        
        NSLayoutConstraint.activate([
            eventLocation.topAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: padding),
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
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        eventDate.text = dateFormatter.string(from: event.eventDate ?? Date(timeIntervalSince1970: 0))
        eventLocation.text = event.specificLocation
        eventFood.text = event.eventFood
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
