//
//  MovieDetailTests.swift
//  MoviesAppTests
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import XCTest
import MoviesAPI
@testable import MoviesApp

class MovieDetailTests: XCTestCase {
    
    private var mockApi: APIProtocol!
    private var viewModel: MovieDetailViewModelProtocol!
    private var mockMovieDetail: MovieDetail!
    private var mockView: MockDetailView!
    
    private func createMockView() -> MockDetailView {
        mockMovieDetail = ResourceLoader.getMovieDetail()
        mockApi = MockMovieDetailAPI(mockMovieDetail)
        viewModel = MovieDetailViewModel(mockApi, movieId: 123)
        mockView = MockDetailView(viewModel)
        return mockView
    }
    
    func test_loadMovieDetail_setPageTitle() {
        
        //When
        let mockView = createMockView()
        
        //Given
        viewModel.load()
        
        //Then
        XCTAssertTrue(mockView.outputs.contains(.setTitle("Shazam!")))
    }
    
    func test_loadMovieDetail_controlMovieDetailOutput() {
        
        //When
        let mockView = createMockView()
        
        //Given
        viewModel.load()
        
        //Then
        XCTAssertTrue(mockView.outputs.contains(.showDetail(mockMovieDetail)))
    }
}

private class MockDetailView: UIView, MovieDetailViewModelDelegate {
    
    var viewModel: MovieDetailViewModelProtocol!
    
    var outputs: [MovieDetailOutput] = []
    
    convenience init(_ viewModel: MovieDetailViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    
    func handle(_ output: MovieDetailOutput) {
        outputs.append(output)
    }
}
