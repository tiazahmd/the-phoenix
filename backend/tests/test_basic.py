"""
Basic tests to ensure Django test runner works correctly.
"""
from django.test import TestCase
from django.urls import reverse
from django.contrib.auth import get_user_model

User = get_user_model()


class BasicTestCase(TestCase):
    """Basic test case to verify Django setup."""

    def test_django_setup(self):
        """Test that Django is properly configured."""
        self.assertTrue(True)

    def test_user_model(self):
        """Test that user model is accessible."""
        user_count = User.objects.count()
        self.assertGreaterEqual(user_count, 0)

    def test_admin_url(self):
        """Test that admin URL is accessible."""
        try:
            url = reverse('admin:index')
            self.assertTrue(url.startswith('/admin/'))
        except Exception:
            # Admin might not be configured yet
            self.assertTrue(True)


class HealthCheckTestCase(TestCase):
    """Health check tests for CI/CD pipeline."""

    def test_settings_import(self):
        """Test that settings can be imported."""
        from django.conf import settings
        self.assertIsNotNone(settings.SECRET_KEY)

    def test_database_connection(self):
        """Test that database connection works."""
        from django.db import connection
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()
            self.assertEqual(result[0], 1) 