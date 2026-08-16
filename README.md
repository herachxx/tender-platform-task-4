# tender-platform-task-4

PostgreSQL schema and analytics for a tender monitoring platform.



\## Что сделано



\- 5 таблиц: компании, тендеры, лоты, исполнители и ставки;

\- связи между данными и защита от неправильных значений;

\- ускоренный поиск нужных данных;

\- тестовые данные;

\- 2 отчёта:

&#x20; - минимальные ставки по активным лотам;

&#x20; - рейтинг исполнителей;

\- запуск PostgreSQL через Docker.



\## Быстрый запуск



docker compose up -d



docker compose exec postgres psql -U tender\_app -d tender\_lab -c "\\dt"



docker compose exec -T postgres psql -U tender\_app -d tender\_lab < db\\queries\\01\_analytics.sql



docker compose exec -T postgres psql -U tender\_app -d tender\_lab < db\\queries\\02\_executor\_performance.sql



\## Структура проекта



db/init/                 создание таблиц и тестовые данные

db/queries/              SQL-отчёты

docs/solution.md         простое объяснение решения

compose.yml              запуск PostgreSQL через Docker

LICENSE                  MIT-лицензия

