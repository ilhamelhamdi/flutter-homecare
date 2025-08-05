# Google Sign-In
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# WeChat SDK
-keep class com.tencent.mm.opensdk.** { *; }
-keep class com.tencent.wxop.** { *; }
-keep class com.tencent.mm.sdk.** { *; }
-dontwarn com.tencent.mm.**

# Fluwx plugin
-keep class com.jarvan.fluwx.** { *; }
-dontwarn com.jarvan.fluwx.**

# Google Auth
-keep class com.google.api.client.** { *; }
-keep class com.google.auth.** { *; }
-dontwarn com.google.api.client.**
-dontwarn com.google.auth.**

# Retrofit and OkHttp (if used by social auth)
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-dontwarn retrofit2.**
-dontwarn okhttp3.**

# Gson (if used for JSON parsing)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep all model classes used for SSO
-keep class * implements java.io.Serializable { *; }
