//
//  MoviesAPITests.swift
//  MoviesAPITests
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import XCTest
@testable import MoviesAPI

class MoviesAPITests: XCTestCase {
    
    private func makeAPIInstance() -> API {
        return API(URLSession(configuration: .default))
    }
    
    func test_withRandomURL_isItWorks() {
        let url: URL = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=fd2b04342048fa2d5f728561866ad52a&page=1")!
        
        let expectation = XCTestExpectation(description: "testapiworks")
        
        //WHEN
        //MARK: aut = "api under test"
        let aut = makeAPIInstance()
        aut.fetch(from: url, .get, nil) { (resultData) in
            switch resultData {
            case .success(let data):
                XCTAssertNotNil(data)
            case .fail(let err):
                XCTFail(err.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
