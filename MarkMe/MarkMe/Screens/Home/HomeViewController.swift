//
//  HomeVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet private var map: MKMapView!
    let locationMenager = CLLocationManager()
    let regionMeters: Double = 1000
    
    override func viewDidLoad() {
        super.viewWillAppear(true)
        checkLocationServices()
    }
}

//map
extension HomeViewController {
    func setupLocationMenager() {
        locationMenager.delegate = self
        locationMenager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerOnUserLocation() {
        if let location = locationMenager.location?.coordinate {
           let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters )
            map.setRegion(region, animated: true)
        }
    }
    
    func showSettingsAlert(alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: "Go to settings", style: .default) { (action) in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!)
        })
        present(alert, animated: true)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationMenager()
            checkLocationAuthorization()
        }
        else {
            let alert = UIAlertController(title: "", message: "Turn on Location Services to Allow 'MarkMe' to Determine Your Location", preferredStyle: .alert)
            showSettingsAlert(alert: alert)
        }
    }
    
    func checkLocationAuthorization()  {
        switch locationMenager.authorizationStatus {
        case .notDetermined:
            locationMenager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            centerOnUserLocation()
            locationMenager.startUpdatingLocation()
        case .denied:
            let alert = UIAlertController(title: "Access to location denied", message: "Allow acces to the location services!", preferredStyle: .alert)
            showSettingsAlert(alert: alert)
        default:
            break
        }
    }
}

// buttons
extension HomeViewController {
    @IBAction func goToCreateMark(_ sender: UIButton) {
        let router = HomeRouter(root: self)
        router.goToCreateMark()    }
    
    @IBAction func didCenter(_ sender: UIButton) {
        centerOnUserLocation()
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters , longitudinalMeters: regionMeters )
        map.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
