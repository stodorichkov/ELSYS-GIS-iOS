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

    @IBOutlet private var map: MKMapView!
    
    @IBOutlet weak var findAdressTextField: UITextField!
    @IBOutlet private var typeTextField: TextField!
    
    let locationMenager = CLLocationManager()
    
    let viewModel = CreateMarkViewModel()
    var markTypes = [MarkType]()
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationMenager()
        centerOnUserLocation()
        setupPicker()
    }
    
}

// map
extension CreateMarkViewController: CLLocationManagerDelegate {
    func setupLocationMenager() {
        locationMenager.delegate = self
        locationMenager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerOnUserLocation() {
        map.showsUserLocation = true
        if let location = locationMenager.location?.coordinate {
            centerOnLocation(location: location)
        }
    }
    
    func centerOnLocation(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        map.setRegion(region, animated: true)
    }
    
    @IBAction func pressToCenter(_ sender: UIButton) {
        centerOnUserLocation()
    }
    
    @IBAction func newPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: map)
        let cord = map.convert(location, toCoordinateFrom: map)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cord
        
        map.removeAnnotations(map.annotations)
        map.addAnnotation(annotation)
    }
    
    @IBAction func findAdrees(_ sender: UIButton) {
        map.removeAnnotations(map.annotations)
        viewModel.findAddress(address: findAdressTextField.text) { [weak self] (result) in
            switch result {
            case .success(let location):
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                self?.map.addAnnotation(annotation)
                self?.centerOnLocation(location: location)
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.message)
                self?.findAdressTextField.text = ""
            }
        }
    }
}

// mark types picker
extension CreateMarkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPicker() {
        getMarkTypes()
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
