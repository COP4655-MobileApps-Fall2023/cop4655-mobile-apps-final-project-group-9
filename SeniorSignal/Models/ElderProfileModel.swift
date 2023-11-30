//
//  ElderProfileModel.swift
//  SeniorSignal
//
//  Created by Christopher Anastasis on 11/7/23.
//

import Foundation
import ParseSwift
import UIKit

// Define the ElderlyProfile struct to match your Parse Server class structure
struct ElderProfile: ParseObject, Codable {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    // Custom fields must match the keys you created in your Parse Server class
    var caretaker: Pointer<User>?
    var elderName: String?
    var elderAge: String?
    var elderPhone: String?
    var ecName: String?
    var ecPhone: String?
    var ecRelationship: String?
    var elderPic: ParseFile?

    
    
    // Implementing protocol requirements
    static var className: String {
        return "Elderly" // This must match the name of your Parse class
    }
    
    // Required initializer
    init() {}
}
