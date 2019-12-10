//
//  ChatClientManagerTests.swift
//  CWTTests
//
//  Created by Mendy Edri on 07/11/2019.
//

import XCTest
@testable import TDDChatProject

// MARK: - Client Prepare SDK Tests

class ChatClientManagerTests: XCTestCase {
    
    private typealias Error = ClientManager.Error
    private typealias Result = ClientManager.Result
    
    private var ValidAppId: String {
        return "FU#KPLASTIC2020"
    }
    
    private var anyUserID: String {
        return "anyUser19203"
    }
    
    private var anyToken: String {
        return "OSISA.1222.3SIDOA"
    }
    
    private var appIdKey = "ChatClientManagerTests.appIdKey"
    private var userTokenKey = "ChatClientManagerTests.userTokenKey"
    
    private lazy var anyAppId = "10203"
    
    private static var anySettings: ChatSettings {
        return ChatSettings(appId: "10103", token: "OSISA.1xxx.3SIDOA", userId: "anyUser1203")
    }
    /*
    func test_prepareSDK_deliversAppIdWhenPrepareCompleted() {
        let (sut, client, _) = makeSUT()
        
        var capturedResult = [String]()
        let exp = expectation(description: "Wait for prepare to callback")
        
        sut.prepare(with: client.settings) { result in
            if case let .success(appId) = result {
                capturedResult.append(appId)
            }
            exp.fulfill()
        }
        
        client.completeStartSDKSuccessfuly()
        client.completeLoginWithSuccess()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(capturedResult, [client.settings.userId])
    }
    
    func test_prepareSDK_deliverNoResultWhenInstanceHasBeenDeallocated() {
        var (sut, client, _) = makeOptionalSUT()
        
        var capturedResult = [Result]()
        sut?.prepare(with: client.settings) { capturedResult.append($0) }
        
        sut = nil
        client.completeStartSDKSuccessfuly()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    func test_prepareSDK_deliversNoResultOnInitSuccessAndLoginFails() {
        var (sut, client, _) = makeOptionalSUT()
        
        var capturedResult = [Result]()
        sut?.prepare(with: client.settings, { capturedResult.append($0) })
        
        client.completeStartSDKSuccessfuly()
        sut = nil
        client.completeLoginWithErrorInvalidUserID()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    func test_prepareSDK_deliversErrorOnInitSuccessAndLoginError() {
        let (sut, client, _) = makeSUT()
        
        var capturedResult = [Result]()
        sut.prepare(with: client.settings, { capturedResult.append($0) })
        
        client.completeStartSDKSuccessfuly()
        client.completeLoginWithErrorInvalidUserID()
        
        XCTAssertEqual(capturedResult, [.failure(.invalidUserID)])
    }
 */
}

// MARK: - Client StartSDK Tests

extension ChatClientManagerTests {
    
    func test_startSDK_returnsAppId() {
        let sett = ChatSettings(appId: "NOONEWILLSTOPYOU2020", token: "11111", userId: "2222")
        
        let (sut, client, _) = makeSUT(sett)
        expectStart(appId: sett.appId, sut, toCompleteWith: .success(sett.appId), when: {
            client.completeStartSDKSuccessfuly()
        })
    }
    
    func test_stardSDK_failsOnWrongId() {
        let (sut, client, _) = makeSUT()
        
        expectStart(sut, toCompleteWith: .failure(.initFailed), when: {
            client.completeStartSDKWithError()
        })
    }
    
    func test_startSDK_notReturnsWhenInstanceIsDeallocated() {
        var (sut, client, _) = makeOptionalSUT()
        
        var capturedResult = [Result]()
        sut?.start(anyAppId) { capturedResult.append($0) }
        
        sut = nil
        client.completeStartSDKSuccessfuly()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ settings: ChatSettings = ChatClientManagerTests.anySettings, storage: UserDefaultStorageMock = UserDefaultStorageMock()) -> (sut: ClientManager, client: ChatClientSpy, httpClient: ChatHTTPClientMock) {
        
        let (sut, client, httpClient) = makeOptionalSUT(settings, storage: storage)
        
        trackMemoryLeaks(client)
        trackMemoryLeaks(sut!)
        
        return (sut!, client, httpClient)
    }
    
    private func makeOptionalSUT(_ settings: ChatSettings = ChatClientManagerTests.anySettings, storage: UserDefaultStorageMock = UserDefaultStorageMock()) -> (sut: ClientManager?, client: ChatClientSpy, httpClient: ChatHTTPClientMock) {
        
        let client = ChatClientSpy(settings: settings)
        let httpClient = ChatHTTPClientMock()
        
        let clients = ClientManagerClients(chatClient: client, httpClient: httpClient, jwtClient: Jwt(), storage: storage)
        
        let sut: ClientManager? = ClientManager(clients: clients)
        
        trackMemoryLeaks(client)
        trackMemoryLeaks(sut!)
        
        return (sut, client, httpClient)
    }
    
    private func expectStart(appId: String = "10233", _ sut: ClientManager, toCompleteWith expectedResult: Result, when action: @escaping () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for start sdk completion")
        var capturedResult = [Result]()
        
        sut.start(appId) { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(capturedResult, [expectedResult], file: file, line: line)
    }
    
    private func expectLogin(_ sut: ClientManager, toCompleteWith expectedResult: Result, when action: @escaping () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for login sdk to complete")
        var capturedResult = [Result]()
        sut.login(userId: anyUserID, token: anyToken) { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(capturedResult, [expectedResult], file: file, line: line)
    }
}

// MARK: - Client Login Tests
extension ChatClientManagerTests {
    
    func test_loginSDK_deliversSuccessWithValidUserID() {
        let sett = ChatSettings(appId: "appId-10101", token: "11111", userId: "userId-2222")
        
        let (sut, client, _) = makeSUT(sett)
        client.isInitialize = true
        
        expectLogin(sut, toCompleteWith: .success(sett.userId!), when: {
            client.completeLoginWithSuccess()
        })
    }
    
    func test_loginSDK_deliversErrorOnInvalidUserId() {
        let (sut, client, _) = makeSUT()
        
        client.isInitialize = true
        expectLogin(sut, toCompleteWith: .failure(.invalidUserID), when: {
            client.completeLoginWithErrorInvalidUserID()
        })
    }
    
    func test_loginSDK_deliversErrorOnInvalidToken() {
        let (sut, client, _) = makeSUT()
        
        client.isInitialize = true
        expectLogin(sut, toCompleteWith: .failure(.invalidToken), when: {
            client.completeLoginWithErrorInvalidToken()
        })
    }
    
    func test_loginWontCallBeforeInitilized() {
        let (sut, _, _) = makeSUT()
        
        var capturedResult = [Result]()
        let exp = expectation(description: "Waits for prepare to complete")
        
        sut.login(userId: anyUserID, token: anyToken) { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(capturedResult, [.failure(.sdkNotInitialized)])
    }
}

private extension UserDefaultStorageMock {
    private var unmeaningfulAppId: String {
        return "109.++33.dd"
    }
    
    private var unmeaningfulToken: String {
        return "U.99.aP-8"
    }
    
    func setAppIdAsSaved(for key: String) {
        save(value: unmeaningfulAppId, for: key)
    }
    
    func setUserTokenAsSaved(for key: String) {
        save(value: unmeaningfulToken, for: key)
    }
}
