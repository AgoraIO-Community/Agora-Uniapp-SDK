//
//  AgoraRtcSurfaceView.swift
//  AgoraRtcUniPlugin
//
//  Created by LXH on 2020/12/14.
//

import Foundation

@objc(AgoraRtcSurfaceView)
public class AgoraRtcSurfaceView : WXComponent {
    @objc
    override init() {
        super.init()
    }

    @objc
    override init(ref: String, type: String, styles: [AnyHashable : Any]?, attributes: [AnyHashable : Any]? = nil, events: [Any]?, weexInstance: WXSDKInstance) {
        super.init(ref: ref, type: type, styles: styles, attributes: attributes, events: events, weexInstance: weexInstance)
    }

    @objc
    public override func loadView() -> UIView {
        let view = RtcView()
        view.setEngine(engine)
        view.setChannel(channel(_:))
        return view
    }

    @objc
    public override func viewDidLoad() {
        if let view = self.view as? RtcView {
            view.setData(attributes["data"] as! NSDictionary)
            view.setRenderMode(NSNumber(value: WXConvert.nsuInteger(attributes["renderMode"])))
            view.setMirrorMode(NSNumber(value: WXConvert.nsuInteger(attributes["mirrorMode"])))
        }
    }

    @objc
    public override func updateAttributes(_ attributes: [AnyHashable : Any] = [:]) {
        if let view = self.view as? RtcView {
            if let data = attributes["data"] as? NSDictionary {
                view.setData(data)
            }
            if let renderMode = attributes["renderMode"] {
                view.setRenderMode(NSNumber(value: WXConvert.nsuInteger(renderMode)))
            }
            if let mirrorMode = attributes["mirrorMode"] {
                view.setMirrorMode(NSNumber(value: WXConvert.nsuInteger(mirrorMode)))
            }
        }
    }

    private func engine() -> AgoraRtcEngineKit? {
        return (weexInstance?.module(for: AgoraRtcEngineModule.classForCoder()) as? AgoraRtcEngineModule)?.engine
    }

    private func channel(_ channelId: String) -> AgoraRtcChannel? {
        return (weexInstance?.module(for: AgoraRtcChannelModule.classForCoder()) as? AgoraRtcChannelModule)?.channel(channelId)
    }
}

@objc(RtcView)
class RtcView: RtcSurfaceView {
    private var getEngine: (() -> AgoraRtcEngineKit?)?
    private var getChannel: ((_ channelId: String) -> AgoraRtcChannel?)?

    func setEngine(_ getEngine: @escaping () -> AgoraRtcEngineKit?) {
        self.getEngine = getEngine
    }

    func setChannel(_ getChannel: @escaping (_ channelId: String) -> AgoraRtcChannel?) {
        self.getChannel = getChannel
    }

    @objc func setRenderMode(_ renderMode: NSNumber) {
        if let engine = getEngine?() {
            setRenderMode(engine, renderMode.uintValue)
        }
    }

    @objc func setData(_ data: NSDictionary) {
        var channel: AgoraRtcChannel? = nil
        if let channelId = data["channelId"] as? String {
            channel = getChannel?(channelId)
        }
        if let engine = getEngine?() {
            setData(engine, channel, WXConvert.nsuInteger(data["uid"]))
        }
    }

    @objc func setMirrorMode(_ mirrorMode: NSNumber) {
        if let engine = getEngine?() {
            setMirrorMode(engine, mirrorMode.uintValue)
        }
    }
}
