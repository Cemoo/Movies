//
//  MockMoviesAPI.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation
import MoviesAPI

class MockMoviesAPI: APIProtocol {
    
    private var movies: [Movie]!
    private var mockMovieResponse: MovieResponse!
    
    init(_ response: MovieResponse) {
        self.mockMovieResponse = response
    }
    
    func fetch(from url: URL, _ method: APIMethod, _ requestData: Data?, _ completionHandler: @escaping (APIResult<Data>) -> Void) {
        
        let data = try! JSONEncoder().encode(mockMovieResponse)
        completionHandler(APIResult.success(data))
    }
}
