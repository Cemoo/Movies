//
//  MovieDetailBuilder.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import UIKit

struct MovieDetailBuilder {
    static func make(with viewModel: MovieDetailViewModelProtocol) -> MovieDetailVC {
        let movieDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        movieDetailVC.viewModel = viewModel
        return movieDetailVC
    }
}
