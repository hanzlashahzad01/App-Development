plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.csdepartment.smart_complaint_system"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    android {
        // ...baqi settings...
        android {
            // ...baqi settings...
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_11
                targetCompatibility = JavaVersion.VERSION_11
                isCoreLibraryDesugaringEnabled = true
            }
            kotlinOptions {
                jvmTarget = "11"
            }
            ndkVersion = "27.0.12077973"
        }
    }

    dependencies {
        // ...baqi dependencies...
        dependencies {
            // ...baqi dependencies...
            coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
        }
    }



    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.csdepartment.smart_complaint_system"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
