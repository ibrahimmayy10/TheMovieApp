//
//  TVSeriesModel.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 22.07.2023.
//

import Foundation


struct TVShow: Codable {
    let id: Int
    let name: String
    let voteAverage: Double
    let overview: String
    let tvPosterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case voteAverage = "vote_average"
        case overview
        case tvPosterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        overview = try container.decode(String.self, forKey: .overview)
        tvPosterPath = try container.decodeIfPresent(String.self, forKey: .tvPosterPath)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(overview, forKey: .overview)
        try container.encode(tvPosterPath, forKey: .tvPosterPath)
    }
}

struct PopularTVShowsResponse: Codable {
    let results: [TVShow]
}
