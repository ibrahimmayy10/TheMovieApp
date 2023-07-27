//
//  TVSeriesViewModel.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 25.07.2023.
//

import Foundation

struct TVSeriesListViewModel {
    let imageTVSeriesListViewModel: [TVShow]?
    
}

//extension TVSeriesListViewModel {
//    func numberOfRowsInSection () -> Int {
//        return self.imageTVSeriesListViewModel?.count ?? 0
//    }
//    func tvSeriesAtIndex (_ index: Int) -> TVSeriesViewModel {
//        if let imageTVSeriesListViewModel = self.imageTVSeriesListViewModel[index] {
//
//        }
//        let tvSeries =
//        return TVSeriesViewModel(series: tvSeries)
//    }
//}

struct TVSeriesViewModel {
    let series : TVShow
    
    var tvPosterPath : String {
        return self.tvPosterPath
    }
}
