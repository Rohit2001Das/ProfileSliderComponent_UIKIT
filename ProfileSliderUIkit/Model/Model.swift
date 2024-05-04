//
//  Model.swift
//  ProfileSliderUIkit
//
//  Created by ROHIT DAS on 03/05/24.
//

import Foundation

struct Profile {
    let name: String
    let profileImageURL: URL
    let profession: String
    let degree: String
    let age: Int?
    let height: String?

    init?(data: [String: Any]) {
        guard let name = data["name"] as? String,
              let profileImageString = data["profileImage"] as? String,
              let profileImageURL = URL(string: profileImageString),
              let profession = data["profession"] as? String,
              let degree = data["degree"] as? String else {
            return nil
        }

        self.name = name
        self.profileImageURL = profileImageURL
        self.profession = profession
        self.degree = degree
        self.age = data["age"] as? Int
        self.height = data["height"] as? String
    }
}
