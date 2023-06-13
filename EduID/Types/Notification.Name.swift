//
//  Notification.Name.swift
//  
//
//  Created by Jairo Bambang Oetomo on 14/03/2023.
//

import Foundation

extension Notification.Name {
    
    public static let createEduIDDidReturnFromMagicLink = Notification.Name("createEduIDDidReturnFromMagicLink")
    public static let didAddLinkedAccounts = Notification.Name("didAddLinkedAccounts")
    public static let didUpdateEmail = Notification.Name("didUpdateEmail")
    public static let firstTimeAuthorizationComplete = Notification.Name(rawValue: "firstTimeAuthorizationComplete")
    public static let firstTimeAuthorizationCompleteWithSecretPresent = Notification.Name(rawValue: "firstTimeAuthorizationCompleteWithSecretPresent")
    
}
