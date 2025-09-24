'''
DRF позволяет объединить логику для набора связанных представлений в одном классе, 
называемом ViewSet - это просто тип представления на основе класса, который не 
предоставляет никаких обработчиков методов, таких как .get() или .post(), а вместо 
этого предоставляет такие действия, как .list() и .create().

Обработчики методов для ViewSet привязываются к соответствующим действиям только 
в момент финализации представления с помощью метода .as_view().

Есть два основных преимущества использования класса ViewSet вместо класса View.
Повторяющаяся логика может быть объединена в один класс. В приведенном выше примере нам нужно указать queryset только один раз, и он будет использоваться в нескольких представлениях.
Используя маршрутизаторы, нам больше не нужно самим создавать URL conf.
'''
from django.contrib.auth.models import User
from django.shortcuts import get_objects_or_404
from .serializers import UserSerializer
from rest_framework import viewsets
from rest_framework.response import Response

class UserViewSet(viewsets.ViewSet):
    def list(self, request):
        queryset = User.objects.all()
        serializers = UserSerializer(queryset, many=True)
        return Response(serializers.data)

    def retrieve(self, request, pk=None):       'один объект'
        queryset = User.objects.all()
        user = get_objects_or_404(queryset, pk=pk)
        serializers = UserSerializer(user)
        return Response(serializers.data)

    def create(self, request):
        pass

    def update(self, request, pk=None):
        pass

    def partial_update(self, request, pk=None):     'обновить частично'
        pass

    def destroy(self, request, pk=None):
        pass


# basename - основа, используемая для имен создаваемых URL.
# action - имя текущего действия (например, list, create).
# detail - булево значение, указывающее, настроено ли текущее действие на просмотр списка или деталей.
# suffix - суффикс отображения для типа набора представлений - зеркально отражает атрибут detail.
# name - отображаемое имя набора представлений. Этот аргумент является взаимоисключающим для suffix.
# # description - отображаемое описание для отдельного вида набора представлений.
# Вы можете использовать эти атрибуты для настройки поведения в зависимости от текущего действия. Например, вы можете ограничить права на все действия, кроме действия list, следующим образом:
def get_permissions(self):
    if self.action == 'list':
        permission_classes = [IsAuthenticated]
    else:
        permission_classes = [IsAdminUser]
    return [permission() for permission in permission_classes]


