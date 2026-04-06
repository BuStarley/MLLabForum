# Архитектура MLLabForum

## 1. Обзор

**Архитектурный стиль:** Микросервисный

**Статус:** Alpha — инфраструктурный прототип (только базы и очереди)

---

## 2. Бизнес-сервисы

| Сервис | Порт | Язык | БД | Redis | MinIO | Ответственность | Прогресс |
|--------|------|------|-----|-------|-------|-----------------|----------|
| **Auth Service** | 8081 | Kotlin | auth-db | auth-redis | - | Регистрация, логин, JWT, 2FA (код на почту), брутфорс, blacklist | 0% |
| **Profile Service** | 8082 | Kotlin | profile-db | profile-redis | avatars | Профили, аватарки, навыки, интересы | 0% |
| **Post Service** | 8083 | Kotlin | post-db | post-redis | - | Посты, комментарии, голосования | 0% |
| **ML Service** | 8084 | Python | ml-db | ml-redis | models | ML-модерация, инференс моделей | 0% |
| **Analytics Service** | 8085 | Kotlin | analytics-db | - | - | DAU, MAU, retention, метрики | 0% |
| **Notification Service** | 8086 | Kotlin | notify-db | notify-redis | - | Email уведомления, 2FA коды | 0% |
| **Model Registry** | 8087 | Kotlin | registry-db | - | models | Хостинг моделей, версионирование | 0% |

---

## 3. Инфраструктурные сервисы

| Сервис | Порт | Назначение |
|--------|------|------------|
| **Config Server** | 8888 | Централизованные конфиги |
| **Eureka Server** | 8761 | Service Discovery |
| **API Gateway** | 8080 | Маршрутизация, JWT validation, агрегация |
| **NGINX** | 80/443 | SSL, rate limiting, статика |

---

## 4. Базы данных (SQL)

| Инстанс | Тип | Порт | Назначение |
|---------|-----|------|------------|
| auth-db | PostgreSQL | 5433 | Пользователи (email, пароль, 2FA включён), refresh токены, попытки входа |
| profile-db | PostgreSQL | 5434 | Профили, навыки, интересы |
| post-db | PostgreSQL | 5435 | Посты, комментарии, голосования |
| analytics-db | PostgreSQL | 5436 | DAU, MAU, активность |
| ml-db | PostgreSQL | 5437 | Модели, инференсы, логи модерации |
| notify-db | PostgreSQL | 5438 | Уведомления, email логи, 2FA коды |
| registry-db | PostgreSQL | 5439 | Версии моделей, статистика скачиваний |

---

## 5. Кэш и состояния (NoSQL)

| Инстанс | Тип | Порт | Назначение |
|---------|-----|------|------------|
| auth-redis | Redis | 6379 | JWT blacklist, брутфорс счётчики, 2FA сессии (TTL 5 мин) |
| profile-redis | Redis | 6381 | Кэш профилей |
| post-redis | Redis | 6382 | Кэш постов и комментариев |
| ml-redis | Redis | 6383 | Кэш загруженных моделей |
| notify-redis | Redis | 6384 | Очередь уведомлений, 2FA коды (временное хранение) |

---

## 6. Хранилище (MinIO)

| Bucket | Сервис | Назначение |
|--------|--------|------------|
| avatars | Profile | Аватарки пользователей |
| models | Model Registry | ML-модели |

---

## 7. Мониторинг

| Сервис | Порт | Назначение |
|--------|------|------------|
| Prometheus | 9090 | Сбор метрик |
| Grafana | 3000 | Визуализация |
| Loki | 3100 | Логи |
| Jaeger | 16686 | Трассировка |