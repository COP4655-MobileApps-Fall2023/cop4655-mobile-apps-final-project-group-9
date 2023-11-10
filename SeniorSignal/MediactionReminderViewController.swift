//
//  MediactionReminderViewController.swift
//  SeniorSignal
//
//  Created by Christopher Anastasis on 11/7/23.
//

import UIKit

class MediactionReminderViewController: UIViewController //UITableViewDelegate, UITableViewDataSource
{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return models.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    // TableView connection outlet
    @IBOutlet weak var remindTable: UITableView!
    
    // Add button action for when user wants to add a new reminder
    @IBAction func didTapAdd(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController
        else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Empty array to store info regarding the variables in our 'struct'
    var models = [MedReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table delegate and source to 'self'
        //remindTable.delegate = self
        //remindTable.dataSource = self
    }

}

struct MedReminder {
    let title: String
    let date: Date
    let identifier: String
}
