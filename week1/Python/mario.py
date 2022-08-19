from cs50 import get_int

# block builder function


def marion(e):
    # declare an empty string
    res = ""
    # start the for loop in the range from 1 for space and hash calculations
    for x in range(1, e+1):
        # find out empty spaces
        space = e - x
        # find out hashes
        hash = e - space
        # string builder
        for s in range(0, space):
            res = res + " "
        for h in range(0, hash):
            res = res + "#"
        res = res + "  "
        for h in range(0, hash):
            res = res + "#"
        # print the line
        print(res)
        # empty string for new line
        res = ""

################################

# main


while True:
    # declare i to store the user input
    i = get_int("Height: ")
    # checker for input to be between 1 and 8
    if i > 0 and i < 9:
        # Build
        marion(i)
        break
###########
