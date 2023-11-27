//
//  ElderlyTableViewCell.swift
//  SeniorSignal
//
//  Created by Carlos Villatoro on 11/26/23.
//

import Foundation
import UIKit

class ElderlyTableViewCell: UITableViewCell {
    @IBOutlet weak var elderProfilePic: UIImageView!
    @IBOutlet weak var elderNameLabel: UILabel!
    
    var imageLoadingTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel the image loading task if the cell is being reused
        imageLoadingTask?.cancel()
        // Remove the current image so it doesn't show in the reused cell
        elderProfilePic.image = nil
    }
    
}
