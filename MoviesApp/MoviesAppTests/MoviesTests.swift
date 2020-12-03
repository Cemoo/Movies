//
//  MoviesTests.swift
//  MoviesAppTests
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import XCTest
import MoviesAPI
@testable import MoviesApp

private class MoviesTests: XCTestCase {
    
    private var mockApi: APIProtocol!
    private var viewModel: MoviesViewModelProtocol!
    private var mockView: MockMoviesListView!
    
    private var mockMovies: MovieResponse!
    
    private func start(_ movieResponse: MovieResponse) {
        mockApi = MockMoviesAPI(movieResponse)
    }
    
    func test_loadMovies_controlViewOutputs() {
        
        //Given
        mockMovies = ResourceLoader.getMovies()
        start(mockMovies)
        mockView = MockMoviesListView(viewModel: MoviesViewModel(mockApi))
        
        //When
        mockView.load()
        
        //Then
        XCTAssertTrue(mockView.outputs.count == 3) //loadingtrue, showMovies, loadingfalse
        XCTAssert(mockView.outputs.contains(.showMovies(self.mockMovies.result ?? [])))
    }
}

private class MockMoviesListView: UIView, MoviesViewModelDelegate {
    private var viewModel: MoviesViewModelProtocol!
    var outputs: [MoviesOutputs] = []

    convenience init(viewModel: MoviesViewModelProtocol ) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    func load() {
        viewModel.load(with: 1)
    }
    
    func handle(_ output: MoviesOutputs) {
        outputs.append(output)
    }
}

