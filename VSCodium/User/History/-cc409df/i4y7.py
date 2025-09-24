from rest_framework import viewsets, permissions
from .models import Category 
from transactions.serializers import CategorySerializers 

class CategoryViewSet(viewset.ModelViewSet):
    queryset = Category.objects.all()
    serializers_class = CategorySerilizer 
    permissions_classes = [permissions.IsAuthenticated]
