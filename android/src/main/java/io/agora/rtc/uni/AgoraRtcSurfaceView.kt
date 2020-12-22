package io.agora.rtc.uni

import android.content.Context
import com.alibaba.fastjson.JSONObject
import io.agora.rtc.RtcChannel
import io.agora.rtc.RtcEngine
import io.agora.rtc.base.RtcSurfaceView
import io.dcloud.feature.uniapp.UniSDKInstance
import io.dcloud.feature.uniapp.ui.action.AbsComponentData
import io.dcloud.feature.uniapp.ui.component.AbsVContainer
import io.dcloud.feature.uniapp.ui.component.UniComponent
import io.dcloud.feature.uniapp.ui.component.UniComponentProp

class AgoraRtcSurfaceView(
        instance: UniSDKInstance?,
        parent: AbsVContainer<*>?,
        componentData: AbsComponentData<*>?)
    : UniComponent<RtcSurfaceView>(instance, parent, componentData) {
    override fun initComponentHostView(context: Context): RtcSurfaceView {
        return RtcSurfaceView(context.applicationContext)
    }

    @UniComponentProp(name = "zOrderMediaOverlay")
    fun setZOrderMediaOverlay(isMediaOverlay: Boolean) {
        hostView.setZOrderMediaOverlay(isMediaOverlay)
    }

    @UniComponentProp(name = "zOrderOnTop")
    fun setZOrderOnTop(onTop: Boolean) {
        hostView.setZOrderOnTop(onTop)
    }

    @UniComponentProp(name = "data")
    fun setData(data: JSONObject) {
        data.toMap().let { map ->
            val channel = (map["channelId"] as? String)?.let { getChannel(it) }
            getEngine()?.let { hostView.setData(it, channel, (map["uid"] as Number).toInt()) }
        }
    }

    @UniComponentProp(name = "renderMode")
    fun setRenderMode(renderMode: Int) {
        getEngine()?.let { hostView.setRenderMode(it, renderMode) }
    }

    @UniComponentProp(name = "mirrorMode")
    fun setMirrorMode(mirrorMode: Int) {
        getEngine()?.let { hostView.setMirrorMode(it, mirrorMode) }
    }

    private fun getEngine(): RtcEngine? {
        return AgoraRtcEngineModule.manager?.engine
    }

    private fun getChannel(channelId: String): RtcChannel? {
        return AgoraRtcChannelModule.manager?.get(channelId)
    }
}
