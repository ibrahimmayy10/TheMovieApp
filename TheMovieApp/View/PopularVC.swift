//
//  PopularVC.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 20.07.2023.
//

import UIKit

class PopularVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var popularTableView: UITableView!
    
//    private var titleListViewModel : ResultsListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularTableView.dataSource = self
        popularTableView.delegate = self
        
//        getData()
        
    }
    
//    func getData() {
//        Webservices().downloadMovies { (movies) in
//            if let movies = movies {
//                for movie in movies {
//                    print("Title : \(movie.title)")
//                }
//                self.titleListViewModel = ResultsListViewModel(titleListViewModel: movies)
//
//                DispatchQueue.main.async {
//                    self.popularTableView.reloadData()
//                }
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleListViewModel == nil ? 0 : self.titleListViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popularTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! PopularTableViewCell
        let movieViewModel = self.titleListViewModel.movieAtIndex(indexPath.row)
        cell.titleLabel.text = movieViewModel.title
        cell.imdbLabel.text = String(movieViewModel.imdb)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secilenFilm = self.titleListViewModel.movieAtIndex(indexPath.row)
        
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as? DetailsVC {
            detailsVC.secilenFilm = secilenFilm
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
}
