words = ["apple", "banana", "apple", "orange", "banana", "kiwi"]

def count_words(lst):
    counts = {}
    for word in lst:
        if word in counts:
            counts[word] += 1
        else:
            counts[word] = 1
    return counts

word_count = count_words(words) 
print(word_count)
