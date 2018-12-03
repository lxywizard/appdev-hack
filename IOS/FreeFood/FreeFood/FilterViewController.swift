//
//  FilterViewController.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/30.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl

class FilterViewController: UIViewController {

    var dateSegmentedControl: UISegmentedControl!
    var dateArray: [Date] = []
    var formattedDateArray: [String] = []
    var selectedDate: Date!
    var locationSegmentedControl: MultiSelectSegmentedControl!
    var locationArray: [String]!
    var selectedLocations: [String]! = []
    var reset: UIButton!
    
    let green = UIColor(red: 12/255, green: 105/255, blue: 92/255, alpha: 1.0)
    
    weak var delegate: FilterDelegate?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveFilters))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        //create an array of formatted date, starting from today
        let today = Date()
        dateArray.append(today)
        for i in 1...6{
            let nextDay = Date(timeInterval: 86400.0, since: dateArray[i-1])
            dateArray.append(nextDay)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("Mdd")
        
        for i in 0...6{
            formattedDateArray.append(dateFormatter.string(from: dateArray[i]))
        }

        dateSegmentedControl = UISegmentedControl(items: formattedDateArray)
        dateSegmentedControl.frame = CGRect(x: 10, y: 250, width: 390, height: 30)
        dateSegmentedControl.selectedSegmentIndex = 0
        selectedDate = dateArray[0]
        dateSegmentedControl.addTarget(self, action: #selector(dateSegmentedControlAction), for: .valueChanged)
        self.view.addSubview(dateSegmentedControl)
        
        locationArray = ["Central", "North", "West", "East", "Other"]
        locationSegmentedControl = MultiSelectSegmentedControl(items: locationArray)
        locationSegmentedControl.frame = CGRect(x: 60, y: 300, width: 300, height: 30)
        locationSegmentedControl.selectedSegmentIndex = 0
        selectedLocations = ["Central"]
        locationSegmentedControl.addTarget(self, action: #selector(locationSegmentedControlAction), for: .valueChanged)
        self.view.addSubview(locationSegmentedControl)
        
        reset = UIButton()
        reset.translatesAutoresizingMaskIntoConstraints = false
        reset.setTitle("Reset", for: .normal)
        reset.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        reset.setTitleColor(.white, for: .normal)
        reset.backgroundColor = green
        reset.layer.masksToBounds = true
        reset.layer.cornerRadius = 8
        reset.layer.borderColor = green.cgColor
        reset.layer.borderWidth = 1
        reset.addTarget(self, action: #selector(resetEvents), for: .touchUpInside)
        view.addSubview(reset)
        
        setupConstraints()
    }
    
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            reset.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reset.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reset.widthAnchor.constraint(equalToConstant: 100),
            reset.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc func dateSegmentedControlAction(){
        selectedDate = dateArray[dateSegmentedControl.selectedSegmentIndex]
        //print(selectedDate)
    }
    
    @objc func locationSegmentedControlAction(){
        selectedLocations = locationSegmentedControl.selectedSegmentTitles
        print(locationSegmentedControl.selectedSegmentTitles)
    }
   
    @objc func saveFilters(){
        if let actualSelectedDate = selectedDate, let actualSelectedLocations = selectedLocations{
            delegate?.filterEvents(selectedDate: actualSelectedDate, selectedLocations: actualSelectedLocations)
            navigationController?.popViewController(animated: true)
        }
        //navigationController?.popViewController(animated: true)
    }
    
    @objc func resetEvents(){
        delegate?.resetEvents()
        navigationController?.popViewController(animated: true)
    }
}
