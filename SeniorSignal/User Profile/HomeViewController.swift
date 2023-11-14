//
//  HomeViewController.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import UIKit
import ParseSwift

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! // Make sure this outlet is connected in your storyboard
    
    var elderlyProfiles: [Elderly] = [] // This array will store the fetched elderly profiles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Fetch elderly profiles when the view loads
        fetchElderlyProfiles()
        
        if let currentUser = User.current,
           let name = currentUser.name {
            welcomeLabel.text = "Welcome, \(name)!"
        } else {
            welcomeLabel.text = "Welcome!"
        }
    }
    
    func fetchElderlyProfiles() {
        // Replace 'Elderly' with the actual name of your elderly profile class
        let query = Elderly.query()
        query.find { result in
            switch result {
            case .success(let profiles):
                self.elderlyProfiles = profiles
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching elderly profiles: \(error.localizedDescription)")
            }
        }
    }
    
    // This function is used to tell the table view how many rows to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elderlyProfiles.count
    }

    // This function configures and provides a cell to display for a given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElderlyCell", for: indexPath)
        let profile = elderlyProfiles[indexPath.row]
        // Customize your cell with the elderly profile information
        cell.textLabel?.text = profile.elderName
        return cell
    }

    // This method prepares for the segue before it happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowElderDetail",
           let detailVC = segue.destination as? ElderDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            detailVC.elderlyProfile = elderlyProfiles[indexPath.row]
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        User.logout { (result: Result<Void, ParseError>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("User logged out successfully")
                    self.navigateToLogin()
                case .failure(let error):
                    print("Logout failed: \(error.localizedDescription)")
                    // Present an error message to the user
                }
            }
        }
    }
    
    func navigateToLogin() {
        // Assuming that 'LoginNavController' is the storyboard ID for your login navigation controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavController") as? UINavigationController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                // Here you set the rootViewController to the login navigation controller
                window.rootViewController = loginNavController
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
            }
        }
    }
}

// You will need to define the Elderly struct/class that conforms to ParseObject and Codable
// Ensure that it matches the fields and types you have defined in your Parse server
