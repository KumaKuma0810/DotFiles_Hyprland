def safe_divide(a, b):
   
    
    try: 
        c = a / b
    except ZeroDivisionError:
        print('Деление на 0 запрещено ', None)        
    
    print(c)

safe_divide(10, 0)

