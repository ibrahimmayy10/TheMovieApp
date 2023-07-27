//
//  CollectionViewCell.swift
//  TheMovieApp
//
//  Created by İbrahim AY on 23.07.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var didSelectItemAt: ((URL) -> Void)?
    
}
