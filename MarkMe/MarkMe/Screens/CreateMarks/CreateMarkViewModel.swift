//
//  CreateMarkViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 28.02.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

class CreateMarkViewModel {
    let db = Firestore.firestore()
    let geoCodder = CLGeocoder()
    
    func getMarkTypes(completion: @escaping (Result<[MarkType], AlertError>) -> ()) {
        db.collection("MarkType").getDocuments() { (querySnapshot, err) in
            guard err == nil, querySnapshot?.documents.isEmpty == false, let documents = querySnapshot?.documents else {
                completion(.failure(AlertError(title: "Database Error", message: "User is not found!")))
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
}
