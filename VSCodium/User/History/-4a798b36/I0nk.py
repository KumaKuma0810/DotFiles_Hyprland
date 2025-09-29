def even_number(number):
    for x in range(number):
        yield x % 2

gen = even_number(10)
print(list(gen))