//
//  HomeViewController.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import UIKit
import ParseSwift

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var caregiverName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var caregiverRole: UILabel!

    
    // Make sure this outlet is connected in your storyboard
    
    var elderlyProfiles: [ElderProfile] = [] // This array will store the fetched elderly profiles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the tableView
        tableView.dataSource = self
        tableView.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
        fetchElderlyProfiles()
        caregiverRole.text = "Caregiver" // Set the role label directly
    }
    
    func loadUserData() {
        if let currentUser = User.current {
            // Assuming 'name' is the key where the user's name is stored
            let userName = currentUser.name ?? "No Name"
            
            DispatchQueue.main.async {
                self.caregiverName.text = userName
                // The roleLabel has already been set in viewWillAppear
            }
        } else {
            // Handle case where there is no logged-in user
            // Redirect to login screen or show appropriate message
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showLoginScreen", sender: self)
            }
        }
    }
        
        func fetchElderlyProfiles() {
            // Replace 'Elderly' with the actual name of your elderly profile class
            let query = ElderProfile.query()
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
        // Cast the dequeued cell to your custom cell class, which should be something like `ElderlyTableViewCell`.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ElderlyCell", for: indexPath) as? ElderlyTableViewCell else {
            fatalError("The dequeued cell is not an instance of ElderlyTableViewCell.")
        }
        let profile = elderlyProfiles[indexPath.row]
        // Customize your cell with the elderly profile information
        
        //cell.textLabel?.text = profile.elderName
        
        cell.elderNameLabel.text = profile.elderName
                
        // Assuming you have an IBOutlet for your imageView named 'elderProfilePic' in your `ElderlyTableViewCell` class
        if let imageUrl = profile.elderPic?.url {
            loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    cell.elderProfilePic.image = image
                    // Ensure that the imageView is a square for the cornerRadius to create a perfect circle
                    cell.elderProfilePic.layer.cornerRadius = cell.elderProfilePic.frame.height / 2
                    cell.elderProfilePic.layer.masksToBounds = true
                }
            }
        } else {
            // Here you might set a default placeholder image if there's no URL
            cell.elderProfilePic.image = UIImage(named: "defaultPlaceholder")
        }
        
        return cell
    }

    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
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

