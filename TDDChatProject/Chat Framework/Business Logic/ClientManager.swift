//
//  ChatClientManager.swift
//  CWTTests
//
//  Created by Mendy Edri on 07/11/2019.
//

import Foundation

/** Holds the data ClientManager needs to be injected with
 ChatClient - Chat SDK or framework, call sdk-start, sdk-login & sdk-logout.
 ChatHTTPClient - Remote API caller, calls appId API call (STS-Metadata) and vendor user token (STS) API */

public struct ClientManagerClients {
    var chatClient: ChatClient
    var httpClient: ChatHTTPClient
    var jwtClient: Jwtable
    var storage: Storage
}

/** Holds application specific business logic, interact with ChatClient and run the right client request via ChatHTTPClient, according to it state. */

public class ClientManager {
    public typealias Result = Swift.Result<String, ClientManager.Error>
    public typealias APIResult = Swift.Result<String, Error>
    
    /** Prepare function Result-type error */
    public enum Error: Swift.Error {
        case initFailed
        case invalidUserID
        case invalidToken
        case sdkNotInitialized
        case logoutFails
    }
    
    enum ClientState {
        case notReady
        case ready
        case failed(Swift.Error)
    }
    
    private var clientState: ClientState = .notReady {
        didSet {
            prepareCompletion(clientState)
        }
    }
    
    private var clients: ClientManagerClients
    
    private var chatClient: ChatClient {
        return clients.chatClient
    }
    
    private var httpClient: ChatHTTPClient {
        return clients.httpClient
    }
    
    private var storage: Storage {
        return clients.storage
    }
    
    private var appIdKey: String {
        return clients.chatClient.appIdKey
    }
    
    private var userTokenKey: String {
        return clients.chatClient.userTokenKey
    }
    
    private var appId: String? {
        return clients.storage.value(for: clients.chatClient.appIdKey) as? String
    }
    
    private var userToken: String? {
        return clients.storage.value(for: clients.chatClient.userTokenKey) as? String
    }
    
    private var userId: String? {
        if let token = self.clients.storage.value(for: userTokenKey) as? String {
            self.clients.jwtClient.jwtString = token
            return self.clients.jwtClient.value(for: "userId")
        }
        return nil
    }
    
    private lazy var appIdLoader = RemoteAppIdLoader(url: appIdEndpointURL, client: clients.httpClient)
    
    private lazy var userTokenLoader = RemoteTokenLoader(url: userTokenEndpointURL, client: clients.httpClient)
    
    private let appIdEndpointURL = URL(string: "https://api.worldmate.com/tokens/vendors/smooch/metadata")!
    
    private let userTokenEndpointURL = URL(string: "https://api.worldmate.com/tokens/vendors/smooch")!
    
    private var strategy: MainClientProcessStrategy
    
    var prepareCompletion: (ClientState) -> Void = { _ in }
        
    public init(clients: ClientManagerClients) {
        self.clients = clients
        
        strategy = MainClientProcessStrategy(client: clients.chatClient, storage: clients.storage, jwt: Jwt())
    }
}

extension ClientManager {
    
    typealias CompletionResult = (Result) -> Void
    typealias CompletionAPIResult = (APIResult) -> Void
    
    struct Actions {
        var sdkInit: CompletionResult
        var sdkLogin: CompletionResult
        var fetchRemoteAppId: CompletionAPIResult
        var fetchRemoteUserToken: CompletionAPIResult
    }
    
    /** Instantiate Chat SDK and Login */
    
    func prepare(_ completion: @escaping (ClientState) -> Void) {
        prepareCompletion = completion
        startSDKPreparation(strategy)
    }
    
    private func startSDKPreparation(_ strategy: MainClientProcessStrategy) {
        let strategy = strategy.nextExecution()
        debugPrint(strategy)
        
        switch strategy {
        case .remoteFetchAppId:
            loadAndSaveAppId { [weak self] result in
                guard let self = self else { return }
                
                // mapped Result<RemoteAppIdLoader, Error> with a spesific type to Result<String, Erro> more generic type to have single handle function
                self.handle(result.map { $0.appId })
            }
            
        case .remoteFetchUserToken:
            loadAndSaveUserToken { [weak self] result in
                guard let self = self else { return }
                
                self.handle(result.map { $0.accessToken })
            }
            
        case .SDKInit:
            #warning("handle return")
            guard let appId = appId else { return }
            
            start(appId) { [weak self] result in
                guard let self = self else { return }
                self.handle(result)
            }
            
        case .SDKLogin:
            #warning("handle return")
            guard let userToken = userToken, let userId = userId
                else { return }
            
            login(userId: userId, token: userToken) { [weak self] result in
                guard let self = self else { return }
                self.handle(result.map { $0 })
            }
            
        case .SDKReadyToUse:
            clientState = .ready
        }
    }
    
    //MARK: - Helpers
    
    /* Uses Genric function to bypass swift compilation error that it won't compile when the function getting Result<SomeType, Swift.Error> and we send some Swift.Error specific implementation (such as Class.Error),
     In Functions, the same behaviour of passing a spesific implementation of an Error to a generic Swift.Error parameter will work. :\--
     */
    private func handle<T>(_ result: Swift.Result<String, T>) where T: Swift.Error {
        
        switch result {
        case .success:
            self.startSDKPreparation(strategy)
            
        case let .failure(error):
            self.clientState = .failed(error)
            // mm..should we retry here?
        }
    }
}

// MARK: - ChatClient calls
extension ClientManager {
    internal func start(_ appId: String, completion: @escaping ((Result) -> Void)) {
        chatClient.startSDK(appId) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    internal func login(userId: String, token: String, completion: @escaping (Result) -> Void) {
        guard chatClient.initialized() == true else {
            completion(.failure(.sdkNotInitialized))
            // to indicate failing if login called before initialize SDK
            return
        }
        chatClient.login(userId: userId, token: token) { result in
            completion(result)
        }
    }
}

// MARK: - Our Endpoints Calls (AppId + Token)
extension ClientManager {
    
    private func loadAndSaveAppId(_ completion: @escaping (RemoteAppIdLoader.Result) -> Void) {
        appIdLoader.load(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(appIdItem):
                self.storage.save(value: appIdItem.appId, for: self.appIdKey)
                return completion(.success(appIdItem))
                
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    private func loadAndSaveUserToken(_ completion: @escaping (RemoteTokenLoader.Result) -> Void) {
        userTokenLoader.load(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(vendorToken):
                self.storage.save(value: vendorToken.accessToken, for: self.userTokenKey)
                completion(result)
                
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
