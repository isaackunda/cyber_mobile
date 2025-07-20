plugins {
    id("com.android.application") // Dernière version stable connue de l'AGP
    id("org.jetbrains.kotlin.android") version "2.1.21" // Dernière version stable connue de Kotlin
    // Le Flutter Gradle Plugin est souvent géré par Flutter lui-même.
    // Vous n'avez généralement pas besoin de spécifier la version ici,
    // car Flutter la gère via son SDK.
    // Cependant, si vous rencontrez des problèmes, vous pourriez avoir besoin de le spécifier.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ambachic.cyber_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ambachic.cyber_mobile"
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
