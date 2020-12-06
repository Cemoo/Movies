//
//  FavouriteFlowTests.swift
//  MoviesAppTests
//
//  Created by Cemal BAYRI on 6.12.2020.
//

import XCTest
@testable import MoviesApp

class FavouriteFlowTests: XCTestCase {
    
    private func createMockFavFlow() -> MockFavouriteFlow {
        
        let flow = MockFavouriteFlow(MockSavingStrategy())
        app.favouriteFlow = flow
        return flow
    }
    
    func test_makeFavoruite_controlIsFavStatusOnPage() {
        
        //When
        let movieResponse = ResourceLoader.getMovies()
        let view = MockDetailView(MovieDetailViewModel(app.service, movie: movieResponse.results![0]))
        
        //given
        view.add()
        
        //Then
        XCTAssertTrue(view.isFav)
    }
    
}

private class MockDetailView: UIView, MovieDetailViewModelDelegate {
    
    var viewModel: MovieDetailViewModelProtocol!
    
    var outputs: [MovieDetailOutput] = []
    
    var isFav: Bool = false
    
    convenience init(_ viewModel: MovieDetailViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    func add() {
        viewModel.addOrRemoveFavourite()
    }
    
    
    func handle(_ output: MovieDetailOutput) {
        outputs.append(output)
        switch output {
        case .changeFavouriteStatus(let status):
            isFav = status
        default:
            break
        }
    }
}

private class MockFavouriteFlow: FavouriteProtocol {
    
    typealias Item = Movie
    
    var favouriteMovies: [Item] = []
    
    private var savingStrategy: LocalStorageStrategy!
    
    init(_ savingStrategy: LocalStorageStrategy) {
        self.savingStrategy = savingStrategy
    }
    
    func add(_ item: Movie) {
        favouriteMovies.append(item)
    }
    
    func delete(_ item: Movie) {
        favouriteMovies = favouriteMovies.filter({$0.id != item.id ?? 0})
    }
    
    func get() -> [Movie] {
        return []
    }
}

private class MockSavingStrategy: LocalStorageStrategy {
    func saveObject<T>(_ key: String, _ object: T) where T : Encodable {}
    
    func getObject<T>(_ key: String, _ object: T.Type) -> T? where T : Decodable {
        return nil
    }
    
    func removeObject(_ key: String) {}
}

