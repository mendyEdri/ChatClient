//
//  XCTestCase+Helper.swift
//  Integration
//
//  Created by Mendy Edri on 06/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import XCTest
import lit_networking

extension XCTestCase {
    // MAKR: - Helpers methods to ease the complete HTTPClient requests
    func completeRemoteAppIdWithSuccess(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(withSatus: 200, data: JSONMockData.appIdRemoteApiData(), at: index)
    }
    
    func completeRemoteAppIdWithError(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(with: anyError, at: index)
    }
    
    func completeRemoteVendorTokenWithSuccess(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(withSatus: 200, data: JSONMockData.vendorTokenRemoteApiData(), at: index)
    }
    
    func completeRemoteVendorTokenWithError(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(with: anyError, at: index)
    }
    
    var anyError: Error {
        return NSError(domain: "cwt", code: 400, userInfo: nil)
    }
}

extension XCTestCase {
    // MAKR: - Helpers methods to ease the complete ChatClient methods
    func completeStartSDKWithSuccess(_ spy: ChatClientSpy) {
        spy.completeStartSDKSuccessfuly()
    }
    
    func completeStartSDKWithError(_ spy: ChatClientSpy) {
        spy.completeStartSDKWithError()
    }
    
    func completeLoginSDKWithSuccess(_ spy: ChatClientSpy) {
        spy.completeLoginSuccessfuly()
    }
    
    func completeLoginSDKWithError(_ spy: ChatClientSpy) {
        spy.completeLoginWithError()
    }
}
