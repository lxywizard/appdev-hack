//
//  TimeViewController.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/25.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DetailDelegate {
    

    var eventCollectionView: UICollectionView!
    var eventsArray: [Event]!
    var originalArray: [Event]!
    var searchedEvents: [Event] = []
    var calendarCollectionView: UICollectionView!
    var calendarArray: [Calendar]!
    var searchBar: UISearchBar!
    var isSearching: Bool = false
    var eventsInEachDay: [[Event]]!
    
    let eventCellReuseIdentifier = "eventCellReuseIdentifier"
    let calendarCellReuseIdentifier = "calendarCellReuseIdentifier"
    let padding: CGFloat = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FreeFood"
        view.backgroundColor = .white
        
        originalArray = []
        eventsArray = originalArray
        calendarArray = []
        eventsInEachDay = []
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        eventCollectionView.backgroundColor = .lightGray
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: eventCellReuseIdentifier)
        view.addSubview(eventCollectionView)
        
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.minimumInteritemSpacing = 4
        filterLayout.minimumLineSpacing = 4
        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.backgroundColor = .lightGray
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.allowsMultipleSelection = false
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: calendarCellReuseIdentifier)
        view.addSubview(calendarCollectionView)
        
        searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Events"
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        view.addSubview(searchBar)
        
        setupConstraints()
      
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 70)
            ])
        
        NSLayoutConstraint.activate([
            eventCollectionView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor, constant: 10),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.eventCollectionView{
            if isSearching{
                return searchedEvents.count
            }
            else{
                return eventsArray.count
            }
        }
        
        else{
            return calendarArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.eventCollectionView{
            let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCollectionViewCell
            cell.backgroundColor = .white
            let event: Event!
            if isSearching{
                event = searchedEvents[indexPath.item]
            }
            else{
                event = eventsArray[indexPath.item]
            }
            cell.configure(for: event)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 2
            cell.setNeedsUpdateConstraints()
            //把today默认设置为selected
            if indexPath.item == 0{
                cell.isSelected = true
            }
            
            return cell
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCellReuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
            let calendar = calendarArray[indexPath.item]
            cell.configure(for: calendar)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 2
            cell.setNeedsUpdateConstraints()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.eventCollectionView{
            let width = collectionView.frame.width - padding * 2
            let height = width * 0.6
            return CGSize(width: width, height: height)
            
        }
        else{
            let width = 90
            let height = 30
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.eventCollectionView{
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            let navViewController = DetailViewController(indexPass: indexPath.item)
            navViewController.delegate = self
            self.navigationController?.pushViewController(navViewController, animated: true)
        }
        
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCellReuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
            cell.isSelected = true
            eventsArray = eventsInEachDay[indexPath.item]
            self.eventCollectionView.reloadData()
        }
    }
    
    func getImageName(index: Int) -> String{
        return eventsArray[index].eventImgName
    }
    
    func getName(index: Int) -> String{
        return eventsArray[index].eventName
    }
    
    func getLocation(index: Int) -> [String]{
        return eventsArray[index].eventLocation
    }
    func getTime(index: Int) -> [String]{
        return eventsArray[index].eventTime
    }
    func getMenu(index: Int) -> String{
        return eventsArray[index].eventFood
    }
    func getEventDetail(index: Int) -> String{
        return eventsArray[index].eventDetail
    }

}



extension CalendarViewController: UISearchBarDelegate{
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
}

