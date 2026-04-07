# Changelog

## [0.3.0-aplha] - platform-1 - 2026-04-07

### Добавлено
- **Platform Kotlin** с современным стеком:
  - Spring Boot 4.0.5, Kotlin 2.3.0, Java 25
  - Gradle 9.6 с configuration cache
  - Type-safe project accessors
  - pluginManagement с правильными репозиториями
- Базовая структура для Kotlin-сервисов
- Gradle wrapper для унифицированной сборки


## [0.2.0-alpha] - Infrastructure-2 - 2026-04-07

### Добавлено
- GitHub Actions CI/CD пайплайн (`.github/workflows/ci.yml`)
- Скрипт тестирования инфраструктуры (`scripts/test/test-infra.sh`)
- Автоматическая проверка при push в main и pull request'ах:
    - Валидность docker-compose файлов
    - Запуск всех контейнеров
    - Доступность портов
    - HTTP endpoints

### Исправлено
- NGINX теперь возвращает заглушку (временное решение до API Gateway)
- Добавлен healthcheck для NGINX

---

## [0.1.0-alpha] - Infrastructure-1 - 2026-04-06

### Добавлено
- 7 PostgreSQL баз данных (auth, profile, post, analytics, ml, notify, registry)
- 5 Redis инстансов (auth, profile, post, ml, notify)
- Kafka + Zookeeper
- MinIO
- Prometheus + Grafana + Loki + Jaeger
- NGINX + MailHog
- Docker Compose с разделением на модули
- Скрипты: start.sh, stop.sh, status.sh
- Документация: README.md, architecture.md