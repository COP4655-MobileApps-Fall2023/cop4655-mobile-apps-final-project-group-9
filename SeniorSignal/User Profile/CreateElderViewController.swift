//
//  CreateElderViewController.swift
//  SeniorSignal
//
//  Created by Duncan Mckinley on 11/11/23.
//

import UIKit
import ParseSwift

// Define the ElderlyProfile struct to match your Parse Server class structure
struct Elderly: ParseObject, Codable {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    // Custom fields must match the keys you created in your Parse Server class
    var caretaker: Pointer<User>?
    var elderName: String?
    var elderAge: String?
    var elderPhone: String?
    var ecName: String?
    var ecPhone: String?
    var ecRelationship: String?
    
    // Implementing protocol requirements
    static var className: String {
        return "Elderly" // This must match the name of your Parse class
    }
    
    // Required initializer
    init() {}
}

class CreateElderViewController: UIViewController {
    @IBOutlet weak var elderName: UITextField!
    @IBOutlet weak var elderAge: UITextField!
    @IBOutlet weak var elderPhone: UITextField!
    @IBOutlet weak var ecName: UITextField!
    @IBOutlet weak var ecPhone: UITextField!
    @IBOutlet weak var ecRelationship: UITextField!
    @IBOutlet weak var elderSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view.
    }
    
    @IBAction func saveElderProfile(_ sender: UIButton) {
        // Input validation
        guard
            let elderNameText = elderName.text, !elderNameText.isEmpty,
            let elderAgeText = elderAge.text, !elderAgeText.isEmpty,
            let elderPhoneText = elderPhone.text, !elderPhoneText.isEmpty,
            let ecNameText = ecName.text, !ecNameText.isEmpty,
            let ecPhoneText = ecPhone.text, !ecPhoneText.isEmpty,
            let ecRelationshipText = ecRelationship.text, !ecRelationshipText.isEmpty,
            let currentUser = User.current, // Ensure currentUser is not nil
            let currentUserId = currentUser.objectId else {
            presentAlert(title: "Save Failed", message: "Please make sure all fields are filled.")
            return
        }
        
        // Create a new ElderlyProfile object
        var elderly = Elderly()
        elderly.elderName = elderNameText
        elderly.elderAge = elderAgeText
        elderly.elderPhone = elderPhoneText
        elderly.ecName = ecNameText
        elderly.ecPhone = ecPhoneText
        elderly.ecRelationship = ecRelationshipText
        elderly.caretaker = Pointer<User>(objectId: currentUserId)
        
        // Save the new ElderlyProfile to the database
        elderly.save { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let savedElderly):
                    print("Elderly profile saved successfully with name: \(String(describing: savedElderly.elderName))")
                    self.navigateToHomeViewController()
                case .failure(let error):
                    self.presentAlert(title: "Save Error", message: error.localizedDescription)
                }
            }
        }
}
        
        // This function was previously defined outside of the class scope
        func navigateToHomeViewController() {
                // Ensure the storyboard identifier matches your storyboard ID for the HomeViewController
                guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                    presentAlert(title: "Error", message: "HomeViewController could not be instantiated.")
                    return
                }
                // Navigate to the HomeViewController
                if let navigationController = self.navigationController {
                    navigationController.setViewControllers([homeVC], animated: true)
                } else {
                    present(homeVC, animated: true, completion: nil)
                }
            }
        
        // This function was previously defined outside of the class scope
        func presentAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
