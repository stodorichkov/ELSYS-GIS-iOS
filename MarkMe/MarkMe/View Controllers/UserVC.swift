//
//  UserVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FirebaseFirestore

class UserVC: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserLabel()
    }
}

extension UserVC {
    @IBAction func signOut(_ sender: UIButton) {
        do {
            guard let provider = Auth.auth().currentUser?.providerData[0].providerType else{
                return
            }
            switch provider {
            case .facebook:
                LoginManager().logOut()
            default:
                break
            }
            
            try Auth.auth().signOut()
            changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .crossDissolve)
        }
        catch let error {
            showAlert(alertMessage: error.localizedDescription, title: "Error")
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .crossDissolve)
    }
    
    func setUserLabel() {
        guard let curUser = Auth.auth().currentUser, let provider = curUser.providerData[0].providerType  else {
            return
        }
        if provider == .email{
            let db = Firestore.firestore()
            guard let email = curUser.email else{
                return
            }
            db.collection("User").whereField("email", isEqualTo: email).getDocuments() { [weak self] (querySnapshot, err) in
                guard err == nil, querySnapshot?.documents.isEmpty == false else {
                    self?.showAlert(alertMessage: "User is not found!", title: "Error")
                    return
                }

                self?.userLabel.text = querySnapshot?.documents[0].data()["username"] as? String
            }
        }
        else {
            userLabel.text = curUser.displayName
        }
    }
}
