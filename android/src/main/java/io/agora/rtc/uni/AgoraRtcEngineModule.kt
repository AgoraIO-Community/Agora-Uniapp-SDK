package io.agora.rtc.uni

import com.alibaba.fastjson.JSONObject
import io.agora.rtc.base.RtcEngineEventHandler
import io.agora.rtc.base.RtcEngineManager
import io.dcloud.feature.uniapp.annotation.UniJSMethod
import io.dcloud.feature.uniapp.bridge.UniJSCallback
import io.dcloud.feature.uniapp.common.UniModule

class AgoraRtcEngineModule : UniModule() {
    companion object {
        var manager: RtcEngineManager? = null
            private set
    }

    private val manager = RtcEngineManager { methodName, data -> emit(methodName, data) }

    init {
        AgoraRtcEngineModule.manager = manager
    }

    private fun emit(methodName: String, data: Map<String, Any?>?) {
        mUniSDKInstance.fireGlobalEventCallback("${RtcEngineEventHandler.PREFIX}$methodName", data)
    }

    @UniJSMethod(uiThread = false)
    fun callMethod(params: JSONObject, callback: UniJSCallback?) {
        params.getString("method")?.let { methodName ->
            manager.javaClass.declaredMethods.find { it.name == methodName }?.let { function ->
                function.let { method ->
                    try {
                        val parameters = mutableListOf<Any?>()
                        params.getJSONObject("args")?.toMap()?.toMutableMap()?.let {
                            if (methodName == "create") {
                                it["context"] = mUniSDKInstance.context.applicationContext
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
