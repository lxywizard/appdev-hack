//
//  detailViewController.swift
//  FreeFood
//
//  Created by Wenyi Guo on 11/26/18.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var indexSelected: Int!
    var eventImageView: UIImageView!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var locationLabel: UILabel!
    var menuLabel: UILabel!
    var menu: UITextView!
    var eventDetailLabel: UILabel!
    var eventDetail: UITextView!
    
    let padding = CGFloat(8)
    
    weak var delegate: detailDelegate?
    
    init(indexPass: Int!){
        indexSelected = indexPass
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Details"
        
        eventImageView = UIImageView()
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.image = UIImage(named: (delegate?.getImageName(index: indexSelected))!)
        view.addSubview(eventImageView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.text = delegate?.getName(index: indexSelected)
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(nameLabel)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        timeLabel.text = ""
        let timeArray = delegate?.getTime(index: indexSelected)
        let timeSize = timeArray?.count
        if (timeSize! > 0){
            for index in 0..<(timeSize! - 1){
                timeLabel.text = timeLabel.text! + timeArray![index] + ", "
            }
            timeLabel.text = timeLabel.text! + timeArray![-1]
        }
        view.addSubview(timeLabel)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textAlignment = .left
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        locationLabel.text = ""
        let locationArray = delegate?.getLocation(index: indexSelected)
        let locationSize = locationArray?.count
        if (timeSize! > 0){
            for index in 0..<(locationSize! - 1){
                locationLabel.text = locationLabel.text! + locationArray![index] + ", "
            }
            locationLabel.text = locationLabel.text! + locationArray![-1]
        }
        view.addSubview(locationLabel)
        
        menuLabel = UILabel()
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        menuLabel.textAlignment = .left
        menuLabel.text = "Menu"
        menuLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(menuLabel)
        
        menu = UITextView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.textAlignment = .left
        menu.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        menu.text = delegate?.getMenu(index: indexSelected)
        view.addSubview(menu)
        
        eventDetailLabel = UILabel()
        eventDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDetailLabel.textAlignment = .left
        eventDetailLabel.text = "Event Details"
        eventDetailLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(eventDetailLabel)
        
        eventDetail = UITextView()
        eventDetail.translatesAutoresizingMaskIntoConstraints = false
        eventDetail.textAlignment = .left
        eventDetail.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        eventDetail.text = delegate?.getEventDetail(index: indexSelected)
        eventDetail.textAlignment = .left
        view.addSubview(eventDetail)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImageView.heightAnchor.constraint(equalToConstant: 250),
            eventImageView.widthAnchor.constraint(equalToConstant: 450)
            ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            menuLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            menuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            menuLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            menu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            menu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            eventDetailLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            eventDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            eventDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            eventDetail.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            eventDetail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            eventDetail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        
        
        
    }

  
}
