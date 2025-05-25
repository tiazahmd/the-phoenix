from django.contrib.auth.models import AbstractUser
from django.db import models
from core.models import BaseModel
from django.utils.translation import gettext_lazy as _

class User(AbstractUser, BaseModel):
    """
    Custom user model that extends Django's AbstractUser and our BaseModel.
    """
    email = models.EmailField(_('email address'), unique=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    avatar = models.URLField(blank=True, null=True)
    bio = models.TextField(blank=True)
    date_of_birth = models.DateField(null=True, blank=True)
    timezone = models.CharField(max_length=50, default='UTC')
    notification_preferences = models.JSONField(default=dict)
    last_login_ip = models.GenericIPAddressField(null=True, blank=True)
    cognito_id = models.CharField(max_length=128, unique=True, null=True)
    
    # Use email as the username field
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']  # Email & password are required by default

    class Meta:
        verbose_name = _('user')
        verbose_name_plural = _('users')
        ordering = ['-date_joined']

    def __str__(self):
        return self.email

    def get_full_name(self):
        """
        Return the first_name plus the last_name, with a space in between.
        """
        full_name = f"{self.first_name} {self.last_name}"
        return full_name.strip()

    def get_short_name(self):
        """Return the short name for the user."""
        return self.first_name

    @property
    def is_complete(self):
        """Check if the user profile is complete."""
        required_fields = [
            self.first_name,
            self.last_name,
            self.phone_number,
            self.date_of_birth
        ]
        return all(required_fields)

class UserProfile(BaseModel):
    """
    Extended profile information for users.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    progress_points = models.IntegerField(default=0)
    streak_count = models.IntegerField(default=0)
    last_checkin = models.DateTimeField(null=True, blank=True)
    completed_exercises = models.IntegerField(default=0)
    completed_quizzes = models.IntegerField(default=0)
    badges = models.JSONField(default=list)
    preferences = models.JSONField(default=dict)
    goals = models.JSONField(default=list)
    achievements = models.JSONField(default=list)

    def __str__(self):
        return f"Profile for {self.user.email}"

    def update_streak(self):
        """Update the user's streak count."""
        from django.utils import timezone
        now = timezone.now()
        
        if not self.last_checkin:
            self.streak_count = 1
        else:
            time_diff = now - self.last_checkin
            if time_diff.days == 1:
                self.streak_count += 1
            elif time_diff.days > 1:
                self.streak_count = 1
        
        self.last_checkin = now
        self.save()

    def add_badge(self, badge_data):
        """Add a new badge to the user's collection."""
        if not isinstance(self.badges, list):
            self.badges = []
        
        self.badges.append({
            'id': badge_data['id'],
            'name': badge_data['name'],
            'description': badge_data['description'],
            'awarded_at': timezone.now().isoformat()
        })
        self.save()

    def add_achievement(self, achievement_data):
        """Add a new achievement to the user's collection."""
        if not isinstance(self.achievements, list):
            self.achievements = []
        
        self.achievements.append({
            'id': achievement_data['id'],
            'name': achievement_data['name'],
            'description': achievement_data['description'],
            'awarded_at': timezone.now().isoformat()
        })
        self.save() 