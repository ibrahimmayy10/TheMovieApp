//
//  Webservices.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 21.07.2023.
//

import Foundation
import UIKit

class Webservices {
    
    func downloadMovies (completion : @escaping ([Movie]?) -> Void) {
        
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=3e4dbb0176e7f36f4df0a3b954f5a609"
        
        guard let url = URL(string: url) else { return completion(nil) }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return completion(nil) }
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(movieResponse.results)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    func downloadTVSeris (completion : @escaping ([TVShow]?) -> Void) {
        let url = "https://api.themoviedb.org/3/tv/popular?api_key=3e4dbb0176e7f36f4df0a3b954f5a609"
        
        guard let url = URL(string: url) else { return completion(nil) }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return completion(nil) }
            do {
                let decoder = JSONDecoder()
                let tvSeriesResponse = try decoder.decode(PopularTVShowsResponse.self, from: data)
                completion(tvSeriesResponse.results)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func downloadPerson (completion : @escaping ([Person]?) -> Void) {
        
        let url = "https://api.themoviedb.org/3/person/popular?api_key=3e4dbb0176e7f36f4df0a3b954f5a609"
        
        guard let url = URL(string: url) else { return completion(nil) }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return completion(nil) }
            do {
                let decoder = JSONDecoder()
                let personResponse = try decoder.decode(PersonResponse.self, from: data)
                completion(personResponse.results)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
