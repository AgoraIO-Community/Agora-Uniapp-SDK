//
//  AgoraRtcEngineModule.swift
//  AgoraRtcUniPlugin
//
//  Created by LXH on 2020/12/14.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var manager: UInt8 = 0
}

public extension AgoraRtcEngineModule {
    private var manager: RtcEngineManager? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.manager) as? RtcEngineManager
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.manager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc
    func initManager() {
        manager = RtcEngineManager() { [weak self] methodName, data in
            self?.emit(methodName, data)
        }
    }

    private func emit(_ methodName: String, _ data: Dictionary<String, Any?>?) {
        weexInstance?.fireGlobalEvent("\(RtcEngineEventHandler.PREFIX)\(methodName)", params: data)
    }
    
    weak var engine: AgoraRtcEngineKit? {
        return manager?.engine
    }

    @objc
    func callMethod(_ params: NSDictionary, _ callback: @escaping WXModuleCallback) {
        if let methodName = params["method"] as? String {
            if let args = params["args"] as? NSDictionary {
                manager?.perform(NSSelectorFromString(methodName + "::"), with: args, with: UniCallback(callback))
            } else {
                manager?.perform(NSSelectorFromString(methodName + ":"), with: UniCallback(callback))
            }
        }
    }
}
