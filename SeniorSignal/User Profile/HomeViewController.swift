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
    @IBOutlet weak var caregiverProfilePic: UIImageView!
    @IBOutlet weak var addNewElderButton: UIButton!
    
    //Toolbar buttons
    @IBOutlet weak var homeToolBarButton: UIBarButtonItem!
    @IBOutlet weak var calendarToolBarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsToolBarButton: UIBarButtonItem!
    
    var elderlyProfiles: [ElderProfile] = [] // This array will store the fetched elderly profiles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the appearance of the addNewElderButton
        addNewElderButton.tintColor = UIColor(red: 255/255, green: 255/255, blue: 240/255, alpha: 1.0)
        
        
        
        // Set up the tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        if let items = self.tabBarController?.tabBar.items {
            // Assuming the plus button is the first item, adjust if it's in a different position
            let addButton = items[0]
            addButton.selectedImage = addButton.image?.withRenderingMode(.alwaysOriginal)
            addButton.image = addButton.image?.withRenderingMode(.alwaysOriginal)
        }
        
        
//        let testImage = UIImage(named: "young adult woman smiling") // Replace with an image that you have in your assets
//        caregiverProfilePic.image = testImage
//        caregiverProfilePic.layer.cornerRadius = caregiverProfilePic.frame.size.width / 2
//        caregiverProfilePic.clipsToBounds = true
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
        fetchElderlyProfiles()
        caregiverRole.text = "Caregiver" // Set the role label directly
        
        //Dynamically display the title of the navigation title
        self.navigationItem.title = "Home"
        
        // Add this line to show the toolbar
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide the toolbar when the view is about to disappear
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    func loadUserData() {
        // Check if there is a current logged-in user
        if let currentUser = User.current {
            // Fetch the user's name and set it to the UILabel
            let userName = currentUser.name ?? "No Name"
            DispatchQueue.main.async {
                self.caregiverName.text = userName
                // Set a default image while the profile picture is being fetched
                self.caregiverProfilePic.image = UIImage(named: "defaultProfileImage")
                self.caregiverProfilePic.contentMode = .scaleAspectFit
                self.caregiverProfilePic.layer.cornerRadius = self.caregiverProfilePic.frame.size.width / 2
                self.caregiverProfilePic.clipsToBounds = true
            }
            
            // Check if the user has a profile picture set
            if let profilePicFile = currentUser.profilePic {
                // Fetch the profile picture file
                profilePicFile.fetch { result in
                    switch result {
                    case .success(let file):
                        // Get the URL string from the file and attempt to convert it to a URL
                        if let urlString = file.url?.absoluteString {
                            print("Profile image URL: \(urlString)") // For debugging
                            guard let url = URL(string: urlString) else {
                                print("Invalid URL")
                                return
                            }
                            // Load the image from the URL and set it to the UIImageView
                            self.loadImage(from: url) { image in
                                DispatchQueue.main.async {
                                    self.caregiverProfilePic.image = image ?? UIImage(named: "defaultProfileImage")
                                }
                            }
                        }
                    case .failure(let error):
                        // Handle the error if the profile picture could not be fetched
                        print("Could not fetch profile picture: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // If no user is logged in, handle accordingly (e.g., redirect to login)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ElderlyCell", for: indexPath) as? ElderlyTableViewCell else {
            fatalError("The dequeued cell is not an instance of ElderlyTableViewCell.")
        }
        let profile = elderlyProfiles[indexPath.row]
        cell.elderNameLabel.text = profile.elderName

        // Cancel any existing image loading task
        cell.imageLoadingTask?.cancel()

        // Start a new task to load the image
        if let imageUrl = profile.elderPic?.url {
            // Set a placeholder image immediately
            cell.elderProfilePic.image = UIImage(named: "defaultPlaceholder")
            cell.imageLoadingTask = loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    // Check if the cell is still visible and corresponds to the current indexPath
                    if tableView.cellForRow(at: indexPath) == cell {
                        cell.elderProfilePic.image = image
                        cell.elderProfilePic.layer.cornerRadius = cell.elderProfilePic.frame.height / 2
                        cell.elderProfilePic.layer.masksToBounds = true
                    }
                }
            }
        } else {
            // Here you might set a default placeholder image if there's no URL
            cell.elderProfilePic.image = UIImage(named: "defaultPlaceholder")
        }
        
        return cell
    }


    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
        return task
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

