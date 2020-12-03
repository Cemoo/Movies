//
//  MoviesAPI.swift
//  MoviesAPI
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import Foundation

public class API: APIEngine {
    
    private var session: URLSession!
    
    public required init(_ session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct NilValueError: Error {
        let description: String?
    }
    
    public func fetch(from url: URL, _ method: APIMethod, _ requestData: Data?, _ completionHandler: @escaping (APIResult<Data>) -> Void) {
        let task = session.dataTask(with: makeRequest(url, method.rawValue, requestData)) { (dataResponse, urlResponse, error) in
            if let error = error {
                completionHandler(APIResult.fail(error))
            } else {
                
                if let data = dataResponse, let response = urlResponse as? HTTPURLResponse {
                    if response.statusCode >= 200 && response.statusCode < 400 {
                        completionHandler(APIResult.success(data))
                    } else {
                        if let error = error {
                            completionHandler(APIResult.fail(error))
                        } else {
                            completionHandler(APIResult.fail(NilValueError(description: "Error exists but it is nil.")))
                        }
                    }
                } else {
                    completionHandler(APIResult.fail(NilValueError(description: "Response is nil")))
                }
            }
        }
        task.resume()
    }
    
    private func makeRequest(_ url: URL, _ method: String, _ data: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpBody = data
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
