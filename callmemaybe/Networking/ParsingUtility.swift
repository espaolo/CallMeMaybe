//
//  ParsingUtility.swift
//  callmemaybe
//
//  Created by Paolo Esposito on 07/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import Foundation

func loadJsonData(file: String) -> Data? {
    
    if let jsonFilePath = Bundle.main.path(forResource: file, ofType: "json") {
        let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
        
        if let jsonData = try? Data(contentsOf: jsonFileURL) {
            return jsonData
        }
    }
    return nil
}

func createMockSession(fromJsonFile file: String,
                       andStatusCode code: Int,
                       andError error: Error?) -> MockURLSession? {
    
    let data = loadJsonData(file: file)
    let response = HTTPURLResponse(url: URL(string: "FakeUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)
    return MockURLSession(completionHandler: (data, response, error))
}
