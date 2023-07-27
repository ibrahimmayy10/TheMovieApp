//
//  MovieViewModel.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 21.07.2023.
//

import Foundation

struct ResultsListViewModel {
    let imageMoviesListViewModel : [Movie]?
}

//extension ResultsListViewModel {
//    func numberOfRowsInSection () -> Int {
//        return self.imageMoviesListViewModel.count
//    }
//    func movieAtIndex (_ index : Int) -> ResultsViewModel {
//        let movie = self.imageMoviesListViewModel[index]
//        return ResultsViewModel(movies : movie)
//    }
//}

struct ResultsViewModel {
    let movies : Movie
    
    var posterPath : String {
        return self.posterPath
    }
}
