//
//  UserModel.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import Foundation
import ParseSwift

struct User: ParseUser {
    // Other custom fields you might want to add
    var emailVerified: Bool?
    var name: String? // Example of a custom field
    var originalData: Data?
    var profilePic: ParseFile?

    // Required by ParseUser
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    // Required for authentication
    var username: String?
    var email: String?
    var password: String?

    // Auth data for federated authentication (e.g., Facebook login)
    var authData: [String: [String: String]?]?

    // Implementing the required init
    init() {
        // Initialize all your properties to their defaults here
    }
    
    // Use this initializer for custom initialization, if needed
    init(username: String, password: String, email: String, name: String) {
        self.username = username
        self.password = password
        self.email = email
        self.name = name
    }
}

// If you are using custom keys, make sure to tell Parse about them:
extension User {
    enum CodingKeys: String, CodingKey {
        case emailVerified = "emailVerified"
        case name = "name"
        // ParseUser keys
        case objectId = "objectId"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case ACL = "ACL"
        case username = "username"
        case email = "email"
        case password = "password"
        case authData = "authData"
        case profilePic = "profilePic"
        
    }
}
