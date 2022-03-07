//
//  CreateMarkViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 28.02.22.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class CreateMarkViewModel {
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let geoCodder = CLGeocoder()
    
    func getMarkTypes(completion: @escaping (Result<[MarkType], AlertError>) -> ()) {
        db.collection("MarkType").addSnapshotListener { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false, let documents = querySnapshot?.documents else {
                completion(.failure(AlertError(title: "Database Error", message: "Mark types are not found!")))
                return
            }
            var markTypes = [MarkType]()
            for document in documents {
                do {
                    guard let markType = try document.data(as: MarkType.self) else{
                        return
                    }
                    markTypes.append(markType)
                }
                catch {
                    print(error)
                }
            }
            completion(.success(markTypes))
        }
    }
    
    func findAddress(address: String?, completion: @escaping (Result<CLLocationCoordinate2D, AlertError>)->()) {
        guard let address = address, !address.isEmpty else {
            completion(.failure(AlertError(title: "Validation Error", message: "Search field is epmty")))
            return
        }

        geoCodder.geocodeAddressString(address) { (placemark, error) in
            if let error = error {
                print(error)
                completion(.failure(AlertError(title: "Adress error", message: "Adress not found")))
                return
            }
            guard let placemark = placemark?[0], let location = placemark.location?.coordinate else {
                return
            }
            completion(.success(location))
        }
    }
    
    func validateData(title: String?,description: String?, type: String?, location: CLLocationCoordinate2D) -> Result<Mark, AlertError> {
        // check form is completed
        guard  let title = title,
               let description = description,
               let type = type,
               !title.isEmpty,
               !description.isEmpty,
               !type.isEmpty
        else {
            return .failure(AlertError(title: "Validation Error", message: "The form must be completed!"))
        }
        return .success(Mark(title: title, description: description, geolocation: GeoPoint(latitude: location.latitude, longitude: location.longitude), type: type, creator: Auth.auth().currentUser!.uid))
    }
    
    func addMark(mark: Mark) -> Result<Void, AlertError> {
        do {
            let _ = try db.collection("Mark").addDocument(from: mark)
        }
        catch {
            return .failure(AlertError(title: "Database Erroe", message: error.localizedDescription))
        }
        return .success(())
    }
    
    
    func createMark(title: String?,description: String?, type: String?, location: CLLocationCoordinate2D, image: UIImage?, completion: @escaping (Result<Void, AlertError>)->()) {
        // validate form
        let vaidationResult = validateData(title: title, description: description, type: type, location: location)
        var newMark: Mark
        switch vaidationResult {
        case .success(let mark):
            newMark = mark
        case .failure(let alert):
            completion(.failure(alert))
            return
        }
        
        // check mark type is valid
        db.collection("MarkType").whereField("type", isEqualTo: newMark.type).getDocuments() { [weak self] (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false else {
                completion(.failure(AlertError(title: "Validation Error", message: "Mark type is invalid!")))
                return
            }
            // check for image
            if let image = image {
                // set path for image
                let path = "images/" + newMark.creator + "/" + newMark.title + ".png"
                guard let ref = self?.storage.child(path) else{
                    return
                }
                // try to sava image in storage
                ref.putData(image.pngData()!, metadata: nil) { (metadata, error) in
                    if let error = error {
                        completion(.failure(AlertError(title: "Storage Error", message: error.localizedDescription)))
                        return
                    }
                    ref.downloadURL() { (url, error) in
                        if let error = error {
                            completion(.failure(AlertError(title: "Storage Error", message: error.localizedDescription)))
                            return
                        }
                        guard let urlString = url?.absoluteString else {
                            return
                        }
                        newMark.imgPath = urlString
                        // try to save mark in db
                        let dbResult = self?.addMark(mark: newMark)
                        switch dbResult {
                        case .success(()):
                            completion(.success(()))
                        case .failure(let alert):
                            completion(.failure(alert))
                        case .none:
                            break
                        }
                    }
                }
            }
            else {
                // try to save mark in db
                let dbResult = self?.addMark(mark: newMark)
                switch dbResult {
                case .success(()):
                    completion(.success(()))
                case .failure(let alert):
                    completion(.failure(alert))
                case .none:
                    break
                }
            }
        }
    }
}
