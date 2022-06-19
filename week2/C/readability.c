#include <ctype.h>
#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

//functions
int countLetters(string input);
int countWords(string input);
int countSentences(string input);
int indexColemanLiau(int sentences, int words, int letters);


int main(void)
{

    //get entry from user
    string input = get_string("Enter the text: ");

    //call letter counter
    int letters = countLetters(input);

    //call the word counter
    int words = countWords(input);

    //call the sentence counter
    int sentences = countSentences(input);

    // call the index function
    int index = indexColemanLiau(sentences, words, letters);

    //conditionals for index under 1, equal or over 16, and print between 1 and 16
    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %d\n", index);
    }
}

//Function to count letters
int countLetters(string input)
{
    //set counter to zero
    int letters = 0;
    //get lenght of input and Letters
    int len = strlen(input);
    //for loop for each letter
    for (int i = 0; i < len; i++)
    {
        //match the letters and increase the counter
        if (isalpha(input[i]))
        {
            letters = letters + 1;
        }
    }
    //return the counter
    return letters;
}

//Function to count the words
int countWords(string input)
{
    //set counter to zero
    int words = 1;
    //get the lenght of input
    int len = strlen(input);
    //for loop for user input
    for (int i = 0; i < len; i++)
    {
        // if there is a empty space increase the counter
        if (isspace(input[i]) && isalpha(input[i + 1]))
        {
            words = words + 1;
        }
    }
    //return the counter
    return words;
}

//Function to count sentences
int countSentences(string input)
{
    //set the counter to zero
    int sentences = 0;
    //get the lenght of input
    int len = strlen(input);
    //for loop for user input
    for (int i = 0; i < len; i++)
    {
        //if there is a match with "! ? ." increase the counter
        if (input[i] == '.' || input[i] == '?' || input[i] == '!')
        {
            sentences = sentences + 1;
        }
    }
    //return gthe counter
    return sentences;
}

//Function to count the index
int indexColemanLiau(int sentences, int words, int letters)
{
    float l = ((float) letters / (float) words) * 100;
    float s = ((float) sentences / (float) words) * 100;
    int calc = round(0.0588 * l - 0.296 * s - 15.8);
    return calc;
}