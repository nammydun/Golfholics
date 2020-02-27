//
//  AddGameViewController.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 15/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn

class AddGameViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var golfCourseTextfield: UITextField!
    @IBOutlet weak var golfGameTextfield: UITextField!
    @IBOutlet weak var p1Textfield: UITextField!
    @IBOutlet weak var p2Textfield: UITextField!
    @IBOutlet weak var p3Textfield: UITextField!
    @IBOutlet weak var p4Textfield: UITextField!
    
    // Firebase database reference
    var databaseRef: DatabaseReference?
    
    var golfCourses: [GolfCourse]! = []
    var golfGames: [GolfGame]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickerViewsData()
        
        golfGameTextfield.delegate = self
        p1Textfield.delegate = self
        p2Textfield.delegate = self
        p3Textfield.delegate = self
        p4Textfield.delegate = self
        
        let golfCoursesPickerView = UIPickerView()
        golfCoursesPickerView.delegate = self
        golfCoursesPickerView.tag = 1
        golfCourseTextfield.inputView = golfCoursesPickerView
        
        let golfGamePickerView = UIPickerView()
        golfGamePickerView.delegate = self
        golfGamePickerView.tag = 2
        golfGameTextfield.inputView = golfGamePickerView
        
    }
    
    func setUpPickerViewsData() {
        Firebase.shared().getGolfCourses { (golfCourses, error) in
            if error == nil {
                self.golfCourses = golfCourses!
            }
        }
        
        Firebase.shared().getGolfGames { (golfGames, error) in
            if error == nil {
                self.golfGames = golfGames!
            }
        }
    }
    
    // Press cancel button to go back to Live Golf View Controller
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let liveGolfViewController = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        view.window?.rootViewController = liveGolfViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    // Press create button to show an alert message to confirm creating score card, as to give a buffer time for firebase to download the data
    @IBAction func createButtonTapped(_ sender: Any) {
        // Make sure the golfCourseTextfield is not empty
        if self.golfCourseTextfield.text == "" {
            let alert = UIAlertController(title: "Please fill in all fields", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Firebase.shared().addScoreCard(golfCourseTextfield: self.golfCourseTextfield.text!, p1Name: self.p1Textfield.text!, p2Name: self.p2Textfield.text!, p3Name: self.p3Textfield.text!, p4Name: self.p4Textfield.text!) { (success, error) in
                if success == true {
                    print("Score Card Successfully Added!")
                }
            }
            let alert = UIAlertController(title: "Confirm to create score card?", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                self.performSegue(withIdentifier: "toLiveGolf", sender: self)}))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

//-------------------------------------------------------------------------------------------//

extension AddGameViewController: UITextFieldDelegate {
    // Hide keyboard when user press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//-------------------------------------------------------------------------------------------//

extension AddGameViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return golfCourses.count
        } else if pickerView.tag == 2 {
            return golfGames.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return golfCourses[row].golfCourseName
        } else if pickerView.tag == 2 {
            return golfGames[row].golfGameName
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            golfCourseTextfield.text = golfCourses[row].golfCourseName
        } else if pickerView.tag == 2 {
            golfGameTextfield.text = golfGames[row].golfGameName
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

//-------------------------------------------------------------------------------------------//
