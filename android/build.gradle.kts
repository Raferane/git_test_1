allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Fix for cloud_firestore compileSdkVersion issue
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                compileSdk = 34
                defaultConfig {
                    minSdk = 21
                    targetSdk = 34
                }
            }
        }
    }
    
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
