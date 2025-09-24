# Маршрутизаторы

# router — это автоматический генератор URL-ов для ViewSet

# DRF добавляет в Django поддержку автоматической маршрутизации URL и предоставляет
# вам простой, быстрый и последовательный способ подключения логики представления 
# к набору URL.

# DefaultRouter
# Автоматически генерирует все стандартные маршруты.
# Плюс создаёт удобную "корневую точку" API (root view).


from rest_framework.routers import DefaultRouter
from .views import PostViewSet

router = DefaultRouter()
router.register(r'posts', PostViewSet, basemane='post')

urlpatterns = router.urls

# SimpleRouter
# Делает то же самое, но без root view.
# Используется, если тебе не нужна лишняя "главная страница API".
from rest_framework.routers import SimpleRouter

router = SimpleRouter()
router.register(r"posts", PostViewSet, basename="post")


# !!! Когда ты регистрируешь viewset, указываешь basename.
# Если у viewset есть queryset, DRF сам придумает basename.
# Если queryset нет — basename обязателен, иначе router не сможет построить пути.

# Если в viewset-е есть @action, router тоже создаст для него путь:
class PostSerializertViewSet(viewset.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    @action(detail=True, methods=['post'])
    def like(self, request, pk=None):
        post = self.get_object()
        post.likes +=1
        post.save()
        return Response({'status': 'liked'})

    