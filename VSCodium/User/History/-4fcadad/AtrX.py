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


ViewSet
Класс ViewSet наследуется от APIView. Вы можете использовать любые стандартные 
атрибуты, такие как permission_classes, authentication_classes, чтобы управлять 
политикой API для набора представлений.

Класс ViewSet не предоставляет никаких реализаций действий. Чтобы использовать 
класс ViewSet, вам нужно переопределить его и явно определить реализацию действий.
GenericViewSet
Класс GenericViewSet наследуется от GenericAPIView и предоставляет стандартный 
набор методов get_object, get_queryset и другие базовые поведения общих 
представлений, но по умолчанию не включает никаких действий.
Чтобы использовать класс GenericViewSet, вы должны переопределить его и либо 
смешать необходимые классы mixin, либо явно определить реализацию действий.

ModelViewSet
Класс ModelViewSet наследуется от GenericAPIView и включает в себя реализации 
различных действий, смешивая поведение различных классов-миксинов.
Класс ModelViewSet предоставляет следующие действия: .list(), .retrieve(), 
.create(), .update(), .partial_update() и .destroy().

ReadOnlyModelViewSet

Класс ReadOnlyModelViewSet также наследуется от GenericAPIView. Как и ModelViewSet,
он также включает реализации различных действий, но в отличие от ModelViewSet
предоставляет только действия "только для чтения", .list() и .retrieve().
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

    def retrieve(self, request, pk=None):       #один объект
        queryset = User.objects.all()
        user = get_objects_or_404(queryset, pk=pk)
        serializers = UserSerializer(user)
        return Response(serializers.data)

    def create(self, request):
        pass

    def update(self, request, pk=None):
        pass

    def partial_update(self, request, pk=None):     #обновить частично
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


class PostViewSet(viewsets.ModelViewSet):   # наследуется от GenericAPIView
    queryset = Post.objects.all()        # набор объектов
    serializer_class = PostSerializer    # сериализатор
    permission_classes = [IsAuthenticated]  # права доступа
    authentication_classes = [SessionAuthentication]  # способы аутентификации
    throttle_classes = [UserRateThrottle]  # ограничение по запросам
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]  # фильтрация
    search_fields = ["title", "content"]  # поиск
    ordering_fields = ["created_at", "likes"]  # сортировка
    pagination_class = PageNumberPagination  # пагинация


# @action — можно добавлять свои эндпоинты:
from rest_framework.decorators import action
from rest_framework.response import Response

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    @action(detail=True, methods=["post"])
    def like(self, request, pk=None):
        post = self.get_object()
        post.likes += 1
        post.save()
        return Response({"status": "liked"})












class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height= height

    def area():
        print(self.width * self.height)

    def perimeter():
        self.width = self.width * 2
        self.height = self.height * 2
        print(self.width + self.height)


r1 = Rectangle(5, 3)
r1.area()
r1.height()