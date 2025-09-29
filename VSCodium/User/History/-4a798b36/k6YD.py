def even_number(number):
    for x in range(number):
        if x % 2 == 0:
            yield i 

gen = even_number(10)
print(list(gen))