# MLLabForum

MLLabForum — платформа для ML/AI сообщества, объединяющая форум, соревнования, публикацию и тестирование моделей.

---

## Быстрый старт

```bash
git clone https://github.com/BuStarley/MLLabForum.git
cd MLLabForum
cp .env.example .env
docker-compose -f docker-compose/docker-compose.yml up -d
```

## Доступ после запуска:

| Сервис | URL | Логин/пароль |
|--------|-----|--------------|
| MinIO Console | http://localhost:9001 | minioadmin / minioadmin |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:3000 | admin / admin |
| Jaeger | http://localhost:16686 | - |
| MailHog | http://localhost:8025 | - (web интерфейс для писем) |

