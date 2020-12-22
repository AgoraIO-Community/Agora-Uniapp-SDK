-keepattributes *Annotation*
-keep class kotlin.** { *; }
-keep class org.jetbrains.** { *; }

-keep class io.agora.**{*;}

-keep public class * extends io.dcloud.feature.uniapp.common.UniModule{*;}
-keep public class * extends io.dcloud.feature.uniapp.ui.component.UniComponent{*;}
