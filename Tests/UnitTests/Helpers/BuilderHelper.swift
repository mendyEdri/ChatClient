//
//  BuilderHelper.swift
//  ChatHTTPLoaderTests
//
//  Created by Mendy Edri on 05/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
@testable import ChatProject

struct BuilderHelper {
    func buildSuccessHeaderAndMeta() -> (header: ResponseHeader, meta: ResponseMetadata) {
        let header = ResponseHeader(statusMessage: "success")
        let meta = ResponseMetadata(trxId: "10939", reqId: "93838", status: "success")
        
        return (header, meta)
    }
}
