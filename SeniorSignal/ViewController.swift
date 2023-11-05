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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        // Transition to the HomeViewController
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            // Check for a scene delegate and transition the window's root view controller to the home view controller
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    sceneDelegate.window?.rootViewController = homeViewController
                })
            } else {
                // Fallback in case the scene delegate cannot be retrieved
                // This could navigate within a navigation controller if one is present
                navigationController?.pushViewController(homeViewController, animated: true)
            }
        } else {
            // Handle the case where the HomeViewController couldn't be instantiated
            showAlert(title: "Error", message: "HomeViewController could not be instantiated.")
        }
    }
}


