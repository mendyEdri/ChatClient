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
    var strategy: BasicProcessStrategy
}

/** Commands needs to run the sdk initialization process, conforms to AnyObject to have the Commands instance weak - to prevent retains cycle  */
private protocol Commands: AnyObject {
    typealias CommandsCompletion = (Swift.Result<String, ClientManager.Error>) -> Void
}

extension ClientManager: Commands {}

/** Holds application specific business logic, interact with ChatClient and run the right client request via ChatHTTPClient, according to it state. */

public class ClientManager {
    public typealias Result = Swift.Result<String, ClientManager.Error>
    public typealias APIResult = Swift.Result<String, Error>
    
    /** Prepare function Result-type error */
    public enum Error: Swift.Error {
        case initFailed
        case loginFailed
        case invalidToken
        case sdkNotInitialized
        case logoutFails
        case failsFetchAppId
        case failsFetchToken
    }
    
    public enum ImplementationError: Swift.Error {
        case appIdIsMissing, tokenOrUserIdAreMissing
    }
    
    enum ClientState: Equatable {
        case notReady
        case ready
        case failed
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
    
    private var strategy: BasicProcessStrategy {
        return self.clients.strategy
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
    
    var prepareCompletion: (ClientState) -> Void = { _ in }
    
    private weak var commands: Commands?
    
    public init(clients: ClientManagerClients) {
        self.clients = clients
        commands = self
    }
    
    deinit {
        debugPrint("ClientManager get's deallocated")
    }
}

extension ClientManager {
    
    /** Instantiate Chat SDK and Login */
    
    func prepare(_ completion: @escaping (ClientState) -> Void) {
        prepareCompletion = completion
        
        startSDKPreparation(strategy)
    }
    
    private func startSDKPreparation(_ strategy: BasicProcessStrategy) {
        let strategy = strategy.nextStepExecution()
        debugPrint(strategy)
        
        switch strategy {
        case .remoteFetchAppId:
            appIdCommand()
            
        case .remoteFetchUserToken:
            userTokenCommand()
            
        case .SDKInit:
            startCommand()
                        
        case .SDKLogin:
            loginCommand()
            
        case .SDKReadyToUse:
            readyCommand()
        }
    }
    
    private func save(result: Swift.Result<String, ClientManager.Error>, for key: String) {
        guard case let .success(value) = result else { return }
        storage.save(value: value, for: key)
    }

    
    //MARK: - Helpers
    
    /* Uses Genric function to bypass swift compilation error that it won't compile when the function getting Result<SomeType, Swift.Error> and we send some Swift.Error specific implementation (such as Class.Error),
     In Functions, the same behaviour of passing a spesific implementation of an Error to a generic Swift.Error parameter will work. :\--
     */
    private func handle<T>(_ result: Swift.Result<String, T>) where T: Swift.Error {
        
        switch result {
        case .success:
            self.startSDKPreparation(strategy)
            
        case .failure:
            self.clientState = .failed
            #warning("should we retry here?")
        }
    }
    
    private func completeDeveloperError(_ error: ImplementationError) {
        prepareCompletion(.failed)
    }
}

extension ClientManager {
    private func appIdCommand() {
        commands?.getRemoteAppId(loader: appIdLoader, completion: { [weak self] result in
            guard let self = self else { return }
            self.save(result: result, for: self.appIdKey)
            self.handle(result)
        })
    }
    
    private func userTokenCommand() {
        commands?.getRemoteToken(loader: userTokenLoader) { result in
            self.save(result: result, for: self.userTokenKey)
            self.handle(result)
        }
    }
    
    private func startCommand() {
        commands?.startSDK(for: (chatClient, appId)) { [weak self] result in
            guard let self = self else { return }
            self.handle(result)
        }
    }
    
    private func loginCommand() {
        commands?.loginSDK(for: (chatClient, userToken, userId)) { result in
            self.handle(result)
        }
    }
    
    private func readyCommand() {
        clientState = .ready
    }
}

extension Commands {
    
    fileprivate func getRemoteAppId(loader: RemoteAppIdLoader, completion: @escaping CommandsCompletion) {
        loader.load { [weak self] in
            guard self != nil else { return }
            completion($0.map { $0.appId }.mapError { _ in .failsFetchAppId })
        }
    }
    
    fileprivate func getRemoteToken(loader: RemoteTokenLoader, completion: @escaping CommandsCompletion) {
        loader.load { [weak self] in
            guard self != nil else { return }
            completion($0.map { $0.accessToken }.mapError { _ in .failsFetchToken })
        }
    }
    
    fileprivate func startSDK(for sdk: (client: ChatClient, appId: String?), completion: @escaping CommandsCompletion) {
        let client = sdk.client
        client.startSDK(sdk.appId) { [weak self] in
            guard self != nil else { return }
            completion($0.mapError { _ in .initFailed })
        }
    }
    
    fileprivate func loginSDK(for sdk: (client: ChatClient, token: String?, userId: String?), completion: @escaping CommandsCompletion) {
        
        guard let userId = sdk.userId, let token = sdk.token else {
            return completion(.failure(.invalidToken))
        }
        
        let client = sdk.client
        guard client.initialized() == true else {
            completion(.failure(.sdkNotInitialized))
            // to indicate failing if login called before initialize SDK
            return
        }
        
        client.login(userId: userId, token: token) { [weak self] result in
            guard self != nil else { return }
            completion(result.mapError { _ in return .loginFailed })
        }
    }
}
