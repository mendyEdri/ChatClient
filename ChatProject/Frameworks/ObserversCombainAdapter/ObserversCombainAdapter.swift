//
//  ObserversAdapter.swift
//  ChatProject
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

/** ObserversCombainAdapter uses for managing multiple Notification observation from a single place.
    By default it uses the NotificationCenter.default, but it can be overrided to use your own `init(notificationCenter: NotificatoinCenter)`
*/
 
public final class ObserversCombainAdapter {
    
    private var notifications = Set<Notification.Name>()
    private var completion: (Notification) -> Void = { _ in }
    private var dispatcher: NotificationCenter
    
    public init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        dispatcher = notificationCenter
    }

    public convenience init(notificationCenter: NotificationCenter = NotificationCenter.default, names: Notification.Name...) {
        self.init()
        dispatcher = notificationCenter
        observeOver(names)
    }
    
    public func addObservers(_ names: Notification.Name...) {
        guard names.count > 0 else { return }
        observeOver(names)
    }
    
    public func removeObservers(_ names: Notification.Name...) {
        names.forEach { name in
            self.notifications.remove(name)
            dispatcher.removeObserver(self, name: name, object: nil)
        }
    }
    
    public func removeAllObservers() {
        notifications.forEach { name in
            dispatcher.removeObserver(self, name: name, object: nil)
        }
        notifications.removeAll()
    }
    
    public var currentObservers: Set<Notification.Name> {
        return notifications
    }
    
    public func notifying(_ completion: @escaping (Notification) -> Void) {
        self.completion = completion
    }
    
    // MARK: Helpers
    
    private func observeOver(_ names: [Notification.Name]) {
        names.forEach { name in
            self.notifications.insert(name)
            observe(to: name)
        }
    }
    
    @objc private func notify(_ notification: Notification) {
        completion(notification)
    }
    
    private func observe(to notificationName: Notification.Name) {
        dispatcher.addObserver(self, selector: #selector(notify(_:)), name: notificationName, object: nil)
    }
}
