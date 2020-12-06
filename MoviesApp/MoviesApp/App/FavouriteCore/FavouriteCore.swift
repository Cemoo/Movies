//
//  FavouriteCore.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import Foundation

protocol FavouriteProtocol: class {
    func add(_ item: Movie)
    func delete(_ item: Movie)
    func get() -> [Movie]
}

final class FavouriteFlow: FavouriteProtocol {
            
    private var savingStrategy: LocalStorageStrategy!
    
    init(_ savingStrategy: LocalStorageStrategy) {
        self.savingStrategy = savingStrategy
    }
    
    func add(_ item: Movie) {
        var movies = get()
        movies.append(item)
        savingStrategy.saveObject(StorageKeys.favouriteMovies.rawValue, movies)
    }
    
    func delete(_ item: Movie) {
        var movies = get()
        movies = movies.filter({$0.id != item.id})
        savingStrategy.saveObject(StorageKeys.favouriteMovies.rawValue, movies)
    }
    
    func get() -> [Movie] {
        let movies = savingStrategy.getObject(StorageKeys.favouriteMovies.rawValue, [Movie].self) ?? []
        var tempMovies: [Movie] = []
        for i in 0..<movies.count {
            var movie = movies[i]
            movie.isFavorite = true
            tempMovies.append(movie)
        }
        
        return tempMovies
    }

}
