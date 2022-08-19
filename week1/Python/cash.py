from cs50 import get_float

# Declare a list of value of coins
coins = [25, 10, 5, 1]

# Variable list to store results
res = []

# Cash function


def cash(input):
    # Sorting loop that take the user input and check with each coin starting from the higher first
    for i in range(0, len(coins)):
        # the input is diveded by the value of the coin
        n = input/coins[i]
        # and the result are stored in the variable res
        res.append(int(n))
        # calculate the user input left after using a coin for the next coin
        input = input - coins[i] * int(n)

    # Variable sum to store the total of coins
    sum = 0
    # the loop goes over the list res adding each element to the sum
    for n in range(0, len(res)):
        sum = sum + res[n]
    # print the number of total coins
    print(sum)


# Loop to take input from the user
while True:
    # Variable to store the user input
    dollars = get_float("Change owed: ")
    # If there is an input greater than 0
    if dollars > 0:
        # Transform dollars to cents
        cents = round(dollars * 100)
        # Call cash function
        cash(cents)
        # break the loop
        break

