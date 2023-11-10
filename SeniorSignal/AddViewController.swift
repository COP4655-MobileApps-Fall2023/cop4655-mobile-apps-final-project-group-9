//
//  AddViewController.swift
//  SeniorSignal
//
//  Created by Christopher Anastasis on 11/9/23.
//

import UIKit

class AddViewController: UIViewController {
    
    // Connecting outlets to 'AddViewController'
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Function that hands back the medication reminder info
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring 'Save' button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))

    }
    
    // Function that saves the reminder
    @objc func didTapSaveButton() {
        if let remindText = reminderTextField.text, !remindText.isEmpty,
           let descriptionText = descriptionTextField.text, !descriptionText.isEmpty {
            
            let targetDate = datePicker.date
        }
    }

}
