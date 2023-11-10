//
//  HomeViewController.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import UIKit
import ParseSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assuming 'User' is your Parse subclass and it has a 'name' field.
        if let currentUser = User.current,
           let name = currentUser.name {  // Make sure 'name' is a property of your User subclass
            welcomeLabel.text = "Welcome, \(name)!"
        } else {
            welcomeLabel.text = "Welcome!"
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        User.logout { (result: Result<Void, ParseError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("User logged out successfully")
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate,
                       let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                        // Create a navigation controller with the loginViewController at its root
                        let navigationController = UINavigationController(rootViewController: loginViewController)
                        
                        // Transition to the new navigation controller
                        UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            sceneDelegate.window?.rootViewController = navigationController
                        })
                    }
                case .failure(let error):
                    print("Logout failed: \(error.localizedDescription)")
                    // ... additional error handling if necessary ...
                }
            }
        }
    }
}
