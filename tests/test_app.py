import os
import unittest
from unittest.mock import patch
from app import app


class AppTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_home(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn('API funcionando', response.get_data(as_text=True))

    def test_health_version(self):
        with patch.dict(os.environ, {'APP_VERSION': 'prueba-123'}):
            response = self.client.get('/health')
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.json, {'status': 'ok', 'version': 'prueba-123'})

    def test_unknown_route(self):
        self.assertEqual(self.client.get('/no-existe').status_code, 404)
