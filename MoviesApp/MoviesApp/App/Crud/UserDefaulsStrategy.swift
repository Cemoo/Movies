//
//  UserDefaulsStrategy.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import Foundation

final class UserDefaultsStrategy: LocalStorageStrategy {
    
    func saveObject<T>(_ key: String, _ object: T) where T : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error while saving")
        }
        UserDefaults.standard.synchronize()
    }
    
    func getObject<T>(_ key: String, _ object: T.Type) -> T? where T : Decodable {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            if let myObject = try? JSONDecoder().decode(object, from: data) {
                return myObject
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func removeObject(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
