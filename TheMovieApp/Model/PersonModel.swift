//
//  PersonViewModel.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 25.07.2023.
//

import Foundation

struct Person: Codable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case title = "original_title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(profilePath, forKey: .profilePath)
    }
}

struct PersonResponse: Codable {
    let results: [Person]
}

