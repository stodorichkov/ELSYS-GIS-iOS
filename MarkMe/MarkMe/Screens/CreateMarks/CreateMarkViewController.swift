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
    @IBOutlet private var findAdressTextField: UITextField!
    
    @IBOutlet private var titleTextField: TextField!
    @IBOutlet private var typeTextField: TextField!
    @IBOutlet private var descriptionField: TextView!
    private var image: UIImage?
    private var geoLocation = CLLocationCoordinate2D()
    private let locationManager = CLLocationManager()
    private let viewModel = CreateMarkViewModel()
    private var pickerView = UIPickerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        centerOnUserLocation()
        setupPicker()
    }
}

// map
extension CreateMarkViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerOnUserLocation() {
        map.showsUserLocation = true
        if let location = locationManager.location?.coordinate {
            geoLocation = location
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
        self.geoLocation = cord
        
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
                self?.geoLocation = location
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                self?.map.addAnnotation(annotation)
                self?.centerOnLocation(location: location)
            case .failure(let alert):
                self?.showAlert(title: alert.title, alertMessage: alert.errorDescription)
                self?.findAdressTextField.text = ""
                self?.centerOnUserLocation()
            }
        }
    }
}

// mark types picker
extension CreateMarkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        typeTextField.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.markTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.markTypes[row].type
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = viewModel.markTypes[row].type
        typeTextField.resignFirstResponder()
    }
}

// image picker
extension CreateMarkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func didPickImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.image = editImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// buttons
extension CreateMarkViewController {
    @IBAction func backToHome(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func createNewMark(_ sender: UIButton) {
        viewModel.createMark(title: titleTextField.text, description: descriptionField.text, type: typeTextField.text, location: geoLocation, image: image) { [weak self] (result) in
                switch result {
                case .success(()):
                    self?.goBack()
                case .failure(let alert):
                    self?.showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
        }
    }
    
    func goBack() {
        let router = CreateMarkRouter(root: self)
        router.dismiss()
    }
}
