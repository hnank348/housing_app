// 1. تعريف المستودعات التي سيتم تحميل المكتبات منها
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 2. إضافة الـ Buildscript لتعريف مكتبة Google Services
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // هذا السطر ضروري جداً لربط Firebase بالأندرويد
        classpath("com.google.gms:google-services:4.3.15")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}