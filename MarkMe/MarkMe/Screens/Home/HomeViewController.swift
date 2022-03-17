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
    private let locationMenager = CLLocationManager()
    private let regionMeters: Double = 750
    private let viewModel = HomeViewModel()
    private var router: HomeRouter?
    
    override func viewDidLoad() {
        super.viewWillAppear(true)
        router = HomeRouter(root: self)
        map.delegate = self
        checkLocationServices()
        showMarks()
    }
}

//map
extension HomeViewController: MKMapViewDelegate {
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
    
    func showSettingsAlert(title: String ,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
            showSettingsAlert(title: "",message: "Turn on Location Services to Allow 'MarkMe' to Determine Your Location")
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
            showSettingsAlert(title: "Access to location denied", message: "Allow acces to the location services!")
        default:
            break
        }
    }
    
    func showMarks() {
        // get all marks
        viewModel.getAllMarks() { [weak self] (result) in
            self?.map.removeAnnotations((self?.map.annotations)!)
            switch result {
            case .success(let marks):
                for mark in marks {
                    // create annotation
                    let annotation = CustomAnnotation(markInfo: mark)
                    
                    // set annotation title
                    annotation.title = annotation.markInfo.title
                    
                    // set mark subtitle
                    self?.viewModel.getCreatorName(documentRef: annotation.markInfo.creator) { (result) in
                        annotation.subtitle = "by " + result
                    }
                    
                    // set annotation coordinates
                    annotation.coordinate = CLLocationCoordinate2D(latitude: mark.geolocation.latitude, longitude: mark.geolocation.longitude)
                    
                    // add annotation on map
                    self?.map.addAnnotation(annotation)
                }
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CustomAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customAnnotation") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
            annotationView?.canShowCallout = true
            annotationView?.titleVisibility = .hidden
            
            // annotation info button
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        }
        else {
            annotationView?.annotation = annotation
        }
        
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        // set glyphyImage dependin on mark type
        annotationView?.glyphImage = viewModel.getImageForMarkType(type: annotation.markInfo.type)
        
        // set annotation color depend on mark solved
        annotationView?.markerTintColor = viewModel.getColorForSolvedNumber(solved: annotation.markInfo.solved.count)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? CustomAnnotation, let id = annotation.markInfo.id else {
            return
        }
        router?.goToMarkInfo(markID: id)
    }
}

// buttons
extension HomeViewController {
    @IBAction func goToCreateMark(_ sender: UIButton) {
        router?.goToCreateMark()
    }
    
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
