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
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 4
    }
    
    var movie: Movie! {
        didSet {
            self.setMovie()
        }
    }
    
    var isFavourite: Bool = false {
        didSet {
            if isFavourite {
                self.favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    private func setMovie() {
        if let movie = movie {
            self.movieNameLabel.text = movie.originalTitle ?? ""
            self.movieImageView.downloadImage(movie.posterPath ?? "")
        }
    }
    
    override func prepareForReuse() {
        self.movie = nil
        self.isFavourite = false
        self.movieImageView.image = nil
        self.movieNameLabel.text = ""
    }
}
