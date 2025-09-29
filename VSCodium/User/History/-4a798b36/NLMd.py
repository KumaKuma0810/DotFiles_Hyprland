def even_numbers(n):
    for i in range(n):
        if i % 2 == 0:  # проверяем, чётное ли число
            yield i 

gen = even_numbers(10)
print(list(gen))  