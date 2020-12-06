//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation
import MoviesAPI


//MARK: - Movie View Model Protocol
protocol MoviesViewModelProtocol: class {
    var delegate: MoviesViewModelDelegate! {get set}
    var movies: [Movie] {get set}
    
    func load(with page: Int)
    func filterMovies(_ filterText: String, _ completion: @escaping ([Movie]) -> Void)
    func addRemoveFavourite(_ movie: Movie, _ status: Bool)
}

enum MoviesOutputs: Equatable {
    case showLoading(Bool)
    case showMovies([Movie])
    case showError(String)
    case reloadMovie(Movie)
}

protocol MoviesViewModelDelegate: class {
    func handle(_ output: MoviesOutputs)
}


//MARK: - Movie View Model
final class MoviesViewModel: MoviesViewModelProtocol {
    weak var delegate: MoviesViewModelDelegate!
    
    var movies: [Movie] = []
    
    private var tempMoviesForfilter: [Movie] = []
    private var service: APIProtocol!
    
    init(_ service: APIProtocol) {
        self.service = service
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavFromMovieDetail), name: NSNotification.Name("updatemoviefav"), object: nil)
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
                    self.updateAllMoviesFavouriteStatusOnStart()
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
    
    func addRemoveFavourite(_ movie: Movie, _ status: Bool) {
        status ? app.favouriteFlow.add(movie) : app.favouriteFlow.delete(movie)
        updateFavouriteStatus(for: movie)
        delegate.handle(.reloadMovie(movie))
    }
    
    //MARK: - Updates favourite status from movie detail page.
    @objc func updateFavFromMovieDetail(_ notification: Notification) {
        if let info = notification.userInfo, let movie = info["movie"] as? Movie {
            self.updateFavouriteStatus(for: movie)
            delegate.handle(.reloadMovie(movie))
        }
    }
    
    //MARK: - Updates favourite status related row.
    private func updateFavouriteStatus(for movie: Movie) {
        if let index = self.movies.firstIndex(where: {$0.id == movie.id}) {
            self.movies[index].isFavorite = movie.isFavorite
        }
        
        self.tempMoviesForfilter = self.movies
    }
    
    //MARK: - This function calls first opened of app.
    private func updateAllMoviesFavouriteStatusOnStart() {
        let favMovies = app.favouriteFlow.get()
        
        if !favMovies.isEmpty {
            favMovies.forEach { (favMovie) in
                if let index = self.movies.firstIndex(where: {$0.id == favMovie.id}) {
                    self.movies[index].isFavorite = favMovie.isFavorite
                }
            }
        } else {
            var tempArray: [Movie] = []
            for i in 0..<self.movies.count {
                var tempMovie = movies[i]
                tempMovie.isFavorite = false
                tempArray.append(tempMovie)
            }
            
            self.movies = tempArray
        }
    }
}
