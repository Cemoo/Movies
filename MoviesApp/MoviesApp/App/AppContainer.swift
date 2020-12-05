//
//  AppContainer.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation
import MoviesAPI

let app = AppContainer()

final class AppContainer {
    let service = API(URLSession(configuration: .default))
    
    let favouriteFlow = FavouriteFlow<Movie>(UserDefaultsStrategy())
    
    let poster_path = "https://image.tmdb.org/t/p/"
}
