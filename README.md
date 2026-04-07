# MLLabForum

MLLabForum — платформа для ML/AI сообщества, объединяющая форум, соревнования, публикацию и тестирование моделей.

---

## Быстрый старт

```bash
git clone https://github.com/BuStarley/MLLabForum.git
cd MLLabForum
cp .env.example .env
./scripts/start.sh
```

## Доступ после запуска:

| Сервис         | URL                    | Логин/пароль |
|----------------|------------------------|--------------|
| Eureka Server	 | http://localhost:8761  | 	-                     |
| Config Server	 | http://localhost:8888  | 	-                     |
| MinIO Console  | http://localhost:9001  | minioadmin / minioadmin |
| Prometheus     | http://localhost:9090  | - |
| Grafana        | http://localhost:3000  | admin / admin |
| Jaeger         | http://localhost:16686 | - |
| MailHog        | http://localhost:8025  | - (web интерфейс для писем) |
| NGINX          | http://localhost       | - (заглушка "Infrastructure is running") |

## Скрипты управления

|Скрипт| 	Назначение                |
|-|----------------------------|
|./scripts/start.sh	| Запуск всей инфраструктуры |
|./scripts/stop.sh	| Остановка всех сервисов    |
|./scripts/status.sh|	Показать статус и healthcheck|
|./scripts/test/test-infra.sh|	Полное тестирование инфраструктуры|

## CI/CD (GitHub Actions)

Автоматический пайплайн запускается при push в main и pull request'ах:

