//
//  UniCallback.swift
//  AgoraRtcUniPlugin
//
//  Created by LXH on 2020/12/14.
//

import Foundation
import AgoraRtcKit

@objc(UniCallback)
class UniCallback: NSObject, Callback {
    private var callback: WXModuleCallback?

    init(_ callback: WXModuleCallback?) {
        self.callback = callback
    }

    func success(_ data: Any?) {
        callback?(data)
    }

    func failure(_ code: String, _ message: String) {
        callback?(["code":code, "message":message])
    }
}
