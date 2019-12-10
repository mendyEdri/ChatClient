//
//  ClientProcessStrategy.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 08/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
@testable import TDDChatProject

class ClientProcessStrategyTests: XCTestCase {
    
    internal typealias NextStep = ChatManagerNextStepType
    
    func test_nextStep_deliversRemoteFetchAppId() {
        let (sut, _, _) = makeSUT()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.remoteFetchAppId)
    }
    
    func test_nextStep_deliversRemoteFetchTokenOnNonSavedToken() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.remoteFetchUserToken)
    }
    
    func test_nextStep_deliversRemoteFetchAppIdOnNoAppIdAndTokenExists() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyToken, for: client.userTokenKey)
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.remoteFetchAppId)
    }
    
    func test_nextStep_deliversFetchRemoteAppId_onValidTokenAndNonExistingAppId() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: "", for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.remoteFetchAppId)
    }
    
    func test_nextStep_deliversRemoteFetchAppId_onTokenExpiredToken() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: expiredJwt, for: client.userTokenKey)
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.remoteFetchUserToken)
    }
    
    func test_nextStep_deliversSDKInit_whenAppIdAndTokenAreValid() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKInit)
    }
    
    func test_nextStep_deliversSDKLogin_onClientInitializedSuccessfuly() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        client.startSDK(anyAppId, completion: { _ in })
        client.completeStartSDKSuccessfuly()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKLogin)
    }
    
    func test_nextStep_deliversSDKInit_onClientInitializedError() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        client.startSDK(anyAppId, completion: { _ in })
        client.completeStartSDKWithError()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKInit)
    }
    
    func test_nextStep_deliversSDKLogin_onInitSuccessfulyAndLoginFailed() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        client.startSDK(anyAppId, completion: { _ in })
        client.completeStartSDKSuccessfuly()
        
        client.login(userId: anyUserId, token: futureJwt, completion: { _ in })
        client.completeLoginWithErrorInvalidToken()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKLogin)
    }
    
    func test_nextStep_deliversSDKInit_onClientInitFailedAndLoginSuccessfuly() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        client.startSDK(anyAppId, completion: { _ in })
        client.completeStartSDKWithError()
        
        client.login(userId: anyUserId, token: futureJwt, completion: { _ in })
        client.completeLoginWithSuccess()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKInit)
    }
    
    func test_nextStep_deliversSDKInit_onInitAndLoginFailed() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        client.startSDK(anyAppId, completion: { _ in })
        client.completeStartSDKWithError()
        
        client.login(userId: anyUserId, token: futureJwt, completion: { _ in })
        client.completeLoginWithErrorInvalidToken()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKInit)
    }
    
    func test_nextStep_deliversSDKReady_onClientInitAndLoginSuccessfuly() {
        let (sut, storage, client) = makeSUT()
        
        storage.save(value: anyAppId, for: client.appIdKey)
        storage.save(value: futureJwt, for: client.userTokenKey)
        
        client.startSDK(anyAppId, completion: { _ in })
        client.completeStartSDKSuccessfuly()
        
        client.login(userId: anyUserId, token: futureJwt, completion: { _ in })
        client.completeLoginWithSuccess()
        
        let result = sut.nextStepExecution()
        
        XCTAssertEqual(result, NextStep.SDKReadyToUse)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> (sut: MainClientProcessStrategy, storage: Storage, chatClient: ChatClientSpy) {
        let chatClient = anyChatClient
        let storage = UserDefaultStorageMock()
        
        let sut = MainClientProcessStrategy(client: chatClient, storage: storage, jwt: Jwt())
        return (sut, storage, chatClient)
    }
}

extension ClientProcessStrategyTests {
    
    private var anyChatClient: ChatClientSpy {
        let settings = ChatSettings(appId: anyAppId, token: anyToken, userId: anyUserId)
        let clientSpy = ChatClientSpy(settings: settings)
        return clientSpy
    }
}

extension ClientProcessStrategyTests {
    
    //MARK: Values
    
    private var anyAppId: String {
        return "raywenderlich"
    }
    
    private var anyToken: String {
        return "PAUL.HAGARTY"
    }
    
    private var anyUserId: String {
        return "SIMON.ALLARDICE"
    }
    
    //MARK: Keys
}

internal extension ClientProcessStrategyTests {
    // Experation date in 2029
    var futureJwt: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE4OTE0MzEwNTcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.4DXgPqyAxvw2DpRFKHjmCMMY3vr4k3od4BNyV2oSNXE"
    }
    
    var expiredJwt: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjExNzI2MTExNzcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.PHdCsv40vXi56McA3084aDkVeuIkOlAK5Jm2_IU8Io8"
    }
    
    var corruptedJwt: String {
        return "%%$@@@!!eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIi--@@XXXOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjExNzI2MTExNzcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.PHdCsv40vXi56McA3084aDkVeuIkOlAK5Jm2_IU8Io8"
    }
    
    var emptyJwt: String {
        return ""
    }
}
