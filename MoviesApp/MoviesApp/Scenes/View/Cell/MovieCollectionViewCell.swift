//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 4.12.2020.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    var movie: Movie! {
        didSet {
            self.setMovie()
        }
    }
    
    var isFavourite: Bool = false
    
    private func setMovie() {
        if let movie = movie {
            self.movieNameLabel.text = movie.originalTitle ?? ""
            self.movieImageView.downloadImage(movie.posterPath ?? "")
        }
    }
    
    override func prepareForReuse() {
        self.movie = nil
        self.movieImageView.image = nil
        self.movieNameLabel.text = ""
    }
}
