//
//  BuilderHelper.swift
//  ChatHTTPLoaderTests
//
//  Created by Mendy Edri on 05/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
@testable import TDDChatProject

struct BuilderHelper {
    func buildSuccessHeaderAndMeta() -> (ResponseHeader, ResponseMetadata) {
        let header = ResponseHeader(statusMessage: "success")
        let meta = ResponseMetadata(trxId: "10939", reqId: "93838", status: "success")
        
        return (header, meta)
    }
    
}
