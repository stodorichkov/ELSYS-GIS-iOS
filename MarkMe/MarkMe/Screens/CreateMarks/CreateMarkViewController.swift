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
    
    @IBOutlet weak var typeTextField: TextField!
    
    let viewModel = CreateMarkViewModel()
    var markTypes = [MarkType]()
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerOnUserLocation()
        getMarkTypes()
        pickerView.delegate = self
        pickerView.dataSource = self
        typeTextField.inputView = pickerView
        
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
           let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(region, animated: true)
        }
    }
}

extension CreateMarkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

// mark types
extension CreateMarkViewController {
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
