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
    var elderlyProfile: Elderly?

    // Example outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    // Add more outlets as needed

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        // Use the elderlyProfile to configure the view
        nameLabel.text = elderlyProfile?.elderName
        ageLabel.text = "\(elderlyProfile?.elderAge ?? "") years old"
        // Configure other UI elements with elder profile data
    }
}

