//
//  callmemaybeTests.swift
//  callmemaybeTests
//
//  Created by Paolo Esposito on 05/09/2020.
//  Copyright © 2020 Paolo Esposito. All rights reserved.
//

import XCTest
import CallMeKit
@testable import CallmeMaybe

class callmemaybeTests: XCTestCase {
    
    var clientToTest: Client!
    var mockSession: MockURLSession!
    
    override func tearDown() {
        clientToTest = nil
        mockSession = nil
        super.tearDown()
    }
    // MARK: - Login Call Test
    
    func testNetworkClient_loginSuccessResult() {
        //We test Login OK
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
        //We test Login 404
        mockSession = createMockSession(fromJsonFile: "Login", andStatusCode: 404, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "FakeUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(LoginData)
            XCTAssertTrue(errorMessage == "Url Not Found")
        }
    }
    
    func testNetworkClient_loginNoData() {
        //We test Login with not present Data
        mockSession = createMockSession(fromJsonFile: "Puppa", andStatusCode: 500, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "FakeUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(LoginData)
            XCTAssertTrue(errorMessage == "No Data Avaiable")
        }
    }
    
    func testNetworkClient_loginStatusCode() {
        //We test Login with a 401 status code
        mockSession = createMockSession(fromJsonFile: "Login", andStatusCode: 401, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.loginCall(url: URL(string: "TestUrl")!) { (LoginData, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(LoginData)
            XCTAssertTrue(errorMessage == "Status Code: 401")
        }
    }
    
    // MARK: - Keychain Test
    
    func testKeychain() {
        // We test insert and remove for fake data in KeyChain
        KeychainWrapper.standard.set("FakeData", forKey: "KeychainTest")
        let savedValue = KeychainWrapper.standard.string(forKey: "KeychainTest")
        XCTAssertTrue(savedValue == "FakeData")
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "KeychainTest")
        XCTAssertTrue(removeSuccessful == true)
    }
    
    // MARK: - User Retrieval Test
    
    func testNetworkClient_usersRetrieveSuccessResult() {
        //We test Users Retrieval OK
        mockSession = createMockSession(fromJsonFile: "Users", andStatusCode: 200, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.userRetrieveCall(url: URL(string: "FakeUrl")!) { (UserRet, errorMessage) in
            
            XCTAssertNotNil(UserRet)
            XCTAssertNil(errorMessage)
            
            XCTAssertTrue(UserRet!.results.count == 7)
            
            let user = UserRet!.results.first!
            XCTAssertTrue(user.userName == "Guglielmo Cancelli")
        }
    }
    
    func testNetworkClient_users404Result() {
        //We test Users Retrieval 404
        mockSession = createMockSession(fromJsonFile: "Users", andStatusCode: 404, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.userRetrieveCall(url: URL(string: "FakeUrl")!) { (UserRet, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(UserRet)
            XCTAssertTrue(errorMessage == "Url Not Found")
        }
    }
    
    func testNetworkClient_usersNoData() {
        //We test Users Retrieval with not present Data
        mockSession = createMockSession(fromJsonFile: "Puppa", andStatusCode: 500, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.userRetrieveCall(url: URL(string: "FakeUrl")!) { (UserRet, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(UserRet)
            XCTAssertTrue(errorMessage == "No Data Avaiable")
        }
    }
    
    func testNetworkClient_usersStatusCode() {
        //We test Users Retrieval with a 401 status code
        mockSession = createMockSession(fromJsonFile: "Users", andStatusCode: 401, andError: nil)
        clientToTest = Client(withSession: mockSession)
        
        clientToTest.userRetrieveCall(url: URL(string: "TestUrl")!) { (UserRet, errorMessage) in
            
            XCTAssertNotNil(errorMessage)
            XCTAssertNil(UserRet)
            XCTAssertTrue(errorMessage == "Status Code: 401")
        }
    }
    
    // MARK: - Room Delegates Test

    
    class MockRoomDelegates: RoomDelegate {
        
        var isUserConnected = false
        var isUserDisconnected = false
        var isStreamAdded = false
        var isStreamRemoved = false
        
        var stream = CallStream()
        func didConnect(username: String) {
            isUserConnected = true
        }
        
        func didDisconnect(username: String) {
            isUserDisconnected = true
        }
        
        func addStream(_ : CallStream) {
            isStreamAdded = true
        }
        func removeStream(_ : CallStream) {
            isStreamRemoved = true
        }

    }
    
    func testRoomDelegateConnection() {
        let mockDelegate = MockRoomDelegates()
        
        //did Connect Test
        XCTAssertTrue(mockDelegate.isUserConnected == false)
        mockDelegate.didConnect(username: "FakeUser")
        XCTAssertTrue(mockDelegate.isUserConnected == true)
        
        // did Disconnect Test
        XCTAssertTrue(mockDelegate.isUserDisconnected == false)
        mockDelegate.didDisconnect(username: "FakeUser")
        XCTAssertTrue(mockDelegate.isUserDisconnected == true)
    }
    
    func testRoomDelegateStreams() {
        let mockDelegate = MockRoomDelegates()
        
        //did Connect Test
        XCTAssertTrue(mockDelegate.isUserConnected == false)
        mockDelegate.didConnect(username: "FakeUser")
        XCTAssertTrue(mockDelegate.isUserConnected == true)
        
        // did Disconnect Test
        XCTAssertTrue(mockDelegate.isUserDisconnected == false)
        mockDelegate.didDisconnect(username: "FakeUser")
        XCTAssertTrue(mockDelegate.isUserDisconnected == true)
        
        
        let streamToTest = mockDelegate.stream
        
        // add Stream Test
        XCTAssertTrue(mockDelegate.isStreamAdded == false)
        mockDelegate.addStream(streamToTest)
        XCTAssertTrue(mockDelegate.isStreamAdded == true)
        
        // remove Stream Test
        XCTAssertTrue(mockDelegate.isStreamRemoved == false)
        mockDelegate.removeStream(streamToTest)
        XCTAssertTrue(mockDelegate.isStreamRemoved == true)

        // retrieve random generated stored Stream values
        let storedAudioValue = streamToTest.hasAudio
        let storedVideoValue = streamToTest.hasVideo
        
        // Test Audio Stream
        streamToTest.toggleAudio()
        XCTAssertTrue(storedAudioValue != streamToTest.hasAudio)
        
        // Test Video Stream
        streamToTest.toggleVideo()
        XCTAssertTrue(storedVideoValue != streamToTest.hasVideo)
        
    }





}
