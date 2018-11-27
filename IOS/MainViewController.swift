//
//  ViewController.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/25.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit

protocol detailDelegate: class{
    func getImageName(index: Int) -> String
    func getName(index: Int) -> String
    func getLocation(index: Int) -> [String]
    func getTime(index: Int) -> [String]
    func getMenu(index: Int) -> String
    func getEventDetail(index: Int) -> String
}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let eventSize: Int = 0//我也不知道为什么要加这个，但是我加了这个可以silence一个error
    var eventCollectionView: UICollectionView!
    var eventsArray: [Event]!
    var originalArray: [Event]!
    var filterCollectionView: UICollectionView!
    var filtersArray: [Filter]!
    
    lazy var selectedIndices:[Int] = Array(0...(eventSize - 1))
    lazy var selectedLocations: [Int] = Array(0...(eventSize - 1))
    lazy var selectedTimes: [Int] = Array(0...(eventSize - 1))
    
    
    var searchBar: UISearchBar!
    var filtered: [Event] = []
    var isSearching: Bool = false
    var searchedEvents: [Event] = []
    
    let locations: [String] = ["Nearest", "North", "West", "Central"]
    let times: [String] = ["8AM-11AM", "11AM-2PM", "2PM-5PM", "5PM-8PM", "8PM & later"]
    let eventCellReuseIdentifier = "eventCellReuseIdentifier"
    let filterCellReuseIdentifier = "filterCellReuseIdentifier"
    let padding: CGFloat = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FreeFood"
        view.backgroundColor = .white
        
        // import events data
        originalArray = []
        eventsArray = originalArray
        
        let nearestFilter = Filter(filterName: "Nearest")
        let northFilter = Filter(filterName: "North")
        let westFilter = Filter(filterName: "West")
        let centralFilter = Filter(filterName: "Central")
        let time1Filter = Filter(filterName: "8AM-11AM")
        let time2Filter = Filter(filterName: "11AM-2PM")
        let time3Filter = Filter(filterName: "2PM-5PM")
        let time4Filter = Filter(filterName: "5PM-8PM")
        let time5Filter = Filter(filterName: "8PM & later")
        
        filtersArray = [nearestFilter, northFilter, westFilter, centralFilter,
                        time1Filter, time2Filter, time3Filter, time4Filter, time5Filter]
        
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
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.backgroundColor = .lightGray
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.allowsMultipleSelection = true
        filterCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: filterCellReuseIdentifier)
        view.addSubview(filterCollectionView)
        
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
            filterCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 70)
            ])
        
        NSLayoutConstraint.activate([
            eventCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 10),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
            ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.eventCollectionView{
            if isSearching{
                return searchedEvents.count
            }else{
                return eventsArray.count
            }
        }
        else{
            return filtersArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.eventCollectionView{
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
            cell.layer.cornerRadius = 2
            cell.setNeedsUpdateConstraints()
            
            return cell
        }
        else{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCell
            let filter = filtersArray[indexPath.item]
            cellB.configure(for: filter)
            cellB.layer.masksToBounds = true
            cellB.layer.cornerRadius = 10
            cellB.setNeedsUpdateConstraints()
            
            return cellB
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCell
            cell.isSelected = true
            
            let filterName = filtersArray[indexPath.item].filterName
            if selectedIndices.count == eventSize{
                selectedIndices = []
                selectedLocations = []
                selectedTimes = []
            }
            for index in 0..<originalArray.count{
                if (originalArray[index].eventLocation.contains(filterName!)){
                    originalArray[index].filterLocationsNum += 1
                    if (!(selectedIndices.contains(index))){
                        selectedIndices.append(index)
                    }
                    if (!selectedLocations.contains(index)){
                        selectedLocations.append(index)
                    }
                }
                if (originalArray[index].eventTime.contains(filterName!)){
                    originalArray[index].filterTimesNum += 1
                    if (!(selectedIndices.contains(index))){
                        selectedIndices.append(index)
                    }
                    if (!selectedTimes.contains(index)){
                        selectedTimes.append(index)
                    }
                    
                }
            }
            
            if (selectedLocations.count > 0 && selectedTimes.count > 0){
                var newSelected: [Int] = []
                for eachIndex in selectedIndices{
                    if (selectedLocations.contains(eachIndex) && selectedTimes.contains(eachIndex)){
                        newSelected.append(eachIndex)
                    }
                }
                selectedIndices = newSelected
            }
            
            eventsArray = []
            for eachIndex in selectedIndices{
                eventsArray.append(originalArray[eachIndex])
            }
            
            self.eventCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.filterCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCell
            cell.isSelected = false
            
            let filterName = filtersArray[indexPath.item].filterName
            var removeLocations: [Int] = []
            var removeTimes: [Int] = []
            
            for index in selectedLocations{
                if (originalArray[index].eventLocation.contains(filterName!)){
                    originalArray[index].filterLocationsNum -= 1
                    if (originalArray[index].filterLocationsNum == 0){
                        removeLocations.append(index)
                    }
                }
            }
            for index in selectedTimes{
                if (originalArray[index].eventTime.contains(filterName!)){
                    originalArray[index].filterTimesNum -= 1
                    if (originalArray[index].filterTimesNum == 0){
                        removeTimes.append(index)
                    }
                }
            }
            
            var newSelectedLocations: [Int] = []
            for i in 0..<originalArray.count{
                if (selectedLocations.contains(i) && !(removeLocations.contains(i))){
                    newSelectedLocations.append(i)
                }
            }
            selectedLocations = newSelectedLocations
            
            var newSelectedTimes: [Int] = []
            for i in 0..<originalArray.count{
                if (selectedTimes.contains(i) && !(removeTimes.contains(i))){
                    newSelectedTimes.append(i)
                }
            }
            selectedTimes = newSelectedTimes
            
            if (selectedLocations.count > 0 && selectedTimes.count > 0){
                var newSelected: [Int] = []
                for eachIndex in selectedIndices{
                    if (selectedLocations.contains(eachIndex) && selectedTimes.contains(eachIndex)){
                        newSelected.append(eachIndex)
                    }
                }
                selectedIndices = newSelected
            }
            else if(selectedLocations.count == 0 && selectedTimes.count == 0){
                selectedIndices = Array(0...(eventSize - 1))
                selectedLocations = selectedIndices
                selectedTimes = selectedIndices
            }
            else if(selectedLocations.count > 0 && selectedTimes.count == 0){
                selectedIndices = selectedLocations
            }
            else if(selectedTimes.count > 0 && selectedLocations.count == 0){
                selectedIndices = selectedTimes
            }
            
            eventsArray = []
            for eachIndex in selectedIndices{
                eventsArray.append(originalArray[eachIndex])
            }
            self.eventCollectionView.reloadData()
        }
    }
    
    
}

extension MainViewController: detailDelegate{
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


extension MainViewController: UISearchBarDelegate{
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
