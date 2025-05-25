# Phoenix Backend

The Django-based backend for the Phoenix Project.

## Setup

1. Create and activate virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Set up environment variables:
- Copy `.env.development` for development
- Copy `.env.test` for testing
- Copy `.env.production` for production

4. Create PostgreSQL databases:
```bash
createdb phoenix_dev
createdb phoenix_test
```

5. Run migrations:
```bash
python manage.py migrate
```

6. Create superuser:
```bash
python manage.py createsuperuser
```

7. Run development server:
```bash
python manage.py runserver
```

## Project Structure

```
backend/
├── apps/                    # Django applications
│   ├── authentication/      # User authentication
│   ├── checkins/           # Daily check-ins
│   ├── quizzes/            # Quiz functionality
│   ├── exercises/          # Exercise tracking
│   ├── simulations/        # Simulation exercises
│   ├── dashboard/          # User dashboard
│   ├── tips/               # Daily tips
│   └── reflections/        # User reflections
├── core/                   # Core functionality
│   ├── ai/                # AI integration
│   ├── websockets/        # WebSocket handlers
│   ├── analytics/         # Analytics tracking
│   └── notifications/     # Notification system
├── config/                # Project configuration
│   ├── settings/         # Settings modules
│   │   ├── base.py      # Base settings
│   │   ├── development.py
│   │   ├── test.py
│   │   └── production.py
│   ├── urls.py          # URL configuration
│   ├── wsgi.py         # WSGI configuration
│   └── asgi.py        # ASGI configuration
└── tests/              # Test suite
```

## Testing

Run tests with pytest:
```bash
pytest
```

Generate coverage report:
```bash
pytest --cov
```

## API Documentation

- Swagger UI: http://localhost:8000/swagger/
- ReDoc: http://localhost:8000/redoc/

## WebSocket Endpoints

- Notifications: `ws://localhost:8000/ws/notifications/`
- Chat: `ws://localhost:8000/ws/chat/{room_name}/`

## Celery Tasks

Start Celery worker:
```bash
celery -A config worker -l info
```

## Development Guidelines

1. Follow PEP 8 style guide
2. Write tests for new features
3. Update API documentation
4. Use type hints
5. Keep functions focused and small
6. Document complex logic
7. Use meaningful variable names
8. Handle errors gracefully

## Security

- All endpoints require authentication
- CORS is configured for frontend domain
- SSL/TLS required in production
- Sensitive data is encrypted
- Rate limiting is enabled
- Input validation on all endpoints

## Deployment

1. Set production environment variables
2. Collect static files:
```bash
python manage.py collectstatic
```

3. Run migrations:
```bash
python manage.py migrate
```

4. Start Gunicorn:
```bash
gunicorn config.wsgi:application
```

5. Configure Nginx/Apache

## Monitoring

- Sentry for error tracking
- Custom analytics
- Performance monitoring
- User activity tracking
- System health checks 