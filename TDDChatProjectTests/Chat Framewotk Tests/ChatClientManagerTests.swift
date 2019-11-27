//
//  ChatClientManagerTests.swift
//  CWTTests
//
//  Created by Mendy Edri on 07/11/2019.
//

import XCTest
@testable import TDDChatProject

private class ChatClientSpy: ChatClient {
    
    typealias Error = ClientManager.Error
    typealias Result = ClientManager.Result
    
    var settings: ChatSettings
    
    var startCompletions = [(StartResult) -> Void]()
    var loginCompletions = [(LoginResult) -> Void]()
    var logoutCompletions = [(LoginResult) -> Void]()
    fileprivate var isInitialize = false
    
    internal init(settings: ChatSettings) {
        self.settings = settings
    }
    
    func startSDK(_ appId: String, completion: @escaping (StartResult) -> Void) {
        startCompletions.append(completion)
    }
    
    func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void) {
        loginCompletions.append(completion)
    }
    
    func logout(completion: @escaping (LoginResult) -> Void) {
        logoutCompletions.append(completion)
    }
    
    func canLogin() -> Bool {
        return isInitialize
    }
    
    // MARK: - Mock Executions, Don't get exited
    
    fileprivate func completeStartSDKSuccessfuly(_ index: Int = 0) {
        isInitialize = true
        startCompletions[index](.success(settings.appId))
    }
    
    fileprivate func completeStartSDKWithError(_ index: Int = 0) {
        startCompletions[index](.failure(Error.initFailed))
    }
    
    fileprivate func completeLoginWithSuccess(_ index: Int = 0) {
        loginCompletions[index](.success(settings.userId))
    }
    
    fileprivate func completeLoginWithErrorInvalidUserID(_ index: Int = 0) {
        loginCompletions[index](.failure(Error.invalidUserID))
    }
    
    fileprivate func completeLoginWithErrorInvalidToken(_ index: Int = 0) {
        loginCompletions[index](.failure(Error.invalidToken))
    }
    
    fileprivate func completeLoginWithErrorSDKNotInitialized(_ index: Int = 0) {
        loginCompletions[index](.failure(Error.sdkNotInitialized))
    }
}

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
    
    private lazy var anyAppId = "10203"
    
    private static var anySettings: ChatSettings {
        return ChatSettings(appId: "10103", userId: "anyUser1203", token: "OSISA.1xxx.3SIDOA")
    }
    
    func test_prepareSDK_deliversAppIdWhenPrepareCompleted() {
        let (sut, client) = makeSUT()
        
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
        var (sut, client) = makeOptionalSUT()
        
        var capturedResult = [Result]()
        sut?.prepare(with: client.settings) { capturedResult.append($0) }
        
        sut = nil
        client.completeStartSDKSuccessfuly()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    func test_prepareSDK_deliversNoResultOnInitSuccessAndLoginFails() {
        var (sut, client) = makeOptionalSUT()
        
        var capturedResult = [Result]()
        sut?.prepare(with: client.settings, { capturedResult.append($0) })
        
        client.completeStartSDKSuccessfuly()
        sut = nil
        client.completeLoginWithErrorInvalidUserID()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    func test_prepareSDK_deliversErrorOnInitSuccessAndLoginError() {
        let (sut, client) = makeSUT()
        
        var capturedResult = [Result]()
        sut.prepare(with: client.settings, { capturedResult.append($0) })
        
        client.completeStartSDKSuccessfuly()
        client.completeLoginWithErrorInvalidUserID()
        
        XCTAssertEqual(capturedResult, [.failure(.invalidUserID)])
    }
}

// MARK: - Client StartSDK Tests

extension ChatClientManagerTests {
    
    func test_startSDK_returnsAppId() {
        let sett = ChatSettings(appId: "NOONEWILLSTOPYOU2020", userId: "2222", token: "11111")
        
        let (sut, client) = makeSUT(sett)
        
        expectStart(sut, toCompleteWith: .success(sett.appId), when: {
            client.completeStartSDKSuccessfuly()
        })
    }
    
    func test_stardSDK_failsOnWrongId() {
        let (sut, client) = makeSUT()
        
        expectStart(sut, toCompleteWith: .failure(.initFailed), when: {
            client.completeStartSDKWithError()
        })
    }
    
    func test_startSDK_notReturnsWhenInstanceIsDeallocated() {
        let settings = ChatSettings(appId: anyAppId, userId: anyUserID, token: anyToken)
        let client = ChatClientSpy(settings: settings)
        var sut: ClientManager? = ClientManager(chat: client, httpClient: ChatHTTPClientMock())
        
        var capturedResult = [Result]()
        sut?.start(anyAppId) { capturedResult.append($0) }
        
        sut = nil
        client.completeStartSDKSuccessfuly()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(_ settings: ChatSettings = ChatClientManagerTests.anySettings) -> (sut: ClientManager, client: ChatClientSpy) {
        let (sut, client) = makeOptionalSUT(settings)
        
        trackMemoryLeaks(client)
        trackMemoryLeaks(sut!)
        
        return (sut!, client)
    }
    
    private func makeOptionalSUT(_ settings: ChatSettings = ChatClientManagerTests.anySettings) -> (sut: ClientManager?, client: ChatClientSpy) {
        let settings = ChatSettings(appId: settings.appId, userId: settings.userId, token: settings.token)
        let client = ChatClientSpy(settings: settings)
        let sut: ClientManager? = ClientManager(chat: client, httpClient: ChatHTTPClientMock())
        
        trackMemoryLeaks(client)
        trackMemoryLeaks(sut!)
        
        return (sut, client)
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
        let sett = ChatSettings(appId: "appId-10101", userId: "userId-2222", token: "11111")

        let (sut, client) = makeSUT(sett)
        client.isInitialize = true

        expectLogin(sut, toCompleteWith: .success(sett.userId), when: {
            client.completeLoginWithSuccess()
        })
    }
    
    func test_loginSDK_deliversErrorOnInvalidUserId() {
        let (sut, client) = makeSUT()
        
        client.isInitialize = true
        expectLogin(sut, toCompleteWith: .failure(.invalidUserID), when: {
            client.completeLoginWithErrorInvalidUserID()
        })
    }
    
    func test_loginSDK_deliversErrorOnInvalidToken() {
        let (sut, client) = makeSUT()
        
        client.isInitialize = true
        expectLogin(sut, toCompleteWith: .failure(.invalidToken), when: {
            client.completeLoginWithErrorInvalidToken()
        })
    }
    
    func test_loginWontCallBeforeInitilized() {
        let (sut, _) = makeSUT()
        
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
