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
    
    var elderlyProfiles: [ElderProfile] = []  // This array will store the fetched elderly profiles

    override func viewDidLoad() {
      super.viewDidLoad()

      // Customize the appearance of the addNewElderButton
      addNewElderButton.tintColor = UIColor(
        red: 255 / 255, green: 255 / 255, blue: 240 / 255, alpha: 1.0)

      // Set up the tableView
      tableView.dataSource = self
      tableView.delegate = self

      if let items = self.tabBarController?.tabBar.items {
        // Assuming the plus button is the first item, adjust if it's in a different position
        let addButton = items[0]
        addButton.selectedImage = addButton.image?.withRenderingMode(.alwaysOriginal)
        addButton.image = addButton.image?.withRenderingMode(.alwaysOriginal)
      }
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      loadUserData()
      fetchElderlyProfiles()
      caregiverRole.text = "Caregiver"  // Set the role label directly

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
        if let currentUser = User.current {
            let userName = currentUser.name ?? "No Name"
            DispatchQueue.main.async {
                self.caregiverName.text = userName
                self.caregiverProfilePic.contentMode = .scaleAspectFill
                self.caregiverProfilePic.layer.cornerRadius = self.caregiverProfilePic.frame.size.width / 2
                self.caregiverProfilePic.clipsToBounds = true
            }
            
            // If the profilePic is a ParseFile, fetch its data
            if let profilePic = currentUser.profilePic {
                profilePic.fetch { result in
                    switch result {
                    case .success(let fetchedFile):
                        // If the file has a valid URL, download the image data
                        if let url = fetchedFile.url {
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                if let data = data {
                                    let image = UIImage(data: data)
                                    DispatchQueue.main.async {
                                        self.caregiverProfilePic.image = image ?? UIImage(named: "defaultProfileImage")
                                    }
                                } else if let error = error {
                                    print("Error downloading image: \(error)")
                                }
                            }.resume()
                        }
                    case .failure(let error):
                        print("Error fetching ParseFile: \(error)")
                    }
                }
            } else {
                // If no profile picture is set, use a default image
                DispatchQueue.main.async {
                    self.caregiverProfilePic.image = UIImage(named: "defaultProfileImage")
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
      // elderly profile class
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65 // Set your desired height
        }

    // This function configures and provides a cell to display for a given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ElderlyCell", for: indexPath) as? ElderlyTableViewCell else {
            fatalError("The dequeued cell is not an instance of ElderlyTableViewCell.")
        }
        
        let profile = elderlyProfiles[indexPath.row]
        cell.elderNameLabel.text = profile.elderName
        
        // Set a placeholder image immediately
        cell.elderProfilePic.image = UIImage(named: "defaultPlaceholder")
        
        // Load the elderPic if it is a ParseFile
        if let elderPicFile = profile.elderPic {
            elderPicFile.fetch { result in
                switch result {
                case .success(let fetchedFile):
                    if let url = fetchedFile.url {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let data = data {
                                let image = UIImage(data: data)
                                DispatchQueue.main.async {
                                    // Check if the cell is still visible and corresponds to the current indexPath
                                    if tableView.cellForRow(at: indexPath) == cell {
                                        cell.elderProfilePic.image = image
                                        cell.elderProfilePic.layer.cornerRadius = cell.elderProfilePic.frame.height / 2
                                        cell.elderProfilePic.layer.masksToBounds = true
                                    }
                                }
                            } else if let error = error {
                                print("Error downloading image: \(error)")
                            }
                        }.resume()
                    }
                case .failure(let error):
                    print("Error fetching ParseFile: \(error)")
                }
            }
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
        let indexPath = tableView.indexPathForSelectedRow
      {
        detailVC.elderlyProfile = elderlyProfiles[indexPath.row]
      }
    }

  }

