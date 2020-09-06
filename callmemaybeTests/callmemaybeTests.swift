//
//  callmemaybeTests.swift
//  callmemaybeTests
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import XCTest
@testable import callmemaybe

class callmemaybeTests: XCTestCase {
    
    var clientToTest: Client!
    var mockSession: MockURLSession!
    
    override func tearDown() {
        clientToTest = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testNetworkClient_loginSuccessResult() {
        
        mockSession = createMockSession(fromJsonFile: "Login", andStatusCode: 200, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "FakeUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(LoginData)
            XCTAssertNil(errorMessage)
            
            XCTAssertTrue(LoginData!.results.count == 1)
            
            let user = LoginData!.results.first!
            XCTAssertTrue(user.userName == "Paolo Esposito")
        }
    }
    
    func testNetworkClient_login404Result() {
        
        mockSession = createMockSession(fromJsonFile: "Login", andStatusCode: 404, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "FakeUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(LoginData)
            XCTAssertTrue(errorMessage == "Url Not Found")
        }
    }
    
    func testNetworkClient_loginNoData() {
        
        mockSession = createMockSession(fromJsonFile: "Puppa", andStatusCode: 500, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "FakeUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(LoginData)
            XCTAssertTrue(errorMessage == "No Data Avaiable")
        }
    }
    
    func testNetworkClient_loginStatusCode() {
        
        mockSession = createMockSession(fromJsonFile: "Login", andStatusCode: 401, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "TestUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(LoginData)
            XCTAssertTrue(errorMessage == "Status Code: 401")
        }
    }
    
    private func loadJsonData(file: String) -> Data? {
        
        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
    
    private func createMockSession(fromJsonFile file: String,
                                   andStatusCode code: Int,
                                   andError error: Error?) -> MockURLSession? {
        
        let data = loadJsonData(file: file)
        let response = HTTPURLResponse(url: URL(string: "FakeUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)
        return MockURLSession(completionHandler: (data, response, error))
    }
}
