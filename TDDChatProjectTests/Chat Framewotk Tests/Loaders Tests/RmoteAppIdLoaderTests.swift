//
//  ChatHTTPLoaderTests.swift
//  ChatHTTPLoaderTests
//
//  Created by Mendy Edri on 30/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import lit_networking
@testable import TDDChatProject

class RmoteAppIdLoaderTests: XCTestCase {
    
    static let ValidAppId = "123-super-real-app-id"
    
    private let requestAttempts = ClientMediator.httpRetryAttempts
    
    func test_apiAppIdLoader_emptyURL() {
        let client = HTTPClientMock()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_apiAppIdLoader_successJson() {
        
        let item = makeItem(id: RmoteAppIdLoaderTests.ValidAppId)
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWith: .success(item.asObject), when: {
            client.complete(withSatus: 200, data: makeItemJSON(item: item.asJson), at: 0)
        })
    }
    
    func test_apiAppIdLoader_errorInvalidCode_Not200() {
        let (sut, client) = makeSUT()
        
        let badCodes = [199, 201, 300, 400, 500]
        
        badCodes.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: .failure(.invalidData), when: {
                
                let item = makeItem(id: RmoteAppIdLoaderTests.ValidAppId)
                let json = makeItemJSON(item: item.asJson)
                client.complete(withSatus: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withSatus: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = NSError(domain: "test", code: 200, userInfo: nil)

        expect(sut: sut, toCompleteWith: .failure(.connectivity), when: {
            requestAttempts.loop {
                client.complete(with: clientError as Error)
            }
        })
    }
    
    func test_loadDeliversSuccessAfterRetry() {
        let (sut, client) = makeSUT()
        let item = makeItem(id: RmoteAppIdLoaderTests.ValidAppId)
        
        let clientError = NSError(domain: "test", code: 200, userInfo: nil)
        
        expect(sut: sut, toCompleteWith: .success(item.asObject), when: {
            (requestAttempts - 1 as Int).loop {
                client.complete(with: clientError, at: 0)
            }
            client.complete(withSatus: 200, data: makeItemJSON(item: item.asJson), at: 1)
        })
    }
    
    func test_loadDeliversFailureAfterRetryMaxAttempts() {
        let (sut, client) = makeSUT()
        let clientError = NSError(domain: "test", code: 200, userInfo: nil)
        
        expect(sut: sut, toCompleteWith: .failure(.connectivity), when: {
            requestAttempts.loop {
                client.complete(with: clientError, at: 0)
            }
        })
    }
    
    // MARK: Helpers
    
    private func makeItem(id: String) -> (asObject: ChatVendorAppId, asJson: [String: Any]) {
        
        let item = ChatVendorAppId.createItem(with: RmoteAppIdLoaderTests.ValidAppId)
        let json = ChatVendorAppId.createJson(from: item)
        return (item, json)
    }
    
    private func makeItemJSON(item: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: item)
    }
    
    private func expect(sut: RemoteAppIdLoader, toCompleteWith result: RemoteAppIdLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResult = [RemoteAppIdLoader.Result]()
        
        sut.load {
            capturedResult.append($0)
        }
        
        action()
        
        XCTAssertEqual(capturedResult, [result], file: file, line: line)
    }
    
    private func makeSUT() -> (RemoteAppIdLoader, HTTPClientMock) {
        let client = HTTPClientMock()
        let url = URL(string: "https://a-url.com")!
        let sut = RemoteAppIdLoader(url: url, client: client)
        
        return (sut, client)
    }
}

private extension ChatVendorAppId {
    
    static func createItem(with appId: String) -> ChatVendorAppId {
        
        let header = ResponseHeader(statusMessage: "success")
        let meta = ResponseMetadata(trxId: "10939", reqId: "93838", status: "success")
        
        return ChatVendorAppId(responseHeader: header, meta: meta, appId: appId)
    }
    
    static func createJson(from item: ChatVendorAppId) -> [String: Any] {
        return ["responseHeader": [
                    "statusMessage": item.responseHeader.statusMessage
               ],
                "appId": item.appId,
                "responseMeta": [
                    "trxId": item.meta.trxId,
                    "reqId": item.meta.reqId,
                    "status": item.meta.status
            ]] as [String : Any]
    }
}

