plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase 설정
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
}

android {
    namespace = "com.example.project_medi"
    compileSdk = 34 // 명시적으로 지정 권장 (flutter.compileSdkVersion도 가능)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // ✅ Desugaring 활성화
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.project_medi"
        minSdk = 23 // 알람 권한을 위해 최소 23 이상 필요
        targetSdk = 34 // 명시적으로 지정 권장 (flutter.targetSdkVersion도 가능)
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Desugaring 라이브러리 추가
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // ✅ FlutterLocalNotifications 플러그인에 따라 필요한 경우 추가 가능
    implementation("androidx.core:core:1.12.0") // 최신 Core 라이브러리로 충돌 방지
}
