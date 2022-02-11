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

    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
        }
        setUserLable()
    }
}

extension UserVC {
    @IBAction func signOut(_ sender: UIButton) {
        do {
            let provider = Auth.auth().currentUser!.providerData[0].providerID
            switch provider {
            case "facebook.com":
                LoginManager().logOut()
            default:
                break
            }
            
            try Auth.auth().signOut()
            changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .crossDissolve)
        }
        catch let error {
            showAlert(alertMessage: error.localizedDescription)
        }
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        changeScreen(storyboardName: "Authentication", viewControllerId: "login", transition: .crossDissolve)
    }
    
    func setUserLable() {
        if let curUser = Auth.auth().currentUser {
            let provider = curUser.providerData[0].providerID
            
            if provider == "password" {
                let db = Firestore.firestore()
                let email = curUser.email!
                db.collection("User").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        if querySnapshot!.documents.isEmpty {
                            self.showAlert(alertMessage: "User is not found!")
                        }
                        else {
                            print("User")
                            print(querySnapshot!.documents[0].data())
                            self.userLabel.text = querySnapshot!.documents[0].data()["username"]! as? String
                        }
                    }
                }
            }
            else {
                userLabel.text = curUser.displayName
            }
        }
    }
}
