import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.infoquiz"
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
        applicationId = "com.example.infoquiz"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
// 🔐 Chargement du fichier key.properties uniquement pour les builds release
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

signingConfigs {
    // Crée la configuration uniquement si on est en release et que tout est bien défini
    create("release") {
        val storeFilePath = keystoreProperties["storeFile"]?.toString()
        val storePasswordValue = keystoreProperties["storePassword"]?.toString()
        val keyAliasValue = keystoreProperties["keyAlias"]?.toString()
        val keyPasswordValue = keystoreProperties["keyPassword"]?.toString()

        // Applique uniquement si toutes les valeurs sont présentes
        if (
            storeFilePath != null &&
            storePasswordValue != null &&
            keyAliasValue != null &&
            keyPasswordValue != null
        ) {
            storeFile = file(storeFilePath)
            storePassword = storePasswordValue
            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
        }
    }
}

buildTypes {
    getByName("release") {
        // Appliquer la signature que si elle est bien définie
        if (signingConfigs.findByName("release") != null) {
            signingConfig = signingConfigs.getByName("release")
        }
        isMinifyEnabled = false
        isShrinkResources = false
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
}
}
