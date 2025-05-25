from django.db import models
from django.utils import timezone
import uuid

class BaseModel(models.Model):
    """
    Base model class that all other models should inherit from.
    Provides common fields and functionality.
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True
        ordering = ['-created_at']

    def soft_delete(self):
        """
        Instead of actually deleting the object, just update is_active to False.
        """
        self.is_active = False
        self.save()

    def restore(self):
        """
        Restore a soft-deleted object.
        """
        self.is_active = True
        self.save()

    @property
    def is_deleted(self):
        """
        Check if the object has been soft-deleted.
        """
        return not self.is_active 