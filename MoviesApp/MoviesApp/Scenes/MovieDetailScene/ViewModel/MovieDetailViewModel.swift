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
    func addOrRemoveFavourite()
}

protocol MovieDetailViewModelDelegate: class {
    func handle(_ output: MovieDetailOutput)
}

enum MovieDetailOutput: Equatable {
    case setTitle(String)
    case showMessage(String)
    case showDetail(MovieDetail)
    case setIsFavourite(Bool)
    case changeFavouriteStatus(Bool)
}


final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate!
    
    private var service: APIProtocol!
    
    private var movie: Movie
    
    private var isFavourited: Bool = false {
        didSet {
            self.delegate.handle(.setIsFavourite(isFavourited))
        }
    }
    
    init(_ service: APIProtocol, movie: Movie) {
        self.service = service
        self.movie = movie
    }
    
    func load() {
        service.fetch(from: Router.getUrl(.movieDetail(movie.id ?? 0)), .get, nil) {[weak self] (responseData) in
            guard let self = self else {return}
            switch responseData {
            case .success(let data):
                let decoder = Decoders.plainDateDecoder
                do {
                    let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                    self.delegate.handle(.setTitle(movieDetail.originalTitle ?? ""))
                    self.setFavouriteStatus()
                    self.delegate.handle(.showDetail(movieDetail))
                } catch (let err) {
                    self.delegate.handle(.showMessage("Decoding Err"))
                }
            case .fail(let err):
                self.delegate.handle(.showMessage(err.localizedDescription))
            }
        }
    }
    
    func addOrRemoveFavourite() {
        isFavourited ? app.favouriteFlow.delete(movie): app.favouriteFlow.add(movie)
        isFavourited.toggle()
        delegate.handle(.changeFavouriteStatus(isFavourited))
    }
    
    private func setFavouriteStatus() {
        let favouriteMovies = app.favouriteFlow.get()
        isFavourited = favouriteMovies.contains(movie)
    }
    
}

