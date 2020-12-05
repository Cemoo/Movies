//
//  FavouriteCore.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import Foundation

protocol FavouriteProtocol: class {
    
    associatedtype Item = Movie
    
    func add(_ item: Item)
    func delete(_ item: Item)
    func get() -> [Item]
}

final class FavouriteFlow<Item>: FavouriteProtocol {
    
    typealias Item = Movie
    
    var favouriteMovies: [Movie] = []
    
    private var savingStrategy: LocalStorageStrategy!
    
    init(_ savingStrategy: LocalStorageStrategy) {
        self.savingStrategy = savingStrategy
    }
    
    func add(_ item: Movie) {
        favouriteMovies.append(item)
        savingStrategy.saveObject(StorageKeys.favouriteMovies.rawValue, favouriteMovies)
    }
    
    func delete(_ item: Movie) {
        favouriteMovies = favouriteMovies.filter({$0.id != item.id ?? 0})
        savingStrategy.saveObject(StorageKeys.favouriteMovies.rawValue, favouriteMovies)
    }
    
    func get() -> [Movie] {
        return savingStrategy.getObject(StorageKeys.favouriteMovies.rawValue, [Movie].self) ?? []
    }

}
