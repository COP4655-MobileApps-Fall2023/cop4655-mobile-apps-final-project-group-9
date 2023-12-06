//
//  ForgotPasswordViewController.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import UIKit
import ParseSwift

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.borderStyle = .roundedRect
        
        email.layer.borderColor = UIColor.darkGray.cgColor // Choose a suitable color
        email.layer.borderWidth = 1.0
        email.layer.cornerRadius = 5.0 // Adjust the corner radius as needed
        
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        
      //Dynamically display the title of the navigation title
      self.navigationItem.title = "Forgot Password"
        
    }
}
