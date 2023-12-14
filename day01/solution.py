import re

FIRST_NUMBER = re.compile('(\d)')
LAST_NUMBER = re.compile('(\d)[^\d]*$')

with open("input.txt") as f:
    lines = f.read().strip().split('\n')

numbers = [
    # string concat in python uses + operator
    re.search(FIRST_NUMBER, line).group(1) + re.search(LAST_NUMBER, line).group(1)
    for line in lines
]
total = sum(int(num, 10) for num in numbers)

print(f"Part 1: {total}")

########## Part 2 ##########

def words_to_numbers(line):
     return (
          line
          .replace("one", "1")
          .replace("two", "2")
          .replace("three", "3")
          .replace("four", "4")
          .replace("five", "5")
          .replace("six", "6")
          .replace("seven", "7")
          .replace("eight", "8")
          .replace("nine", "9")
     )

def first_and_last_digits(line):
     return (
          re.search(FIRST_NUMBER, line).group(1)
          + re.search(LAST_NUMBER, line).group(1)
     )

numbers = map(words_to_numbers, lines)
total = sum(int(num, 10) for num in map(first_and_last_digits, numbers))
print(f"Part 2: {total}")
