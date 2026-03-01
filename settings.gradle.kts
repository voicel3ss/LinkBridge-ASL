pluginManagement {
	val flutterSdkPath =
		run {
			val properties = java.util.Properties()
			val localPropsFile = if (file("local.properties").exists()) file("local.properties") else file("android/local.properties")
			localPropsFile.inputStream().use { properties.load(it) }
			val flutterSdkPath = properties.getProperty("flutter.sdk")
			require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
			flutterSdkPath
		}

	includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

	repositories {
		google()
		mavenCentral()
		gradlePluginPortal()
	}
}

plugins {
	id("dev.flutter.flutter-plugin-loader") version "1.0.0"
	id("com.android.application") version "8.11.1" apply false
	id("com.google.gms.google-services") version("4.4.2") apply false
	id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

rootProject.name = "ASL-app"
include(":app")
project(":app").projectDir = file("android/app")
