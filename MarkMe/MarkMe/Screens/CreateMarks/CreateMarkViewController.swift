//
//  CreateMarkVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 19.01.22.
//

import UIKit
import MapKit
import CoreLocation

class CreateMarkViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOnUserLocation()
    }
}

extension CreateMarkViewController: CLLocationManagerDelegate {
    @IBAction func backToHome(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func createNewMark(_ sender: UIButton) {
        goBack()
    }
    
    func goBack() {
        let router = CreateMarkRouter(root: self)
        router.dismiss()
    }
    
    func centerOnUserLocation() {
        let locationMenager = CLLocationManager()
        locationMenager.delegate = self
        locationMenager.desiredAccuracy = kCLLocationAccuracyBest
        map.showsUserLocation = true
        if let location = locationMenager.location?.coordinate {
           let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(region, animated: true)
        }
    }
}
