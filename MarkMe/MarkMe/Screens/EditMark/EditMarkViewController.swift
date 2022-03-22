//
//  EditMarkViewController.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 22.03.22.
//

import UIKit

class EditMarkViewController: UIViewController {
    
    @IBOutlet private var titleTextField: TextField!
    @IBOutlet private var descriptionTextView: TextView!
    @IBOutlet private var typeTextField: TextField!
    
    private var router: EditMarkRouter?
    private var pickerView = UIPickerView()
    private let viewModel = EditMarkViewModel()
    var mark: Mark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = EditMarkRouter(root: self)
        viewModel.mark = mark
        setUpForm()
        setupPicker()
    }
    
    func setUpForm() {
        titleTextField.text = mark?.title
        descriptionTextView.text = mark?.description
        typeTextField.text = mark?.type
    }
}

// mark types picker
extension EditMarkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension EditMarkViewController {
    @IBAction func backToMarkList() {
        router?.dismiss()
    }
    
    @IBAction func didUpdate() {
        viewModel.updateMark(title: titleTextField.text, description: descriptionTextView.text, type: typeTextField.text) { [weak self] (alert) in
            if let alert = alert {
                self?.showAlert(title: alert.title, alertMessage: alert.errorDescription)
            }
            else {
                self?.router?.dismiss()
            }
        }
    }
}
