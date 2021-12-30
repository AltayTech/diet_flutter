-keep class androidx.lifecycle.DefaultLifecycleObserver
##------------------------------ Begin: Gson ------------------------------
# Gson specific classes
-keep class sun.misc.Unsafe { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers enum * {*;}
# For using GSON @Expose annotation
-keepattributes *Annotation*

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
##------------------------------ End: Gson ------------------------------

#################################################################################################
################################ OkHttp rules ###################################################
#################################################################################################
# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**

# A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
-keepnames class okhttp3.** { *; }

# Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

# OkHttp platform used only on JVM and when Conscrypt dependency is available.
-dontwarn okhttp3.internal.platform.ConscryptPlatform
#################################################################################################
################################ End of OkHttp rules ############################################
#################################################################################################
-keep class me.carda.awesome_notifications.** {*;}
-keepnames class me.carda.awesome_notifications.** {*;}
-keepclassmembers class me.carda.awesome_notifications.** {*;}

-keepattributes LineNumberTable,SourceFile
-keep class io.flutter.app.** { *; }
# -keep class io.flutter.plugin.**  { *; }
# -keep class io.flutter.util.**  { *; }
# -keep class io.flutter.view.**  { *; }
# -keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
# -dontwarn io.flutter.embedding.**
# -ignorewarnings