//
//  LoginViewController.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 14/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var signUpOrLoginButton: UIButton!
    @IBOutlet weak var continueWithGmailButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didGoogleSignIn), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)

    }
    
    
    @IBAction func gmailLoginTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }


    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)

        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong witht the fields, show error message
            self.messageLabel.isHidden = false
            self.messageLabel.text = error
            
        } else {
            
            // Create cleaned versions of the data
            let email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if signUpOrLoginButton.titleLabel!.text == "Log In" {
                
                // Signing in the user
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        // There was an error signing in the user
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = error?.localizedDescription ?? ""
                        
                    } else {
                        
                        // Sign in to view controller
                        self.toTabBarController()

                    }
                }
                
            } else {
                setLoggingIn(false)

                // Create user
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    // Check for errors
                    if error != nil {
                        // There was an error creating the user
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = error?.localizedDescription ?? ""
                        
                        if error?.localizedDescription == "The email address is already in use by another account." {
                            self.showMessage(message: "Please press log in button to continue.")
                            self.signUpOrLoginButton.setTitle("Log In", for: .normal)
                            
                        }
                        
                    } else {
                        self.showMessage(message: "Sign up successful! \nPlease press log in button to continue.")
                        self.signUpOrLoginButton.setTitle("Log In", for: .normal)
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
    // Notify from app delegate if google sign in was sussessful
    @objc func didGoogleSignIn()  {
        // Push the next view controller when the user is signed in with Google
        toTabBarController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // Show log in status messages
    func showMessage(message: String) {
        self.messageLabel.isHidden = false
        self.messageLabel.text = message
    }
    
    
    // Setting activity indicator and disable all fields while loading to sign in
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextfield.isEnabled = !loggingIn
        passwordTextfield.isEnabled = !loggingIn
        signUpOrLoginButton.isEnabled = !loggingIn
        continueWithGmailButton.isEnabled = !loggingIn
    }
    
    
    // Push to next view controler after signed in
    func toTabBarController() {
        let liveGolfViewController = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        view.window?.rootViewController = liveGolfViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    // Check that all fields are filled in
    func validateFields() -> String? {
        if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    
    // Hide keyboard when user press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
}
