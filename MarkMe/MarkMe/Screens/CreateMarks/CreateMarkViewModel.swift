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
            markTypes = documents.compactMap { (document) -> MarkType? in
                return try? document.data(as: MarkType.self)
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
    
    func getCreator(uid: String, completion: @escaping (String) -> ()) {
        if Auth.auth().currentUser!.providerData[0].providerType == .email {
            db.collection("User").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
                guard err == nil, let documents = querySnapshot?.documents else {
                    return
                }
                completion(documents[0].data()["username"] as! String)
            }
        }
        else {
            completion(Auth.auth().currentUser!.displayName!)
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
        
        // set creator
        return .success(Mark(title: title, description: description, geolocation: GeoPoint(latitude: location.latitude, longitude: location.longitude), type: type, creator: Auth.auth().currentUser!.uid))
    }
    
    func addMark(mark: Mark, completion: @escaping (Result<Void, AlertError>) -> ()) {
        getCreator(uid: mark.creator) { [weak self] (creator) in
            var newMark = mark
            newMark.creator = creator
            do {
                let _ = try self?.db.collection("Mark").addDocument(from: newMark)
            }
            catch {
                completion(.failure(AlertError(title: "Database Erroe", message: error.localizedDescription)))
            }
            completion(.success(()))
        }
        
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
                        self?.addMark(mark: newMark) { (result) in
                            switch result {
                            case .success(()):
                                completion(.success(()))
                            case .failure(let alert):
                                completion(.failure(alert))
                            }
                        }
                    }
                }
            }
            else {
                // try to save mark in db
                self?.addMark(mark: newMark) { (result) in
                    switch result {
                    case .success(()):
                        completion(.success(()))
                    case .failure(let alert):
                        completion(.failure(alert))
                    }
                }
            }
        }
    }
}
