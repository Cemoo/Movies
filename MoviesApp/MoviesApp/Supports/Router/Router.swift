//
//  Router.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation

final class Router {
    private static let baseUrl = "https://api.themoviedb.org/3/movie/"
    private static let apiKey: String = "fd2b04342048fa2d5f728561866ad52a"
    
    //https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=fd2b04342048fa2d5f728561866ad52a&page=1
    
    static func getUrl(_ route: Routes) -> URL {
        switch route {
        case .movies(let pageNo):
            return URL(string: baseUrl + "popular?language=en-US&api_key=\(apiKey)&page=\(pageNo)")!
        case .movieDetail(let movieId):
            return URL(string: baseUrl + "\(movieId)?api_key=\(apiKey)")!
        }
    }
    
    enum Routes {
        case movies(Int), movieDetail(Int)
    }
}
