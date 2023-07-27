//
//  Model.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 12.07.2023.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: Date
    let voteAverage: Double
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter.movieAPIFormatter
        if let date = dateFormatter.date(from: releaseDateString) {
            releaseDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .releaseDate, in: container, debugDescription: "Error")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        
        let dateFormatter = DateFormatter.movieAPIFormatter
        let releaseDateString = dateFormatter.string(from: releaseDate)
        try container.encode(releaseDateString, forKey: .releaseDate)
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

extension DateFormatter {
    static let movieAPIFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
