package io.agora.rtc.base

import android.content.Context
import android.view.TextureView
import android.widget.FrameLayout
import io.agora.rtc.RtcChannel
import io.agora.rtc.RtcEngine
import io.agora.rtc.video.VideoCanvas
import java.lang.ref.WeakReference

class RtcTextureView(
  context: Context
) : FrameLayout(context) {
  private var texture: TextureView
  private var canvas: VideoCanvas? = null
  private var channel: WeakReference<RtcChannel>? = null

  init {
    try {
      texture = RtcEngine.CreateTextureView(context)
    } catch (e: UnsatisfiedLinkError) {
      throw RuntimeException("Please init RtcEngine first!")
    }
    addView(texture)
  }

  fun setData(engine: RtcEngine, channel: RtcChannel?, uid: Number) {
    this.channel = if (channel != null) WeakReference(channel) else null
    canvas = canvas ?: VideoCanvas(texture)
    canvas?.channelId = this.channel?.get()?.channelId()
    canvas?.uid = uid.toNativeUInt()
    setupVideoCanvas(engine)
  }

  fun resetVideoCanvas(engine: RtcEngine) {
    canvas?.let {
      val canvas =
        VideoCanvas(null, it.renderMode, it.channelId, it.uid, it.mirrorMode)
      if (canvas.uid == 0) {
        engine.setupLocalVideo(canvas)
      } else {
        engine.setupRemoteVideo(canvas)
      }
    }
  }

  private fun setupVideoCanvas(engine: RtcEngine) {
    removeAllViews()
    texture = RtcEngine.CreateTextureView(context.applicationContext)
    addView(texture)
    texture.layout(0, 0, width, height)
    canvas?.let { canvas ->
      canvas.view = texture
      if (canvas.uid == 0) {
        engine.setupLocalVideo(canvas)
      } else {
        engine.setupRemoteVideo(canvas)
      }
    }
  }

  fun setRenderMode(engine: RtcEngine, @Annotations.AgoraVideoRenderMode renderMode: Int) {
    canvas?.renderMode = renderMode
    setupRenderMode(engine)
  }

  fun setMirrorMode(engine: RtcEngine, @Annotations.AgoraVideoMirrorMode mirrorMode: Int) {
    canvas?.mirrorMode = mirrorMode
    setupRenderMode(engine)
  }

  private fun setupRenderMode(engine: RtcEngine) {
    canvas?.let { canvas ->
      if (canvas.uid == 0) {
        engine.setLocalRenderMode(canvas.renderMode, canvas.mirrorMode)
      } else {
        channel?.get()?.let {
          it.setRemoteRenderMode(canvas.uid, canvas.renderMode, canvas.mirrorMode)
          return@setupRenderMode
        }
        engine.setRemoteRenderMode(canvas.uid, canvas.renderMode, canvas.mirrorMode)
      }
    }
  }

  override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    val width: Int = MeasureSpec.getSize(widthMeasureSpec)
    val height: Int = MeasureSpec.getSize(heightMeasureSpec)
    texture.layout(0, 0, width, height)
    super.onMeasure(widthMeasureSpec, heightMeasureSpec)
  }
}
