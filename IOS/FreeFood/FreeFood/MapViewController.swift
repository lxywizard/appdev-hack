//
//  mapViewController.swift
//  FreeFood
//
//  Created by Wenyi Guo on 12/1/18.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MapViewController: UIViewController, GMSMapViewDelegate {
    weak var delegate: MapDelegate?
    
    var locationManager = CLLocationManager()
    var markers: [GMSMarker] = []
    lazy var mapView = GMSMapView()
    
    var eventsArray: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        title = "Map"
        mapView.isMyLocationEnabled = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures   = true
        mapView.delegate = self
        
        // User currrent lsocation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.view = mapView
        
        eventsArray = delegate?.getEvents()
        
        for i in 0...((eventsArray?.count)!-1){
            let latitude = eventsArray![i].getLatitude()
            let longitude = eventsArray![i].getLongitude()
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)
            marker.title = eventsArray![i].getName()
            marker.snippet = eventsArray![i].getAddress()
            marker.map = mapView
            markers.append(marker)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let index = markers.index(of: marker) {
            print(index)
            let navViewController = DetailViewController(indexPass: index)
            navViewController.delegate = self
            self.navigationController?.pushViewController(navViewController, animated: true)
            return true
        }
        return false
    }
}
    
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//
//}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate, DetailDelegate {
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
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

