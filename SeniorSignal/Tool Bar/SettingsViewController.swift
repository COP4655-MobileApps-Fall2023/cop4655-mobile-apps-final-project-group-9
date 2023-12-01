//
//  SettingsViewController.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/30/23.
//

import UIKit
import ParseSwift

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var caregiverName: UILabel!
    @IBOutlet weak var caregiverProfilePic: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userDateCreated: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var changePassView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var supportView: UIView!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            loadUserData()
        setupViewStyling()
            // Set the tint color for the logoutButton
            logoutButton.tintColor = UIColor(red: 255 / 255, green: 160 / 255, blue: 122 / 255, alpha: 1.0)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Settings"
    }
    
    private func setupViewStyling() {
        // Set rounded corners for the views
        let cornerRadius: CGFloat = 10.0 // You can adjust the corner radius value here
        
        infoView.layer.cornerRadius = cornerRadius
        infoView.layer.masksToBounds = true // This is needed to clip the subviews
        
        changePassView.layer.cornerRadius = cornerRadius
        changePassView.layer.masksToBounds = true
        
        feedbackView.layer.cornerRadius = cornerRadius
        feedbackView.layer.masksToBounds = true
        
        supportView.layer.cornerRadius = cornerRadius
        supportView.layer.masksToBounds = true
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
                    // You can add an alert here to inform the user that the logout failed
                }
            }
        }
    }
    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true // if you want to allow editing
        present(imagePickerController, animated: true)
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
            DispatchQueue.main.async {
                        self.userUsername.text = "Username: \(currentUser.username ?? "Unavailable")"
                        self.userEmail.text = "Email: \(currentUser.email ?? "Unavailable")"
                        if let dateCreated = currentUser.createdAt {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .medium
                            dateFormatter.timeStyle = .none
                            self.userDateCreated.text = "Date Created: \(dateFormatter.string(from: dateCreated))"
                        } else {
                            self.userDateCreated.text = "Date Created: Unavailable"
                        }
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
                        DispatchQueue.main.async {
                            self.caregiverProfilePic.image = UIImage(named: "defaultProfileImage")
                        }
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
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        // Assign the selected image to your UIImageView
        caregiverProfilePic.image = selectedImage
        
        // Dismiss the image picker controller window
        dismiss(animated: true) {
            // After dismissing, proceed to upload the image
            if let imageToUpload = selectedImage, let imageData = imageToUpload.jpegData(compressionQuality: 0.9) {
                // Assuming 'profilePic' is the column name on Parse where the image will be stored
                // And 'User' is your Parse user class
                if var currentUser = User.current {
                    let parseFile = ParseFile(data: imageData)
                    parseFile.save { result in
                        switch result {
                        case .success(let savedFile):
                            // Now that the file is saved, set the user's profilePic to the new file
                            currentUser.profilePic = savedFile
                            currentUser.save { result in
                                switch result {
                                case .success:
                                    print("User data with new image saved successfully")
                                case .failure(let error):
                                    print("Error saving user data: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            print("Error saving file: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the image picker controller window
        dismiss(animated: true, completion: nil)
    }
    
    func navigateToLogin() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavController") as? UINavigationController {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                if let window = windowScene?.windows.first(where: { $0.isKeyWindow }) {
                    window.rootViewController = loginNavController
                    window.makeKeyAndVisible()
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                } else {
                    print("Could not retrieve key window")
                }
            } else {
                print("Could not instantiate view controller with identifier 'LoginNavController'")
            }
        }
    }
}
