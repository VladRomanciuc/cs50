#include <cs50.h>
#include <stdio.h>
//task: build:
//        # #
//       ## ##
//      ### ###
//     #### ####
//    ##### #####
//   ###### ######
//  ####### #######
// ######## ########


int main(void)
{
    //declare a variable for the entry
    int entry;
    //start a forever loop to read the entry from the user while it is not in the range of 1-8
    do
    {
    entry = get_int("Build a Mario Pyramid with the height between 1 and 8: ");
    }
    while (entry < 1 || entry > 8);

    //if the entry is in the range of 1-8 start drawing the pyramid row by row
    if (entry >= 1 && entry <= 8)
    {
    //start from first row
    int row = 1;
    //while loop if the row is lower or equal with the entry
    while (row <= entry)
    {
    //find the number of empty spaces to draw
    int space = entry - row;
    //start the loop from higher number for spaces
    for (int s = space; s > 0; s--)
    {
    printf(" ");
    };
    //start the loop from higher number for hashes
    for (int e = entry; e > space; e--)
    {
    printf("#");
    };
    //print 2 empty spaces
    printf("  ");
    //repeat the loop for hashes
    for (int e = entry; e > space; e--)
    {
    printf("#");
    };
    //move to new line
    printf("\n");
    //start a new row
    row++;
    }
    }

}