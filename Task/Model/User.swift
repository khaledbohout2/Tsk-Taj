//
//  Model.swift
//  Task
//
//  Created by Khaled Bohout on 25/06/2021.
//

import Foundation

// MARK: - User
struct User: Codable {
    let name, bdIslamic, email: String
    let phoneNumber, industry, age: String
    

    enum CodingKeys: String, CodingKey {
        case name
        case industry
        case bdIslamic = "bd_islamic"
        case email
        case age
        case phoneNumber = "phone_number"
    }
}
