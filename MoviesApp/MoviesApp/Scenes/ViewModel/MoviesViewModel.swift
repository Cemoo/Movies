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
    func load(with page: Int)
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
    
    private var service: APIProtocol!
    
    init(_ service: APIProtocol) {
        self.service = service
    }
    
    func load(with page: Int = 1) {
        delegate.handle(.showLoading(true))
        service.fetch(from: Router.getUrl(.movies(page)), .get, nil) { (responseData) in
            self.delegate.handle(.showLoading(false))
            switch responseData {
            case .success(let data):
                let decoder = Decoders.plainDateDecoder
                do {
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    self.delegate.handle(.showMovies(movieResponse.result ?? []))
                } catch {
                    self.delegate.handle(.showError("Decoding Err"))
                }
            case .fail(let err):
                self.delegate.handle(.showError(err.localizedDescription))
            }
        }
    }
}
