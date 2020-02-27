//
//  ProfileViewController.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 15/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser!.uid
        userIdLabel.text = "UID: \(uid)"
        
        let userEmail = Auth.auth().currentUser!.email
        emailLabel.text = "Email: \(userEmail ?? "N/A")"
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            toLoginViewController()
        } catch {
            print("unable to sign out: \(error)")
        }
    }
    
    func toLoginViewController() {
        let liveGolfViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        view.window?.rootViewController = liveGolfViewController
        view.window?.makeKeyAndVisible()
    }
    
}
