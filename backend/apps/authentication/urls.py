from django.urls import path
from . import views

app_name = 'authentication'

urlpatterns = [
    path('login/', views.UserLoginView.as_view(), name='login'),
    path('logout/', views.UserLogoutView.as_view(), name='logout'),
    path('profile/', views.UserProfileView.as_view(), name='profile'),
    path('profile/update/', views.UserProfileUpdateView.as_view(), name='profile-update'),
    path('password/change/', views.PasswordChangeView.as_view(), name='password-change'),
]

# Removed for personal project simplification:
# - register/ (no public registration)
# - password/reset/ (use Django admin)
# - password/reset/confirm/ (not needed)
# - email/verify/ (not needed)
# - token/refresh/ (using session auth) 