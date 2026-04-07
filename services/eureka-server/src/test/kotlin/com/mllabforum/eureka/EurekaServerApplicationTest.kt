package com.mllabforum.eureka

import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.server.LocalServerPort
import org.springframework.web.client.RestTemplate
import org.assertj.core.api.Assertions.assertThat

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class EurekaServerApplicationTest {

    @LocalServerPort
    private lateinit var port: String

    private val restTemplate = RestTemplate()

    @Test
    fun contextLoads() {
        // Проверка, что контекст поднимается
    }

    @Test
    fun eurekaDashboardShouldBeAccessible() {
        val url = "http://localhost:$port/"
        val response = restTemplate.getForEntity(url, String::class.java)
        assertThat(response.statusCode.is2xxSuccessful).isTrue()
        assertThat(response.body).contains("Eureka")
    }

    @Test
    fun healthEndpointShouldReturnUp() {
        val url = "http://localhost:$port/actuator/health"
        val response = restTemplate.getForEntity(url, String::class.java)
        assertThat(response.statusCode.is2xxSuccessful).isTrue()
        assertThat(response.body).contains("\"status\":\"UP\"")
    }
}
