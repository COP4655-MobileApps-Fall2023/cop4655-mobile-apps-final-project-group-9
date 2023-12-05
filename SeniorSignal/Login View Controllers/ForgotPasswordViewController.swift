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
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        
      //Dynamically display the title of the navigation title
      self.navigationItem.title = "Forgot Password"
        
    }
}
