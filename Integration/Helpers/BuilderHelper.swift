//
//  BuilderHelper.swift
//  Integration
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

struct BuilderHelper {
    func buildSuccessHeaderAndMeta() -> (header: ResponseHeader, meta: ResponseMetadata) {
        let header = ResponseHeader(statusMessage: "success")
        let meta = ResponseMetadata(trxId: "10939", reqId: "93838", status: "success")
        
        return (header, meta)
    }
}
