//
//  ViewControllerTableViewCell.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 23.07.2023.
//

import UIKit

protocol ViewControllerTableViewCellDelegate: AnyObject {
    func didTapMediaItem(_ mediaItem: MediaItem)
}

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageTVSeriesListViewModel : TVSeriesListViewModel!
    var tvShows = [TVShow]()
    
    var imageMoviesListViewModel : ResultsListViewModel!
    var movies = [Movie]()
    
    var imagePersonListViewModel : PersonListViewModel!
    var person = [Person]()
    
    weak var delegate: ViewControllerTableViewCellDelegate?
    
    var type = [HeaderTypes(sectionType: "Popular Movies"), HeaderTypes(sectionType: "Popular TV Series"), HeaderTypes(sectionType: "Popular Actors")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        self.movies = []
        self.tvShows = []
        self.person = []
        self.collectionView.reloadData()
    }
    
    func configureMovies(with movies: ResultsListViewModel) {
        self.imageMoviesListViewModel = movies
        Webservices().downloadMovies { movie in
            if let movie = movie {
                self.movies = movie
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func configureTVSeries(with tvSeries: TVSeriesListViewModel) {
        self.imageTVSeriesListViewModel = tvSeries
        Webservices().downloadTVSeris { show in
            if let shows = show {
                self.tvShows = shows
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func configurePerson(with person: PersonListViewModel) {
        self.imagePersonListViewModel = person
        Webservices().downloadPerson { person in
            if let person = person {
                self.person = person
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension ViewControllerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let currentViewModel = type[collectionView.tag].sectionType
        
        if currentViewModel == "Popular Movies" {
            return movies.count
        } else if currentViewModel == "Popular TV Series" {
            return tvShows.count
        } else if currentViewModel == "Popular Actors" {
            return person.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularTVSeriesCell", for: indexPath) as! CollectionViewCell
        if collectionView.tag == 0, !movies.isEmpty {
            let movie = movies[indexPath.item]
            if let posterPath = movie.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                cell.imageView.load(url: posterURL)
            }
        } else if collectionView.tag == 1, !tvShows.isEmpty {
            let tvShow = tvShows[indexPath.item]
            if let tvPosterPath = tvShow.tvPosterPath, let tvPosterURL = URL(string: "https://image.tmdb.org/t/p/w500\(tvPosterPath)") {
                cell.imageView.load(url: tvPosterURL)
            }
        } else if collectionView.tag == 2, !person.isEmpty {
            let person = person[indexPath.item]
            if let profilePath = person.profilePath, let profileURL = URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)") {
                cell.imageView.load(url: profileURL)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell(_:)))
        collectionView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapCell(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: location) {
            let currentViewModel = type[collectionView.tag].sectionType
            var selectedData: Any?
            
            if currentViewModel == "Popular Movies" {
                selectedData = movies[indexPath.item]
            } else if currentViewModel == "Popular TV Series" {
                selectedData = tvShows[indexPath.item]
            } else if currentViewModel == "Popular Actors" {
                selectedData = person[indexPath.item]
            } else {
                selectedData = nil
            }
            
            if let imageURLString = (selectedData as? TVShow)?.tvPosterPath ?? (selectedData as? Movie)?.posterPath ?? (selectedData as? Person)?.profilePath,
               let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(imageURLString)") {
                
                let mediaItem: MediaItem
                
                if let movie = selectedData as? Movie {
                    mediaItem = MediaItem(imageURL: imageURL, title: movie.title, imdb: movie.voteAverage, description: movie.overview)
                } else if let tvShow = selectedData as? TVShow {
                    mediaItem = MediaItem(imageURL: imageURL, title: tvShow.name, imdb: tvShow.voteAverage, description: tvShow.overview)
                } else if let person = selectedData as? Person {
                    mediaItem = MediaItem(imageURL: imageURL, title: person.name, imdb: 0, description: "")
                } else {
                    return
                }
                
                delegate?.didTapMediaItem(mediaItem)
                    
            }
        }
        
    }
    
    
}
