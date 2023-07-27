//
//  ViewController.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 20.07.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewControllerTableViewCellDelegate {
    
    @IBOutlet weak var anasayfaBtn: UIImageView!
    @IBOutlet weak var favoriBtn: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var type = [HeaderTypes(sectionType: "Popular Movies"), HeaderTypes(sectionType: "Popular TV Series"), HeaderTypes(sectionType: "Popular Actors")]
    
    var imageMoviesListViewModel : ResultsListViewModel?
    var imageTVSeriesListViewModel : TVSeriesListViewModel?
    var imagePersonListViewModel : PersonListViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        favoriBtn.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToFavoriteVC))
        favoriBtn.addGestureRecognizer(gestureRecognizer)
        
        getDataMovies()
        getDataTVSeries()
        getDataPerson()

    }

    func getDataTVSeries() {
        Webservices().downloadTVSeris { (tvSeries) in
            if let tvSeries = tvSeries {
                for series in tvSeries {
//                    print(series.tvPosterPath)
                }
                self.imageTVSeriesListViewModel = TVSeriesListViewModel(imageTVSeriesListViewModel: tvSeries)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getDataMovies() {
        Webservices().downloadMovies { (movies) in
            if let movies = movies {
                for movie in movies {
//                    print(movie.posterPath)
                }
                self.imageMoviesListViewModel = ResultsListViewModel(imageMoviesListViewModel: movies)
                    
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getDataPerson() {
        Webservices().downloadPerson { (person) in
            if let person = person {
                
                self.imagePersonListViewModel = PersonListViewModel(imagePersonListViewModel: person)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    @objc func goToFavoriteVC () {
        performSegue(withIdentifier: "toFavoriteVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return type.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return type[section].sectionType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularTVSeriesCell", for: indexPath) as! ViewControllerTableViewCell
        cell.collectionView.tag = indexPath.section
        let currentViewModel = type[indexPath.section].sectionType
         if currentViewModel == "Popular Movies" {
            cell.configureMovies(with: imageMoviesListViewModel ?? ResultsListViewModel(imageMoviesListViewModel: nil))
        } else if currentViewModel == "Popular TV Series" {
            cell.configureTVSeries(with: imageTVSeriesListViewModel ?? TVSeriesListViewModel(imageTVSeriesListViewModel: nil))
        } else if currentViewModel == "Popular Actors" {
            cell.configurePerson(with: imagePersonListViewModel ?? PersonListViewModel(imagePersonListViewModel: nil))
        }
        cell.delegate = self
        return cell
    }
    
    func didTapMediaItem(_ mediaItem: MediaItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "toDetailsVC") as! DetailsVC
        detailsVC.selectedMediaItem = mediaItem
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? ViewControllerTableViewCell {
            cell.configure()
        }
    }
    
}

