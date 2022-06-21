# task: build:
#        #
#       ##
#      ###
#     ####
#    #####
#   ######
#  #######
# ########

# task2: build:
#        # #
#       ## ##
#      ### ###
#     #### ####
#    ##### #####
#   ###### ######
#  ####### #######
# ######## ########

#block builder function
def marion(e):
    #declare an empty string
    res = ""
    #start the for loop in the range from 1 for space and hash calculations
    for x in range (1, e+1):  
        #find out empty spaces
        space = e - x
        #find out hashes
        hash = e - space
        ##string builder
        for s in range (0, space):
            res = res + " "
        for h in range (0, hash):
            res = res +"#"
        res = res + " "
        for h in range (0, hash):
            res = res +"#"
        #print the line
        print(res)
        #empty string for new line
        res = ""

#function to take the input from user
def entry():
    entry = int(input("Enter a number between 1 and 8:"))
    return entry
################################

#main
#declare i to store the user input
i = entry()

#checker for input to be between 1 and 8
if(i > 1 and i < 9):
    marion(i)
else:
    print("Out of range...")