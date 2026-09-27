# Firebase (firebase_core, firebase_auth, cloud_firestore) and the
# underlying Google Play Services libraries they depend on.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Syncfusion (syncfusion_flutter_calendar, syncfusion_flutter_pdfviewer):
# recommended by Syncfusion's own R8/ProGuard documentation.
-keep class com.syncfusion.** { *; }
-dontwarn com.syncfusion.**

# flutter_quill's native bridge (quill_native_bridge_android).
-keep class dev.flutterquill.** { *; }
