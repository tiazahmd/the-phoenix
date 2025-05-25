from rest_framework import generics, status, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import get_user_model, login, logout
from django.core.exceptions import ObjectDoesNotExist
from .serializers import (
    UserSerializer,
    PasswordChangeSerializer,
)

User = get_user_model()

class UserLoginView(APIView):
    """
    Simple login for personal use.
    """
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response({"error": "Username and password required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(username=username)
        except ObjectDoesNotExist:
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        if not user.check_password(password):
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        if not user.is_active:
            return Response({"error": "User account is disabled"}, status=status.HTTP_401_UNAUTHORIZED)

        login(request, user)
        
        return Response({
            "user": UserSerializer(user).data,
            "message": "Login successful"
        })

class UserLogoutView(APIView):
    """
    Logout user.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        logout(request)
        return Response({"message": "Logout successful"})

class UserProfileView(generics.RetrieveAPIView):
    """
    Retrieve user profile.
    """
    permission_classes = (permissions.IsAuthenticated,)
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user

class UserProfileUpdateView(generics.UpdateAPIView):
    """
    Update user profile.
    """
    permission_classes = (permissions.IsAuthenticated,)
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user

    def update(self, request, *args, **kwargs):
        user = self.get_object()
        serializer = self.get_serializer(user, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PasswordChangeView(APIView):
    """
    Change user password.
    """
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        serializer = PasswordChangeSerializer(data=request.data)
        if serializer.is_valid():
            user = request.user
            if not user.check_password(serializer.validated_data['old_password']):
                return Response({"error": "Wrong password"}, status=status.HTTP_400_BAD_REQUEST)
            
            user.set_password(serializer.validated_data['new_password'])
            user.save()
            return Response({"message": "Password updated successfully"})
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Removed for personal project simplification:
# - UserRegistrationView (no public registration needed)
# - PasswordResetView (admin can reset via Django admin)
# - PasswordResetConfirmView (not needed)
# - EmailVerificationView (not needed)
# - TokenRefreshView (using session auth instead) 