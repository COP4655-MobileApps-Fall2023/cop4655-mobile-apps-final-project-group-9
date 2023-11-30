//
//  ElderDetailViewController.swift
//  SeniorSignal
//
//  Created by Duncan Mckinley on 11/11/23.
//

import UIKit
import ParseSwift

class ElderDetailViewController: UIViewController {
    // Assume that Elderly is your Parse model class
    var elderlyProfile: ElderProfile?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var elderProfileImage: UIImageView!
    
    @IBOutlet weak var medicationReminderSquare: UIView!
    @IBOutlet weak var calendarSquare: UIView!
    @IBOutlet weak var supportRequestSquare: UIView!
    @IBOutlet weak var emergencyContactSquare: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        medicationReminderSquare.layer.cornerRadius = 20 // Adjust this value to get the desired roundness
        calendarSquare.layer.cornerRadius = 20
        supportRequestSquare.layer.cornerRadius = 20
        emergencyContactSquare.layer.cornerRadius = 20
        medicationReminderSquare.clipsToBounds = true
        calendarSquare.clipsToBounds = true
        supportRequestSquare.clipsToBounds = true
        emergencyContactSquare.clipsToBounds = true
    }
    
    private func configureView() {
        // Use the elderlyProfile to configure the view
        nameLabel.text = elderlyProfile?.elderName
        ageLabel.text = "\(elderlyProfile?.elderAge ?? "") years old"
        
        // Set a default image while the profile picture is being fetched
        elderProfileImage.image = UIImage(named: "defaultProfileImage")
        elderProfileImage.contentMode = .scaleAspectFill
        elderProfileImage.layer.cornerRadius = elderProfileImage.frame.size.width / 2
        elderProfileImage.clipsToBounds = true
        
        // Check if the elder profile has a profile picture set
        if let profilePicFile = elderlyProfile?.elderPic {
            // Fetch the profile picture file
            profilePicFile.fetch { result in
                switch result {
                case .success(let file):
                    // Get the URL string from the file and attempt to convert it to a URL
                    if let urlString = file.url?.absoluteString, let url = URL(string: urlString) {
                        self.loadImage(from: url) { image in
                            DispatchQueue.main.async {
                                self.elderProfileImage.image = image ?? UIImage(named: "defaultProfileImage")
                            }
                        }
                    }
                case .failure(let error):
                    // Handle the error if the profile picture could not be fetched
                    print("Could not fetch elder's profile picture: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Assuming you have this method similar to how you load the caregiver's image
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
    
    
}

