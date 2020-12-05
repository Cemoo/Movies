//
//  LocalStorageStrategy.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import Foundation

protocol LocalStorageStrategy: class {
   func saveObject<T>(_ key: String, _ object: T) where T: Encodable
   func getObject<T>(_ key: String, _ object: T.Type) -> T? where T: Decodable
   func removeObject(_ key: String)
}

enum StorageKeys: String {
    case favouriteMovies = "favouriteMovies"
}
