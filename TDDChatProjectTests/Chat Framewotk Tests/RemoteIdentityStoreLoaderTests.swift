//
//  RemoteIdentityStoreLoaderTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 18/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import TDDChatProject

class RemoteIdentityStoreLoaderTests: XCTestCase {
    
    typealias Result = RemoteIdentityStoreLoader.Result
    
    func test_load_returnsResultBeforeCompletion() {
        let (sut, _) = makeSUT()
        let url = URL(string: "https://a-url.com")!
        
        var capturedResult = [Result]()
        sut.load(from: url) { result in
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
        
        expect(sut, toCompleteWith: .failure(.authFailed), when: {
            client.complete(withSatus: 401, data: makeAuthFailedJSON().toData())
        })
    }
    
    func test_load_deliversAuthErrorOnAlreadyRegisterJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.alreadyRegistered), when: {
            client.complete(withSatus: 200, data: makeAlreadyRegisterJSON().toData())
        })
    }
    
    func test_load_deliversSucessOnSuccessJSONItem() {
        let client = ChatHTTPClientMock()
        let sut = RemoteIdentityStoreLoader(client: client)
        
        let JSON = makeJsonItem()
        let data = JSON.toData()
        let item = identityStore(from: data)
        
        expect(sut, toCompleteWith: .success(item), when: {
            client.complete(withSatus: 200, data: data)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (RemoteIdentityStoreLoader, ChatHTTPClientMock) {
        let client = ChatHTTPClientMock()
        let sut = RemoteIdentityStoreLoader(client: client)
        
        return (sut, client)
    }
    
    
    private func expect(_ sut: RemoteIdentityStoreLoader, toCompleteWith: RemoteIdentityStoreLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load to complete")
        var capturedResult = [Result]()
        
        sut.load(from: anyURL()) { result in
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

private extension Dictionary where Key == String {
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}

extension RemoteIdentityStoreLoaderTests {
    
    private func makeJsonItem() -> [String: Any] {
        return [
            "responseHeader" : [
                "statusMessage": "Identity created successfully",
                "res": [
                    "result": [
                        "ok": 1,
                        "n": 1,
                        "opTime": "6761667679536283849"
                    ],
                    "ops": [[
                        "type": "SMOOCH",
                        "travelerGUID": "A:40775EE7xx",
                        "externalID": "SMOOCH138x",
                        "_id": "5dd644ee76a2e50c285c7540"
                        ]],
                    "insertedCount": 1,
                    "insertedIds": [
                        "0": "5dd644ee76a2e50c285c7540"
                    ]
                ]
            ],
            "responseMeta": [
                "trxId": "27bd641b-fd7f-4c79-a4f1-c90ddac77b7d",
                "reqId": "27bd641b-fd7f-4c79-a4f1-c90ddac77b7d",
                "status": "success"
            ]
        ]
    }
    
    private func makeAuthFailedJSON() -> [String: Any] {
        return [
            "responseMeta": [
                "trxId" : "c04a7821-4afd-4230-a4b0-792ed53463d7",
                "reqId": "c04a7821-4afd-4230-a4b0-792ed53463d7",
                "message": "Authentication failed"
            ]
        ]
    }
    
    private func makeAlreadyRegisterJSON() -> [String: Any] {
        return [
            "responseHeader": [
                "isRegister": true,
                "statusMessage": "Identity already exists",
                "record": [
                    "_id": "5dd644ee76a2e50c285c7540",
                    "type": "SMOOCH",
                    "travelerGUID": "A:40775EE7xx",
                    "externalID": "SMOOCH138x"
                ]
            ],
           "responseMeta": [
                "trxId": "27bd641b-fd7f-4c79-a4f1-c90ddac77b7d",
                "reqId": "27bd641b-fd7f-4c79-a4f1-c90ddac77b7d",
                "status": "success"
            ]
        ]
    }
}
