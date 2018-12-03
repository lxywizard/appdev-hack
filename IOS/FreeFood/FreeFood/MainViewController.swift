//
//  ViewController.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/25.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

protocol FilterDelegate: class{
    func filterEvents(selectedDate: Date, selectedLocations: [String])
    func resetEvents()
}

protocol DetailDelegate: class{
    func getImageName(index: Int) -> String
    func getName(index: Int) -> String
    func getLocation(index: Int) -> String
    func getDate(index: Int) -> Date
    func getMenu(index: Int) -> String
    func getEventDetail(index: Int) -> String
}

protocol MapDelegate: class {
    func getEvents() -> [Event]
}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    var filtered: [Event] = []
    var isSearching: Bool = false
    var searchedEvents: [Event] = []
    
    let eventSize: Int = 0
    var eventCollectionView: UICollectionView!
    var eventsArray: [Event]! = []
    var originalArray: [Event]!

    var label: UILabel!
    
    let locations: [String] = ["North", "West", "Central"]
    let eventCellReuseIdentifier = "eventCellReuseIdentifier"
    let green = UIColor(red: 12/255, green: 105/255, blue: 92/255, alpha: 1.0)
    let adjustedGreen = UIColor(red: 44/255, green: 119/255, blue: 108/255, alpha: 1.0)
    let foodArray: [String] = ["hot chocolate, cookie, donuts, candy", "None ;(", "egg tarts, shumai from Hai Hong and Apollo's", "hotpot, includes vegetarian option", "insomnia cookie, hot chocolate, tea", "egg tarts, roast pork bun; mochi, mini origini, kimbap, tea egg, etc.", "Three Cup Chicken, Taiwanese Sausage, Minced Pork, Tempura, etc.", "snacks", "gourmet chowder", "Hi-Chews, White Rabbit Candy, Guava Candy, Jelly Candy Cups, Kit Kats, Hello Panda Cookies, hot chocolate, and Pocky"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backgroundColor = green
        self.title = "FreeFood"
        
        let tlabel = UILabel()
        tlabel.text = "Free Food"
        tlabel.textColor = .white
        tlabel.backgroundColor = adjustedGreen
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        self.navigationItem.titleView = tlabel
        self.navigationController?.navigationBar.barTintColor = green
        view.backgroundColor = .white
        //push the MapVC
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(pushMapVC))
    
        //push the filterVC
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(pushFilterVC))
        
        NetworkManager.getEvents { (eventStructArray) in
            self.eventsArray = self.convertEventStructToEvent(eventStructArray: eventStructArray)
            self.eventsArray = self.arrangeEvents(arr: self.eventsArray)
            self.originalArray = self.eventsArray
            
            DispatchQueue.main.async {
                self.eventCollectionView.reloadData()
            }
        }

        searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Events"
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.font = UIFont(name: "Helvetica", size: 18)
        textFieldInsideSearchBar?.backgroundColor =  UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 0.12)
        textFieldInsideSearchBar?.textColor = .darkGray
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1.0
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        view.addSubview(searchBar)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        eventCollectionView.backgroundColor = .white
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: eventCellReuseIdentifier)
        view.addSubview(eventCollectionView)
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upcoming Events"
        //label.textColor = .black
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.textColor = green
        view.addSubview(label)

        setupConstraints()
    }

    func setupConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
            ])
  
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 42),
            label.widthAnchor.constraint(equalToConstant: 250)
            ])
        
        NSLayoutConstraint.activate([
            eventCollectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching{
            return searchedEvents.count
        }else{
            return eventsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCollectionViewCell
        cell.backgroundColor = .white
        let event: Event!
        if isSearching{
            event = searchedEvents[indexPath.item]
        }else{
            event = eventsArray[indexPath.item]
        }
        cell.configure(for: event)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.setNeedsUpdateConstraints()
            
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 30
        let height = CGFloat(100)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        let navViewController = DetailViewController(indexPass: indexPath.item)
        navViewController.delegate = self
        self.navigationController?.pushViewController(navViewController, animated: true)
    }
    
    @objc func pushMapVC(){
        let navViewController = MapViewController()
        navViewController.delegate = self
        navigationController?.pushViewController(navViewController, animated: true)
    }
    
    @objc func pushFilterVC(){
        navigationItem.backBarButtonItem?.tintColor = .white
        let navViewController = FilterViewController()
        navViewController.delegate = self
        navigationController?.pushViewController(navViewController, animated: true)
    }
    
    func convertEventStructToEvent(eventStructArray: [EventStruct]) -> [Event]{
        var newEventArray: [Event] = []
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
        var i = 0
        for eachEventStruct in eventStructArray{
            let latitudeNum = Double(eachEventStruct.latitude)
            let longitudeNum = Double(eachEventStruct.longitude)
            let date = dateFormatterGet.date(from: eachEventStruct.datetime)
            let newEvent = Event(id: eachEventStruct.id, eventImgName: "\(i)", eventName: eachEventStruct.name, eventDate: date ?? Date(timeIntervalSince1970: 0), specificLocation: eachEventStruct.location, eventFood: foodArray[i], eventDetail: eachEventStruct.content, latitude: latitudeNum!, longtidue: longitudeNum!)
            newEventArray.append(newEvent)
            i += 1
        }
        return newEventArray
    }
    
    func arrangeEvents(arr: [Event]) -> [Event]{
        let newArr = arr.sorted(by: {$0.eventDate < $1.eventDate})
        return newArr
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden =  true
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor(red: 44/255, green: 119/255, blue: 108/255, alpha: 1.0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}


extension MainViewController: DetailDelegate, FilterDelegate, MapDelegate{
    
    func getImageName(index: Int) -> String{
        return eventsArray[index].eventImgName
    }
    func getName(index: Int) -> String{
        return eventsArray[index].eventName
    }
    func getLocation(index: Int) -> String{
        return eventsArray[index].specificLocation
    }
    func getDate(index: Int) -> Date{
        return eventsArray[index].eventDate
    }
    func getMenu(index: Int) -> String{
        return eventsArray[index].eventFood
    }
    func getEventDetail(index: Int) -> String{
        return eventsArray[index].eventDetail
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        self.eventCollectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        self.eventCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            self.eventCollectionView.reloadData()
        }
        else{
            isSearching = true
            searchedEvents.removeAll(keepingCapacity: false)
            searchedEvents = eventsArray.filter({$0.eventName.range(of: searchBar.text!, options: .caseInsensitive) != nil})
            
            self.eventCollectionView.reloadData()
        }
    }

    func filterEvents(selectedDate: Date, selectedLocations: [String]) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        
        var tempArray: [Event] = []
        for eachEvent in originalArray{
            if formatter.string(from: eachEvent.eventDate) == formatter.string(from: selectedDate){
                tempArray.append(eachEvent)
            }
        }
        
        eventsArray = []
        for eachEvent in tempArray{
            if selectedLocations.contains(eachEvent.typeLocation){
                eventsArray.append(eachEvent)
            }
        }
        self.eventCollectionView.reloadData()
    }
    
    func resetEvents() {
        eventsArray = originalArray
        self.eventCollectionView.reloadData()
    }
    
    func getEvents() -> [Event]{
        return originalArray
    }
}

