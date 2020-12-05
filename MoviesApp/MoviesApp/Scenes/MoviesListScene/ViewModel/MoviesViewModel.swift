//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation
import MoviesAPI

protocol MoviesViewModelProtocol: class {
    var delegate: MoviesViewModelDelegate! {get set}
    var movies: [Movie] {get set}
    
    func load(with page: Int)
    func filterMovies(_ filterText: String, _ completion: @escaping ([Movie]) -> Void)
}

enum MoviesOutputs: Equatable {
    case showLoading(Bool)
    case showMovies([Movie])
    case showError(String)
}

protocol MoviesViewModelDelegate: class {
    func handle(_ output: MoviesOutputs)
}

final class MoviesViewModel: MoviesViewModelProtocol {
    var delegate: MoviesViewModelDelegate!
    
    var movies: [Movie] = []
    
    private var tempMoviesForfilter: [Movie] = []
    private var service: APIProtocol!
    
    init(_ service: APIProtocol) {
        self.service = service
    }
    
    func load(with page: Int = 1) {
        delegate.handle(.showLoading(true))
        service.fetch(from: Router.getUrl(.movies(page)), .get, nil) {[weak self] (responseData) in
            guard let self = self else {return}
            self.delegate.handle(.showLoading(false))
            switch responseData {
            case .success(let data):
                let decoder = Decoders.plainDateDecoder
                do {
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    self.movies.append(contentsOf: movieResponse.results ?? [])
                    self.tempMoviesForfilter = self.movies
                    self.delegate.handle(.showMovies(self.movies))
                } catch {
                    self.delegate.handle(.showError("Decoding Err"))
                }
            case .fail(let err):
                self.delegate.handle(.showError(err.localizedDescription))
            }
        }
    }
    
    func filterMovies(_ filterText: String, _ completion: @escaping ([Movie]) -> Void) {
        let filteredMovies = tempMoviesForfilter.filter { (movie) -> Bool in
            guard let title = movie.originalTitle else {
                return false
            }
            
            return title.contains(filterText)
        }
        
        completion(filteredMovies)
    }
}
