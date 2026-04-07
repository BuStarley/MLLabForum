plugins {
    id("org.springframework.boot") version "4.0.5" apply false
    id("io.spring.dependency-management") version "1.1.7" apply false
    kotlin("jvm") version "2.3.0" apply false
    kotlin("plugin.spring") version "2.3.0" apply false
    kotlin("plugin.jpa") version "2.3.0" apply false
    id("org.jetbrains.dokka") version "2.2.0" apply false
    id("com.google.cloud.tools.jib") version "3.5.3" apply false
}

group = "com.mllabforum"
version = "0.3.0-alpha"