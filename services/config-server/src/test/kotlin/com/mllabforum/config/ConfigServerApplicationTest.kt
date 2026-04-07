package com.mllabforum.config

import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles

@SpringBootTest
@ActiveProfiles("test")
class ConfigServerApplicationTest {

    @Test
    fun contextLoads() {
        // Контекст поднимается с тестовым профилем
    }
}
