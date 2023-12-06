//
//  CreateElderViewController.swift
//  SeniorSignal
//
//  Created by Duncan Mckinley on 11/11/23.
//

import UIKit
import ParseSwift

class CreateElderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var elderName: UITextField!
    @IBOutlet weak var elderAge: UITextField!
    @IBOutlet weak var elderPhone: UITextField!
    @IBOutlet weak var ecName: UITextField!
    @IBOutlet weak var ecPhone: UITextField!
    @IBOutlet weak var ecRelationship: UITextField!
    @IBOutlet weak var elderSave: UIButton!
    @IBOutlet weak var elderPic: UIImageView!
    @IBOutlet weak var elderPicUpload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elderSave.tintColor = UIColor(red: 255 / 255, green: 160 / 255, blue: 122 / 255, alpha: 1.0)
        setupTextFields()
        
        elderName.borderStyle = .roundedRect
        elderAge.borderStyle = .roundedRect
        elderPhone.borderStyle = .roundedRect
        ecName.borderStyle = .roundedRect
        ecPhone.borderStyle = .roundedRect
        ecRelationship.borderStyle = .roundedRect

        // Or if you want a custom border
        elderName.layer.borderColor = UIColor.darkGray.cgColor
        elderName.layer.borderWidth = 1.0
        elderName.layer.cornerRadius = 5.0

        elderAge.layer.borderColor = UIColor.darkGray.cgColor
        elderAge.layer.borderWidth = 1.0
        elderAge.layer.cornerRadius = 5.0
        
        elderPhone.layer.borderColor = UIColor.darkGray.cgColor
        elderPhone.layer.borderWidth = 1.0
        elderPhone.layer.cornerRadius = 5.0
        
        ecName.layer.borderColor = UIColor.darkGray.cgColor
        ecName.layer.borderWidth = 1.0
        ecName.layer.cornerRadius = 5.0
        
        ecPhone.layer.borderColor = UIColor.darkGray.cgColor
        ecPhone.layer.borderWidth = 1.0
        ecPhone.layer.cornerRadius = 5.0
        
        ecRelationship.layer.borderColor = UIColor.darkGray.cgColor
        ecRelationship.layer.borderWidth = 1.0
        ecRelationship.layer.cornerRadius = 5.0
        
    }
    
    private func setupTextFields() {
        // Set dark text for placeholders
        elderName.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        elderAge.attributedPlaceholder = NSAttributedString(string: "Age", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        elderPhone.attributedPlaceholder = NSAttributedString(string: "Phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        ecName.attributedPlaceholder = NSAttributedString(string: "Emergency Contact Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        ecPhone.attributedPlaceholder = NSAttributedString(string: "Emergency Contact Phone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        ecRelationship.attributedPlaceholder = NSAttributedString(string: "Contact Relationship", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    
    @IBAction func elderPicUploadTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func saveElderProfile(_ sender: UIButton) {
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
        
        var elderProfile = ElderProfile()
        elderProfile.elderName = elderNameText
        elderProfile.elderAge = elderAgeText
        elderProfile.elderPhone = elderPhoneText
        elderProfile.ecName = ecNameText
        elderProfile.ecPhone = ecPhoneText
        elderProfile.ecRelationship = ecRelationshipText
        elderProfile.caretaker = Pointer<User>(objectId: currentUserId)
        
        if let image = elderPic.image, let imageData = image.jpegData(compressionQuality: 0.5) {
            let file = ParseFile(data: imageData)
            file.save { result in
                switch result {
                case .success(let savedFile):
                    elderProfile.elderPic = savedFile
                    self.saveElderProfileToServer(elderProfile)
                case .failure(let error):
                    self.presentAlert(title: "Image Upload Failed", message: error.localizedDescription)
                }
            }
        } else {
            saveElderProfileToServer(elderProfile)
        }
    }
    
    func saveElderProfileToServer(_ profile: ElderProfile) {
        profile.save { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let savedProfile):
                    print("Elder profile saved successfully with object id: \(savedProfile.objectId ?? "")")
                    self.navigateToHomeViewController()
                case .failure(let error):
                    self.presentAlert(title: "Save Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add User"
    }
    
    func navigateToHomeViewController() {
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            presentAlert(title: "Error", message: "HomeViewController could not be instantiated.")
            return
        }
        if let navigationController = self.navigationController {
            navigationController.setViewControllers([homeVC], animated: true)
        } else {
            present(homeVC, animated: true, completion: nil)
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            elderPic.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


