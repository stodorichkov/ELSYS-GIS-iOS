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
    
    func getAdress(coordinates: CLLocationCoordinate2D, completion: @escaping (String) -> ()) {
        let clLocation = CLLocation.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
        var address = ""
        geoCodder.reverseGeocodeLocation(clLocation, completionHandler: { (placemark, error) in
            if let error = error {
                print(error)
                completion(address)
                return
            }
            guard let placemark = placemark?[0] else {
                return
            }
            if let thoroughfare = placemark.thoroughfare {
                address += thoroughfare + ", "
            }
            if let subThoroughfare = placemark.subThoroughfare {
                address += subThoroughfare + ", "
            }
            if let city = placemark.locality {
                address += city + ", "
            }
            if let country = placemark.country {
                address += country
            }
            completion(address)
        })
    }
    
    func findAddress(address: String) {
        geoCodder.geocodeAddressString(address) { (placemark, error) in
            if let error = error {
                print(error)
                //completion(address)
                return
            }
            guard let placemark = placemark?[0] else {
                return
            }
            
            print(placemark.location?.coordinate)
            
        }
    }
}
