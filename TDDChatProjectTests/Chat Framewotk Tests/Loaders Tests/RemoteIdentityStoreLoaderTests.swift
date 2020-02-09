//
//  RemoteIdentityStoreLoaderTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 18/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import TDDChatProject
import lit_networking

class RemoteIdentityStoreLoaderTests: XCTestCase {
    
    typealias Result = RemoteIdentityStoreLoader.Result
    private var testSpecificUserValue = "Dustin.1984"
    
    func test_load_returnsResultBeforeCompletion() {
        let (sut, _) = makeSUT()
        
        var capturedResult = [Result]()
        sut.load { result in
            capturedResult.append(result)
        }
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    func test_load_deliversErrorOnCompleteingError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            client.complete(with: anyNSError())
        })
    }
    
    func test_load_deliversErrorOnAuthFailedJSON() {
        let (sut, client) = makeSUT()
        let expectedJSON = IdentityStoreResponseHelper.makeAuthFailedJSON()
        
        expect(sut, toCompleteWith: .failure(.authFailed), when: {
            client.complete(withSatus: 401, data: expectedJSON.toData())
        })
    }
    
    func test_load_deliversAuthErrorOnAlreadyRegisterJSON() {
        let (sut, client) = makeSUT()
        
        let expectedJSON = IdentityStoreResponseHelper.makeJsonItem(testSpecificUserValue)
        let item = identityStore(from: expectedJSON)
        
        expect(sut, toCompleteWith: .success(item), when: {
            client.complete(withSatus: 200, data: expectedJSON)
        })
    }
    
    func test_load_deliversSucessOnSuccessJSONItem() {
        let (sut, client) = makeSUT()
        
        let data = IdentityStoreResponseHelper.makeJsonItem(testSpecificUserValue)
        let item = identityStore(from: data)
        
        expect(sut, toCompleteWith: .success(item), when: {
            client.complete(withSatus: 200, data: data)
        })
    }
    
    func test_load_deliversErrorOnInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            client.complete(withSatus: 200, data: Data("Invalid JSON".utf8))
        })
    }
    
    func test_load_deliversError200WithAuthFailedJSON() {
        let (sut, client) = makeSUT()
        
        let JSON = IdentityStoreResponseHelper.makeAuthFailedJSON()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            client.complete(withSatus: 200, data: JSON.toData())
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (RemoteIdentityStoreLoader, HTTPClientMock) {
        let client = HTTPClientMock()
        let sut = RemoteIdentityStoreLoader(url: anyURL(), client: client)
        
        return (sut, client)
    }
    
    
    private func expect(_ sut: RemoteIdentityStoreLoader, toCompleteWith: RemoteIdentityStoreLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load to complete")
        var capturedResult = [Result]()
        
        sut.load { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(capturedResult, [toCompleteWith], file: file, line: line)
    }
    
    private func identityStore(from data: Data) -> IdentityStoreModel {
        let model = try! JSONDecoder().decode(IdentityStoreModel.self, from: data)
        
        return model
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "domain.com", code: 401, userInfo: nil)
    }
}
