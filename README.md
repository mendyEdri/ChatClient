# myCWT Chat 

## BDD Specs

### Story: Customer would like to start a chat with an agent via myCWT iOS App

### Nerative #1:

``` 
As an online customer,
I want to open the app and see a chat bubble that will let me start a conversation.
```

#### Scenarios (Acceptance creteria)

```
Giving the customer has connectivity
    When the customer opens the app to chat with an agent
    Then the app should display the chat establishing connection to remote
```

#### Scenario Every customer open the app with chat

```
Giving the customer is a first time chat customer
    When the customer opens the app for the first time a requet should be sent
    Then the app should send request to save his 
```

```
// -- Requests & Storage
    
Given the appId isn't saved locally
    When the prepare() get called
    Then the app will request the STS-metadata API
    
Given the appId is saved locally
    When the prepare() get called
    Then the app will check if user token is saved locally
    
Given the user token isn't saved locally
    When the prepare() get called
    Then the app will call STS API
    
Given the user token is saved locally
    When the prepare() get called
    Then the app will validate the user token isn't expired
    
Given the user token is not expired
    When the prepare() get called
    Then the app will call STS API (to renew the token)
    
Given the user token is not expired
    When the prepare() get called
    Then the app will call initialize on the ChatClient
    
Given the STS-metadata request completed
    When the request completed successfuly
    Then the app will save the appId locally
    
Given the STS-metadata request completed
    When the request completed with error
    Then the app will retry for one more time
    
//-- SDK
    
Given the initialize on ChatClient get called
    When the initialize completed with error
    Then the app will request the STS-Metadata again (in-case the app id has changed)
    
Given the initialize on ChatClient got called
    When the initialize complete successfuly
    Then the app will call login on the chat client
    
Given the login on ChatClient got called
    When the login completed with error
    Then the app will call logout on ChatClient and will call STS API (to renew the token)
    
Given the login on ChatClient got called
    When the login completed successfuly
    Then the prepare() completion completed successfuly
    
```
