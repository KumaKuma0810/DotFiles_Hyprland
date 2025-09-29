def safe_divide(a, b):    
    try: 
        c = a / b    
        print(c)
    except ZeroDivisionError:
        print('Деление на 0 запрещено ', None)        
safe_divide(10, 0)

