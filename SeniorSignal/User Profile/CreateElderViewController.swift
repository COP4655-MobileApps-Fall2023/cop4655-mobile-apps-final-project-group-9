//
//  CreateElderViewController.swift
//  SeniorSignal
//
//  Created by Duncan Mckinley on 11/11/23.
//

import UIKit
import ParseSwift

class CreateElderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var elderName: UITextField!
    @IBOutlet weak var elderAge: UITextField!
    @IBOutlet weak var elderPhone: UITextField!
    @IBOutlet weak var ecName: UITextField!
    @IBOutlet weak var ecPhone: UITextField!
    @IBOutlet weak var ecRelationship: UITextField!
    @IBOutlet weak var elderSave: UIButton!
    @IBOutlet weak var elderPic: UIImageView!
    @IBOutlet weak var elderPicUpload: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Set the tag for each text field
        elderName.tag = 0
        elderAge.tag = 1
        elderPhone.tag = 2
        ecName.tag = 3
        ecPhone.tag = 4
        ecRelationship.tag = 5
        
        setupViews()
        setupDelegates()
        setupScrollView()
        addConstraints()
        registerForKeyboardNotifications()
        scrollView.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printTextFieldFrames()
    }

    func setupViews() {
        elderSave.tintColor = UIColor(red: 255 / 255, green: 160 / 255, blue: 122 / 255, alpha: 1.0)
        // Enable user interaction for each text field
        
        // Enable user interaction for the 'Save Elder' button
        elderSave.isUserInteractionEnabled = true
        
        let textFields = [elderName, elderAge, elderPhone, ecName, ecPhone, ecRelationship]
        textFields.forEach { $0?.isUserInteractionEnabled = true }
    }
    
    func setupScrollView() {
        scrollView.isUserInteractionEnabled = true
        scrollView.delaysContentTouches = false
    }

    func printTextFieldFrames() {
        let textFields = [elderName, elderAge, elderPhone, ecName, ecPhone, ecRelationship]
        textFields.forEach { textField in
            if let textField = textField {
                print("\(textField.placeholder ?? "TextField"): \(textField.frame)")
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setupDelegates() {
        elderName.delegate = self
        elderAge.delegate = self
        elderPhone.delegate = self
        ecName.delegate = self
        ecPhone.delegate = self
        ecRelationship.delegate = self

        // Set return key types for text fields if needed
        elderName.returnKeyType = .next
        elderAge.returnKeyType = .next
        elderPhone.returnKeyType = .next
        ecName.returnKeyType = .next
        ecPhone.returnKeyType = .next
        ecRelationship.returnKeyType = .done
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func addConstraints() {
        // First, remove all existing constraints that might conflict
        scrollView.removeConstraints(scrollView.constraints)
        view.subviews.forEach { $0.removeConstraints($0.constraints) }

        // Setting up scrollView constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: elderPicUpload.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Creating contentView and setting up its constraints
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Constrain the imageView
        elderPic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            elderPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            elderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            elderPic.widthAnchor.constraint(equalToConstant: 100),
            elderPic.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Constrain the 'Add Photo' button relative to the imageView
        elderPicUpload.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            elderPicUpload.topAnchor.constraint(equalTo: elderPic.bottomAnchor, constant: 20),
            elderPicUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Constrain text fields within contentView, stacked vertically
        var previousAnchor = contentView.topAnchor
        let textFields = [elderName, elderAge, elderPhone, ecName, ecPhone, ecRelationship]
        for textField in textFields {
            textField?.translatesAutoresizingMaskIntoConstraints = false
            if let textField = textField {
                contentView.addSubview(textField)
                NSLayoutConstraint.activate([
                    textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    textField.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
                    textField.heightAnchor.constraint(equalToConstant: 44)
                ])
                previousAnchor = textField.bottomAnchor
            }
        }

        // Constrain the 'Save Elder' button
        elderSave.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            elderSave.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            elderSave.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
            elderSave.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            elderSave.heightAnchor.constraint(equalToConstant: 44),
            elderSave.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }


    private func setupTextField(_ textField: UITextField, tag: Int) {
        textField.delegate = self
        textField.tag = tag
        textField.returnKeyType = (tag == 5) ? .done : .next // Set the return key type
        textField.inputAccessoryView = createToolbar() // Add toolbar with 'Done' button
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        return toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
    
    // UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find the next text field
        if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            // Not found, so remove the keyboard
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        if let activeTextField = view.findFirstResponder() as? UITextField {
            scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // Helper method to find the first responder
        private func findFirstResponder(inView view: UIView) -> UIView? {
            if view.isFirstResponder {
                return view
            }
            for subView in view.subviews {
                if let responder = findFirstResponder(inView: subView) {
                    return responder
                }
            }
            return nil
        }
    }

    // Extension to UIView to find the first responder in the view hierarchy
    extension UIView {
        func findFirstResponder() -> UIView? {
            if self.isFirstResponder {
                return self
            }
            for subView in self.subviews {
                if let responder = subView.findFirstResponder() {
                    return responder
                }
            }
            return nil
        }
    }




