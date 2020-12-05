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
    
    private func createMockView() -> MockMoviesListView {
        mockApi = MockMoviesAPI(ResourceLoader.getMovies())
        viewModel = MoviesViewModel(mockApi)
        mockView = MockMoviesListView(viewModel:viewModel)
        return mockView
    }
    
    func test_loadMovies_controlViewOutputs() {
        
        //Given
        let mockView = createMockView()
        
        //When
        mockView.load(1)
        
        //Then
        XCTAssertTrue(mockView.outputs.count == 3) //loadingtrue, showMovies, loadingfalse
    }
    
    func test_page1andPage2FetchMovies_movieCountMustBeChange() {
        //Given
        let mockView = createMockView()
        
        //GIVEN
        viewModel.load(with: 1)
        let page1count = mockView.movies.count
        
        viewModel.load(with: 2)
        let page2Count = mockView.movies.count
        
        //THEN
        XCTAssertFalse(page1count == page2Count)
    }
    
    func test_searchTest_filterMovies() {
        
        //Given
        let mockView = createMockView()
        
        //When
        mockView.load(1)
        mockView.load(2)
        mockView.outputs.removeAll()
        
        //Then
        viewModel.filterMovies("H") { (filteredMovies) in
            XCTAssertTrue(!filteredMovies.isEmpty)
        }
    }
    
}

private class MockMoviesListView: UIView, MoviesViewModelDelegate {
    private var viewModel: MoviesViewModelProtocol!

    var outputs: [MoviesOutputs] = []
    
    var movies: [Movie] = []
    
    var routedToDetail: Bool = false
    
    private var filteredMovies: [Movie] = []

    convenience init(viewModel: MoviesViewModelProtocol ) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    func load(_ pageIndex: Int) {
        viewModel.load(with: pageIndex)
    }
    
    func handle(_ output: MoviesOutputs) {
        outputs.append(output)
        switch output {
        case .showMovies(let mockMovies):
            self.movies.append(contentsOf: mockMovies)
        default:
            break
        }
    }
}
