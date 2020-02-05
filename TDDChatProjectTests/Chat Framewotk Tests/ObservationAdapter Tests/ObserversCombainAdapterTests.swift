//
//  ObserversCombainAdapterTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import XCTest
import TDDChatProject


private extension Notification.Name {
    static let office = Notification.Name("working-from-office")
    static let home = Notification.Name("working-from-home")
    static let eating = Notification.Name("eating")
    static let drinkingCoffee = Notification.Name("drinking-coffee")
}

class ObserversCombainAdapterTests: XCTestCase {
    
    // MARK: - `notifying()` tests
    
    func test_notifying_singleNotification() {
        let dispatcher = NotificationCenter()
        let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
        observers.addObservers(.office)
        
        expect(sut: observers, to: [.office], when: {
            dispatcher.post(.office)
        })
    }
    
    func test_notifying_receiveNotification_notInSameOrderOfExecution() {
        let dispatcher = NotificationCenter()
        let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
        observers.addObservers(.drinkingCoffee, .eating)
        
        expect(sut: observers, to: [.drinkingCoffee, .eating], when: {
            dispatcher.post(.eating, .drinkingCoffee)
        })
    }
    
    func test_notifying_removeNotificatoinWillStopObservingToTheRemovedNotification() {
        let dispatcher = NotificationCenter()
        let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
        var names: [Notification.Name] = [.eating, .drinkingCoffee, .home]
        
        names.forEach { observers.addObservers($0) }
        names.removeAll { $0 == .eating }
        
        expect(sut: observers, to: names, when: {
            observers.removeObservers(.eating)
            dispatcher.post(.eating, .drinkingCoffee, .home)
        })
    }
    
    // MARK: - `removeAllObservers` tests
    
    func test_removeAllObserver_removeAllNotificatoinWillStopObserving() {
        let dispatcher = NotificationCenter()
        let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
        let names: [Notification.Name] = [.eating, .drinkingCoffee, .home]
        
        names.forEach { observers.addObservers($0) }
        observers.removeAllObservers()
        
        observers.notifying { _ in
            XCTFail("We removed all observers, this block should not be called")
        }
        dispatcher.post(names)
    }
    
    // MARK: - `currentObservers()` tests
    
    func test_currentObservers_returnsSameObserversAsInserted() {
        let dispatcher = NotificationCenter()
        let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
        let names: [Notification.Name] = [.eating, .drinkingCoffee, .home]
        
        names.forEach { observers.addObservers($0) }
        XCTAssertEqual(observers.currentObservers, Set(names))
    }
    
    func test_currentObservers_returnTheRightValueAfterRemovingObserver() {
        let dispatcher = NotificationCenter()
        let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
    
        [.eating, .drinkingCoffee, .home].forEach { observers.addObservers($0) }
        observers.removeObservers(.drinkingCoffee)
        
        XCTAssertEqual(observers.currentObservers, Set([.eating, .home]))
    }
    
    func test_currentObservers_returnTheRightValueWhenRemovingAll() {
         let dispatcher = NotificationCenter()
         let observers = ObserversCombainAdapter(notificationCenter: dispatcher)
     
         [.eating, .drinkingCoffee, .home].forEach { observers.addObservers($0) }
         observers.removeAllObservers()
         
         XCTAssertEqual(observers.currentObservers, Set([]))
     }
    
    // MARK: - Helpers
    
    private func expect(sut: ObserversCombainAdapter, to observers: [Notification.Name], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for notification to fire")
        var capturedResult = Set<Notification.Name>()
        
        sut.notifying {
            capturedResult.insert($0.name)
            if capturedResult.count == observers.count { exp.fulfill() }
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedResult, Set(observers), file: file, line: line)
    }
}

private extension NotificationCenter {
    func post(_ names: Notification.Name...) {
        post(names)
    }
    
    func post(_ names: [Notification.Name]) {
        names.forEach { name in
            post(name: name, object: nil)
        }
    }
}
