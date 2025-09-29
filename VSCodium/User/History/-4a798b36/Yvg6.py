def even_squares(n):
    for num in n:
        if num % 2 == 0:
            yield num ** 2


gen = even_squares(10)
print(list(gen))