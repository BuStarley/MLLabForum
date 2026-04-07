rootProject.name = "kotlin-platform"

pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
        maven { url = uri("https://repo.spring.io/milestone") }
        maven { url = uri("https://repo.spring.io/snapshot") }
    }
}

enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")
enableFeaturePreview("STABLE_CONFIGURATION_CACHE")

// Сервисы
include(":eureka-server")
project(":eureka-server").projectDir = file("../../services/eureka-server")

include(":config-server")
project(":config-server").projectDir = file("../../services/config-server")