//
//  URLS+STS.swift
//  ChatProject
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

extension URLS {
    
    private var smoochVendorName: String {
        return "smooch"
    }
    
    /** /tokens/vendors/{VENDOR_NAME}/metadata */
    var smoochVendorAppId: URL {
        return URL(string: vendorAppIdEndpoint(for: smoochVendorName))!
    }
    
    /** /tokens/vendors/{VENDOR_NAME} */
    var smoochVendorToken: URL {
        return URL(string: vendorTokenEndpoint(for: smoochVendorName))!
    }
    
    // Helpers -
    
    // Intentially I didn't combined them so if one is got changed the other won't be coupled with it's endpoint
    private func vendorAppIdEndpoint(for vendorName: String) -> String {
        return "\(apiBase)/tokens/vendors/\(vendorName)/metadata"
    }
    
    private func vendorTokenEndpoint(for vendorName: String) -> String {
        return "\(apiBase)/tokens/vendors/\(vendorName)"
    }
}
