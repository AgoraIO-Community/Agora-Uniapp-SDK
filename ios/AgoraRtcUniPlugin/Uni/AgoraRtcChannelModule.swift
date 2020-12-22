//
//  AgoraRtcChannelModule.swift
//  AgoraRtcUniPlugin
//
//  Created by LXH on 2020/12/14.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var manager: UInt8 = 0
}

public extension AgoraRtcChannelModule {
    private var manager: RtcChannelManager? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.manager) as? RtcChannelManager
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.manager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc
    func initManager() {
        manager = RtcChannelManager() { [weak self] methodName, data in
            self?.emit(methodName, data)
        }
    }

    private func emit(_ methodName: String, _ data: Dictionary<String, Any?>?) {
        weexInstance?.fireGlobalEvent("\(RtcChannelEventHandler.PREFIX)\(methodName)", params: data)
    }
    
    private weak var engine: AgoraRtcEngineKit? {
        return (weexInstance.module(for: AgoraRtcEngineModule.classForCoder()) as? AgoraRtcEngineModule)?.engine
    }

    func channel(_ channelId: String) -> AgoraRtcChannel? {
        return manager?[channelId]
    }

    @objc
    func callMethod(_ params: NSDictionary, _ callback: @escaping WXModuleCallback) {
        if let methodName = params["method"] as? String {
            if let args = params["args"] as? NSDictionary {
                if methodName == "create" {
                    args.setValue(engine, forKey: "engine")
                }
                manager?.perform(NSSelectorFromString(methodName + "::"), with: args, with: UniCallback(callback))
            } else {
                manager?.perform(NSSelectorFromString(methodName + ":"), with: UniCallback(callback))
            }
        }
    }
}
