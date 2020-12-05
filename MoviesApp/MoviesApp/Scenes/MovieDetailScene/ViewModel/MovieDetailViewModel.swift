//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import Foundation
import MoviesAPI

protocol MovieDetailViewModelProtocol: class {
    var delegate: MovieDetailViewModelDelegate! {get set}
    
    func load()
}

protocol MovieDetailViewModelDelegate: class {
    func handle(_ output: MovieDetailOutput)
}

enum MovieDetailOutput: Equatable {
    case setTitle(String)
    case showError(String)
    case showDetail(MovieDetail)
}


final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate!
    
    private var service: APIProtocol!
    private var movieId: Int
    
    init(_ service: APIProtocol, movieId: Int) {
        self.service = service
        self.movieId = movieId
    }
    
    func load() {
        service.fetch(from: Router.getUrl(.movieDetail(movieId)), .get, nil) {[weak self] (responseData) in
            guard let self = self else {return}
            switch responseData {
            case .success(let data):
                let decoder = Decoders.plainDateDecoder
                do {
                    let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                    self.delegate.handle(.setTitle(movieDetail.originalTitle ?? ""))
                    self.delegate.handle(.showDetail(movieDetail))
                } catch (let err) {
                    print(err)
                    self.delegate.handle(.showError("Decoding Err"))
                }
            case .fail(let err):
                self.delegate.handle(.showError(err.localizedDescription))
            }
        }
    }
    
    
}

