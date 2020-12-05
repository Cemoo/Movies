//
//  ResourceLoader.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation

class ResourceLoader {
    static func getMovies() -> MovieResponse {
        let bundle = Bundle.main
        let url = bundle.url(forResource: "Movies", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        let decoder = Decoders.plainDateDecoder
        let movieResponse = try! decoder.decode(MovieResponse.self, from: data)
        return movieResponse
    }
    
    static func getMovieDetail() -> MovieDetail {
        let bundle = Bundle.main
        let url = bundle.url(forResource: "MovieDetail", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        let decoder = Decoders.plainDateDecoder
        let movieDetail = try! decoder.decode(MovieDetail.self, from: data)
        return movieDetail
    }
}
