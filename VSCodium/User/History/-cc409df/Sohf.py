from rest_framework import viewsets, permissions
from .models import Category 
from transactions.serializers import CategorySerializers 

class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializers_class = CategorySerializers
    permissions_classes = [permissions.IsAuthenticated]
