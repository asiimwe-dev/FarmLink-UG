plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.farmcom.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.farmcom.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Post-build task to copy APK to Flutter's expected location
tasks.register("copyDebugApk") {
    doLast {
        val sourceDir = File("${project.buildDir}/outputs/apk/debug")
        // Navigate up from android/app/build to frontend/build
        val destDir = File("${project.rootProject.projectDir}/../build/app/outputs/flutter-apk")
        
        if (sourceDir.exists()) {
            destDir.mkdirs()
            sourceDir.listFiles()?.filter { it.name.endsWith(".apk") }?.forEach { apk ->
                val destFile = File(destDir, "app-debug.apk")
                apk.copyTo(destFile, overwrite = true)
                println("Copied ${apk.name} to ${destFile.absolutePath}")
            }
        } else {
            println("Source dir does not exist: ${sourceDir.absolutePath}")
        }
    }
}

// Attach the copy task to assembleDebug
afterEvaluate {
    tasks.named("assembleDebug") {
        finalizedBy("copyDebugApk")
    }
}

