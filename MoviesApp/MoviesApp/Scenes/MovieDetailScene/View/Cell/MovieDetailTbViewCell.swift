//
//  MovieDetailTbViewCell.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import UIKit

class MovieDetailTbViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var index: Int = 0
    var movieDetail: MovieDetail!
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
    func setDetails() {
        if index == 0 {
            titleLabel.text = movieDetail.originalTitle ?? ""
            descriptionLabel.text = movieDetail.overview ?? ""
        } else {
            titleLabel.text = "Vote Count"
            descriptionLabel.text = "\(movieDetail.voteCount ?? 0)"
        }
        
    }

}
