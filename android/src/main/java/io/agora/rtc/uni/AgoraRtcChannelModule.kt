package io.agora.rtc.uni

import com.alibaba.fastjson.JSONObject
import io.agora.rtc.RtcEngine
import io.agora.rtc.base.RtcChannelManager
import io.agora.rtc.base.RtcEngineEventHandler
import io.dcloud.feature.uniapp.annotation.UniJSMethod
import io.dcloud.feature.uniapp.bridge.UniJSCallback
import io.dcloud.feature.uniapp.common.UniModule
import kotlin.reflect.full.declaredMemberFunctions
import kotlin.reflect.jvm.javaMethod

class AgoraRtcChannelModule : UniModule() {
    companion object {
        var manager: RtcChannelManager? = null
            private set
    }

    private val manager = RtcChannelManager { methodName, data -> emit(methodName, data) }

    init {
        AgoraRtcChannelModule.manager = manager
    }

    private fun emit(methodName: String, data: Map<String, Any?>?) {
        mUniSDKInstance.fireGlobalEventCallback("${RtcEngineEventHandler.PREFIX}$methodName", data)
    }

    private fun engine(): RtcEngine? {
        return AgoraRtcEngineModule.manager?.engine
    }

    @UniJSMethod(uiThread = false)
    fun callMethod(params: JSONObject?, callback: UniJSCallback?) {
        params?.getString("method")?.let { methodName ->
            manager::class.declaredMemberFunctions.find { it.name == methodName }?.let { function ->
                function.javaMethod?.let { method ->
                    try {
                        val parameters = mutableListOf<Any?>()
                        params.getJSONObject("args")?.toMap()?.toMutableMap()?.let {
                            if (methodName == "create") {
                                it["engine"] = engine()
                            }
                            parameters.add(it)
                        }
                        method.invoke(manager, *parameters.toTypedArray(), UniCallback(callback))
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            }
        }
    }
}
