package io.agora.rtc.uni

import android.content.Context
import com.alibaba.fastjson.JSONObject
import io.agora.rtc.base.RtcChannelManager
import io.agora.rtc.base.RtcEngineManager
import io.agora.rtc.base.RtcTextureView
import io.dcloud.feature.uniapp.UniSDKInstance
import io.dcloud.feature.uniapp.ui.action.AbsComponentData
import io.dcloud.feature.uniapp.ui.component.AbsVContainer
import io.dcloud.feature.uniapp.ui.component.UniComponent
import io.dcloud.feature.uniapp.ui.component.UniComponentProp

class AgoraRtcTextureView(
        instance: UniSDKInstance?,
        parent: AbsVContainer<*>?,
        componentData: AbsComponentData<*>?)
    : UniComponent<RtcTextureView>(instance, parent, componentData) {
    override fun initComponentHostView(context: Context): RtcTextureView {
        return RtcTextureView(context.applicationContext)
    }

    @UniComponentProp(name = "data")
    fun setData(data: JSONObject) {
        data.toMap().let { map ->
            val channel = (map["channelId"] as? String)?.let { RtcChannelManager[it] }
            RtcEngineManager.engine?.let { hostView.setData(it, channel, (map["uid"] as Number).toInt()) }
        }
    }

    @UniComponentProp(name = "renderMode")
    fun setRenderMode(renderMode: Int) {
        RtcEngineManager.engine?.let { hostView.setRenderMode(it, renderMode) }
    }

    @UniComponentProp(name = "mirrorMode")
    fun setMirrorMode(mirrorMode: Int) {
        RtcEngineManager.engine?.let { hostView.setMirrorMode(it, mirrorMode) }
    }
}
