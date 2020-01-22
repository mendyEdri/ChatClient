//
//  ChatClientMediatorTests.swift
//  CWTTests
//
//  Created by Mendy Edri on 07/11/2019.
//

import XCTest
import lit_networking
@testable import TDDChatProject

// MARK: - Client Prepare SDK Tests

class ClientMediatorTests: XCTestCase {
    
    private typealias Error = ClientMediator.Error
    private typealias Result = Swift.Result<String, ClientMediator.Error>
    
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
    
    private var anyAppId = "10203"
}

extension ClientMediatorTests {
   
    func test_prepareSDK_notDeliveringWhenInstanceHasBeenDeallocated() {
        var (sut, client, _, _) = makeSUT()
    
        var capturedResult = [ClientMediator.ClientState]()
        
        sut?.prepare { result in
            capturedResult.append(result)
        }
        
        sut = nil
        client.complete(withSatus: 200, data: JSONMockData.appIdRemoteApiData().toData())
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> (sut: ClientMediator?, httpClient: HTTPClientMock, chatClient: ChatClientSpy, storage: Storage) {
        let (managerClients, httpClient, chatClient, storage) = makeClients()
        let sut: ClientMediator? = ClientMediator(clients: managerClients)
        
        trackMemoryLeaks(sut!)
        
        return (sut, httpClient, chatClient, storage)
    }
    
    private func makeClients() -> (managerClients: ClientMediatorClients, httpClient: HTTPClientMock, chatClient: ChatClientSpy, storage: Storage) {
        let chatCliet = ChatClientSpy()
        let httpClient = HTTPClientMock()
        let jwt = Jwt()
        let storage = UserDefaultStorageMock()
        let strategy = TokenBasedClientStrategy(client: chatCliet, storage: storage, jwt: jwt)
        
    
        let clients = ClientMediatorClients(chatClient: chatCliet, httpClient: httpClient, jwtClient: jwt, storage: storage, strategy: strategy)
        
        trackMemoryLeaks(chatCliet)
        trackMemoryLeaks(httpClient)
        trackMemoryLeaks(storage)
        trackMemoryLeaks(strategy)
        
        return (clients, httpClient, chatCliet, storage)
    }
}
