//
//  MoviesAPIEngine.swift
//  MoviesAPI
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation

public enum APIResult<Value> {
    case success(Value)
    case fail(Error)
}

public protocol APIEngine: class {
    func fetch(from url: URL, _ method: APIMethod, _ requestData: Data?, _ completionHandler: @escaping (APIResult<Data>) -> Void)
}

public enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

