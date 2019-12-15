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
    //private typealias Result = ClientManager.Result
    private typealias Result = Swift.Result<String, ClientManager.Error>
    
    private var ValidAppId: String {
        return "FU#KPLASTIC2020"
    }
    
    private var anyUserID: String {
        return "anyUser19203"
    }
    
    // experation date in 2029
    private var futureToken: String {
       return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE4OTE0MzEwNTcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.4DXgPqyAxvw2DpRFKHjmCMMY3vr4k3od4BNyV2oSNXE"
      }
    
    private var expiredToken: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1NDQyNjU4NTcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.HsMn_2_Ym2RDhazQs-PCvLd5V54a8FkVRR7vXs8_KjI"
    }
    
    private var futureTokenWithEmptyUserId: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE4OTE0MzEwNTcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6IiJ9.VhNo_gGtTnnWAqGsRlk9o3C4UWM4EmwxiT7P2qeE190"
    }
        
    private var futureTokenWithoutUserId: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE4OTE0MzEwNTcsImlkIjoicGluZ0lkMTIzNCJ9.ALvokNaSsHcOw035a6895Z-1ptxIYVUuyXF-ZCwS2Oo"
    }
    
    private lazy var anyAppId = "10203"
}

extension ChatClientManagerTests {
   
    #warning("Should it be on end-to-end tests?")
    func test_prepareSDK_notDeliveringWhenInstanceHasBeenDeallocated() {
        var (sut, client, _, _) = makeSUT()
    
        var capturedResult = [ClientManager.ClientState]()
        
        sut?.prepare { result in
            capturedResult.append(result)
        }
        
        sut = nil
        client.complete(withSatus: 200, data: JSONMockData.appIdRemoteApiData().toData())
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
        
    // MARK: Helpers
    
    private func makeSUT() -> (sut: ClientManager?, httpClient: ChatHTTPClientMock, chatClient: ChatClientSpy, storage: Storage) {
        let (managerClients, httpClient, chatClient, storage) = makeClients()
        let sut: ClientManager? = ClientManager(clients: managerClients)
        
        trackMemoryLeaks(sut!)
        
        return (sut, httpClient, chatClient, storage)
    }
    
    private func makeClients() -> (managerClients: ClientManagerClients, httpClient: ChatHTTPClientMock, chatClient: ChatClientSpy, storage: Storage) {
        let chatCliet = ChatClientSpy()
        let httpClient = ChatHTTPClientMock()
        let jwt = Jwt()
        let storage = UserDefaultStorageMock()
        let strategy = TokenBasedClientStrategy(client: chatCliet, storage: storage, jwt: jwt)
        
    
        let clients = ClientManagerClients(chatClient: chatCliet, httpClient: httpClient, jwtClient: jwt, storage: storage, strategy: strategy)
        
        trackMemoryLeaks(chatCliet)
        trackMemoryLeaks(httpClient)
        trackMemoryLeaks(storage)
        trackMemoryLeaks(strategy)
        
        return (clients, httpClient, chatCliet, storage)
    }
}
