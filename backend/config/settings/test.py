from .base import *
import dj_database_url
import os

DEBUG = True

# Override SECRET_KEY for testing
SECRET_KEY = os.getenv('SECRET_KEY', 'test-secret-key-for-ci-testing-only-not-for-production')

ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# Database - use DATABASE_URL if available, otherwise default
if 'DATABASE_URL' in os.environ:
    DATABASES = {
        'default': dj_database_url.parse(os.environ['DATABASE_URL'])
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'phoenix_test',
            'USER': 'postgres',
            'PASSWORD': 'postgres',
            'HOST': 'localhost',
            'PORT': '5432',
        }
    }

# Use fast password hasher for testing
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.MD5PasswordHasher',
]

# Disable migrations for tests (commented out for CI)
# class DisableMigrations:
#     def __contains__(self, item):
#         return True

#     def __getitem__(self, item):
#         return None

# MIGRATION_MODULES = DisableMigrations()

# Email backend for testing
EMAIL_BACKEND = 'django.core.mail.backends.locmem.EmailBackend'

# Celery settings for testing
CELERY_TASK_ALWAYS_EAGER = True
CELERY_TASK_EAGER_PROPAGATES = True 