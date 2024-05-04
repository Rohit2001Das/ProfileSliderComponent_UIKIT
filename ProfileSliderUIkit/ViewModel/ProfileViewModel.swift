//
//  ProfileViewModel.swift
//  ProfileSliderUIkit
//
//  Created by ROHIT DAS on 03/05/24.
//

import Foundation

class ProfileViewModel {
    private var profiles: [Profile] = []
    
    var numberOfProfiles: Int {
        return profiles.count
    }
    
    func profile(at index: Int) -> Profile? {
        guard index >= 0, index < profiles.count else {
            return nil
        }
        return profiles[index]
    }
    
    func loadProfiles(completion: @escaping () -> Void) {
        if let path = Bundle.main.path(forResource: "@Mock-profiles", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonDict = json as? [String: Any], let userData = jsonDict["data"] as? [String: Any], let usersData = userData["users"] as? [[String: Any]] {
                    profiles = usersData.compactMap { userData in
                        return Profile(data: userData)
                    }
                    
                    completion()
                }
            } catch {
                print("Error loading JSON: \(error)")
            }
        } else {
            print("profiles.json not found in Mock folder")
        }
    }
}
