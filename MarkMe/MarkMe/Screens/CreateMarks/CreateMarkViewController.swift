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

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var map: MKMapView!
    
    @IBOutlet private var typeTextField: TextField!
    
    let viewModel = CreateMarkViewModel()
    var markTypes = [MarkType]()
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOnUserLocation()
        getMarkTypes()
        setupPicker()
    }
}

// map
extension CreateMarkViewController: CLLocationManagerDelegate {
    func centerOnUserLocation() {
        let locationMenager = CLLocationManager()
        locationMenager.delegate = self
        locationMenager.desiredAccuracy = kCLLocationAccuracyBest
        map.showsUserLocation = true
        if let location = locationMenager.location?.coordinate {
           let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(region, animated: true)
        }
    }
    
    @IBAction func newPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: map)
        let cord = map.convert(location, toCoordinateFrom: map)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cord
        
        viewModel.getAdress(coordinates: cord) { [weak self] (address) in
            self?.searchBar.text = address
        }
        
        map.removeAnnotations(map.annotations)
        map.addAnnotation(annotation)
    }
}

// mark types picker
extension CreateMarkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        typeTextField.inputView = pickerView
    }
    
    func getMarkTypes() {
        viewModel.getMarkTypes() { [weak self] (result) in
            switch result {
            case .success(let markTypes):
                self?.markTypes = markTypes
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.message)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return markTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return markTypes[row].type
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = markTypes[row].type
        typeTextField.resignFirstResponder()
    }
}

// buttons
extension CreateMarkViewController {
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
}
