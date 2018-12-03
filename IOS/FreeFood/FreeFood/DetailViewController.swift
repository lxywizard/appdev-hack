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
    var DateLabel: UILabel!
    var locationLabel: UILabel!
    var menuLabel: UILabel!
    var menu: UITextView!
    var eventDetailLabel: UILabel!
    var eventDetail: UITextView!
    
    let padding = CGFloat(15)
    let green = UIColor(red: 12/255, green: 105/255, blue: 92/255, alpha: 1.0)
    let adjustedGreen = UIColor(red: 44/255, green: 119/255, blue: 108/255, alpha: 1.0)

    
    weak var delegate: DetailDelegate?
    
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
        
        let tlabel = UILabel()
        tlabel.text = "Details"
        tlabel.textColor = .white
        tlabel.backgroundColor = adjustedGreen
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        self.navigationItem.titleView = tlabel
        
        eventImageView = UIImageView()
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventImageView.image = UIImage(named: (delegate?.getImageName(index: indexSelected))!)
        view.addSubview(eventImageView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.text = delegate?.getName(index: indexSelected)
        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        nameLabel.textColor = green
        view.addSubview(nameLabel)
        
        DateLabel = UILabel()
        DateLabel.translatesAutoresizingMaskIntoConstraints = false
        DateLabel.textAlignment = .left
        DateLabel.font = UIFont(name: "Helvetica", size: 18)
        let date = delegate?.getDate(index: indexSelected)
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        DateLabel.text = dateFormatter.string(from: date ?? Date(timeIntervalSince1970: 0))
        DateLabel.font = UIFont(name: "Helvetica", size: 18)
        view.addSubview(DateLabel)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textAlignment = .left
        locationLabel.font = UIFont(name: "Helvetica", size: 18)
        locationLabel.text = ""
        let location = delegate?.getLocation(index: indexSelected)
        locationLabel.text = location
        view.addSubview(locationLabel)
        
        menuLabel = UILabel()
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        menuLabel.textAlignment = .left
        menuLabel.text = "Menu"
        menuLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        menuLabel.textColor = green
        view.addSubview(menuLabel)
        
        menu = UITextView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.textAlignment = .left
        menu.font = UIFont(name: "Helvetica", size: 16)
        menu.text = delegate?.getMenu(index: indexSelected)
        view.addSubview(menu)
        
        eventDetailLabel = UILabel()
        eventDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDetailLabel.textAlignment = .left
        eventDetailLabel.text = "Event Details"
        eventDetailLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        eventDetailLabel.textColor = green
        view.addSubview(eventDetailLabel)
        
        eventDetail = UITextView()
        eventDetail.translatesAutoresizingMaskIntoConstraints = false
        eventDetail.textAlignment = .left
        eventDetail.font = UIFont(name: "Helvetica", size: 16)
        eventDetail.text = delegate?.getEventDetail(index: indexSelected)
        eventDetail.textAlignment = .left
        view.addSubview(eventDetail)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            eventImageView.widthAnchor.constraint(equalToConstant: 414)
            ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            DateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            DateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            DateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: DateLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            menuLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            menuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            menuLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: menuLabel.bottomAnchor, constant: 8),
            menu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            menu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            menu.heightAnchor.constraint(equalToConstant: 30)
            ])
        NSLayoutConstraint.activate([
            eventDetailLabel.topAnchor.constraint(equalTo: menu.bottomAnchor, constant: padding),
            eventDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            eventDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        NSLayoutConstraint.activate([
            eventDetail.topAnchor.constraint(equalTo: eventDetailLabel.bottomAnchor, constant: 8),
            eventDetail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            eventDetail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            eventDetail.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
