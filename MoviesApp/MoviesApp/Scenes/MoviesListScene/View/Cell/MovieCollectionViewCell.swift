//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 4.12.2020.
//

import UIKit

protocol FavouriteStatusDelegate: class {
    func sendFavouriteAction(with status: Bool, movie: Movie)
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    weak var favouriteActionDelegate: FavouriteStatusDelegate!
    
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
            self.isFavourite = movie.isFavorite
        }
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        isFavourite.toggle()
        favouriteActionDelegate.sendFavouriteAction(with: self.isFavourite, movie: self.movie)
    }
    
    
    override func prepareForReuse() {
        self.movie = nil
        self.isFavourite = false
        self.movieImageView.image = nil
        self.movieNameLabel.text = ""
    }
}
