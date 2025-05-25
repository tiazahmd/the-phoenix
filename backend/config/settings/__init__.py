# Django settings module
from .base import *

import os

environment = os.getenv('DJANGO_ENV', 'development')

if environment == 'production':
    from .production import *
elif environment == 'test':
    from .test import *
else:
    from .development import * 