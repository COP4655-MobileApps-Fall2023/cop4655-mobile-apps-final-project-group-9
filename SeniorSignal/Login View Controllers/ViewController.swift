//
//  ViewController.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import UIKit
import ParseSwift

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Add a property for the password visibility button
    private var passwordVisibilityButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordVisibilityToggle()
        loginButton.tintColor = UIColor(
                red: 255 / 255, green: 160 / 255, blue: 122 / 255, alpha: 1.0)
    }

    private func setupPasswordVisibilityToggle() {
        // Ensure the button is created with a custom type to be able to customize it fully
        passwordVisibilityButton = UIButton(type: .custom)
        
        // Set the images for the button for both states
        let normalImage = UIImage(named: "eyeSlashImage")?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: "eyeImage")?.withRenderingMode(.alwaysOriginal)
        
        // Create a new button configuration for a plain style button
        var config = UIButton.Configuration.plain()
        config.image = normalImage
        config.imagePlacement = .leading  // or .trailing depending on your layout
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .light) // Adjust pointSize as needed
        config.baseForegroundColor = UIColor.black // or any color you want for the image
        
        // Apply the configuration to the passwordVisibilityButton
        passwordVisibilityButton.configuration = config

        // Set the button's content mode
        passwordVisibilityButton.imageView?.contentMode = .scaleAspectFit

        // Set the password text field's rightView to the passwordVisibilityButton
        password.rightView = passwordVisibilityButton
        password.rightViewMode = .always
        
        // Add the action to toggle password visibility
        passwordVisibilityButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        // Set the images for different button states
        passwordVisibilityButton.setImage(normalImage, for: .normal)
        passwordVisibilityButton.setImage(selectedImage, for: .selected)
    }

    @objc private func togglePasswordVisibility() {
        // Toggle the secure text entry of the password field
        password.isSecureTextEntry.toggle()

        // Toggle the selected state of the button, which will change the image
        passwordVisibilityButton.isSelected.toggle()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if we have a logged in user
        // This check is done in viewDidAppear to ensure it's checked every time the view appears
        if User.current != nil {
            navigateToHome()
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        // Check for empty fields first
        guard let usernameText = username.text,
              let passwordText = password.text,
              !usernameText.isEmpty,
              !passwordText.isEmpty else {
            showMissingFieldsAlert()
            return
        }
        
        // Attempt to log in the user
        User.login(username: usernameText, password: passwordText) { [weak self] result in
            DispatchQueue.main.async { // Switch to the main thread for UI work
                switch result {
                case .success(let user):
                    print("✅ Successfully logged in as user: \(user)")
                    self?.navigateToHome()
                case .failure(let error):
                    self?.showAlert(title: "Login Error", message: error.localizedDescription)
                }
            }
        }
    }

    private func showMissingFieldsAlert() {
        showAlert(title: "Oops...", message: "Please make sure all fields are filled out.")
    }
    
    private func showAlert(title: String, message: String) {
        // Present an alert to the user
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func navigateToHome() {
        // Transition to the navigation controller associated with the HomeViewController
        if let profileNavController = storyboard?.instantiateViewController(withIdentifier: "profileNavController") as? UINavigationController {
            // Check for a scene delegate and transition the window's root view controller to the profile navigation controller
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    sceneDelegate.window?.rootViewController = profileNavController
                })
            } else {
                // Fallback in case the scene delegate cannot be retrieved
                // This could navigate within a navigation controller if one is present
                navigationController?.pushViewController(profileNavController.viewControllers.first!, animated: true)
            }
        } else {
            // Handle the case where the profileNavController couldn't be instantiated
            showAlert(title: "Error", message: "Navigation controller could not be instantiated.")
        }
    }
}


