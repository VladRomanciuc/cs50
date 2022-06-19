#include <ctype.h>
#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Points assigned to each letter of the alphabet
int POINTS[] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};
//alphabet
char Letters[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
int compute_score(string word);

int main(void)
{
    // Get input words from both players
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    // Score both words
    int score1 = compute_score(word1);
    int score2 = compute_score(word2);

    //Print the winner comparing scores
    if (score1 < score2)
    {
        printf("Player 2 wins!\n");
    }
    else if (score1 > score2)
    {
        printf("Player 1 wins!\n");
    }
    else if (score1 == score2)
    {
        printf("Tie!\n");
    }
}

//Compute and return score for string
int compute_score(string word)
{
    //lenght of the word
    int lenword = strlen(word);
    //lenght of alphabet
    int lenlet = strlen(Letters);
    //variable result to store the result
    int result = 0;
    //for loop for each letter in the word
    for (int i = 0; i < lenword; i++)
    {
        //For loop for the alphabet
        for (int l = 0; l < lenlet; l++)
        {
            //transfor a letter from word to uperpcase to match the alphabet
            //if there is a match result add the points living at x address
            if (toupper(word[i]) == Letters[l])
            {
                result = result + POINTS[l];
            }
        }
    }
    //return result
    return result;
}
