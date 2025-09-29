def safe_divide(a, b):
    if b == 0: 
        print('Деление на 0 запрещено ', None)
    
    c = a / b
    print(c)

safe_divide(10, 0)

