//
//  Client+Stub.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 06/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import Foundation

// MARK: - DataTask

protocol SessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: SessionDataTaskProtocol {}

class MockURLSessionDataTask: SessionDataTaskProtocol {
    func resume() {}
}

// MARK: - URLSession

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTaskProtocol
}

extension URLSession: SessionProtocol {

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as SessionDataTaskProtocol
    }
}

class MockURLSession: SessionProtocol {

    var dataTask = MockURLSessionDataTask()
    var completionHandler: (Data?, URLResponse?, Error?)

    init(completionHandler: (Data?, URLResponse?, Error?)) {
        self.completionHandler = completionHandler
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTaskProtocol {
        completionHandler(self.completionHandler.0, self.completionHandler.1, self.completionHandler.2)
        return dataTask
    }
}

