#include <stdio.h>
#include <cs50.h>
#include <ctype.h>
#include <stdlib.h>

//Function caesar encryption
void caesar(char *, int);

int main(int argc, char *argv[])
{
    //key validator. If the user provides no command-line arguments, or two or more, the function prints "Usage: ./caesar key\n" and then returns 1, effectively exiting the program
    if (argc != 2)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
    for (int i = 0; argv[1][i] != '\0'; i++)
    {
        //check if each digit of the key is a letter and return
        if (isalpha(argv[1][i]) != 0)
        {
            printf("Usage: ./caesar key\n");
            return 1;
        }
    }
    // Convert the validated key to int
    int key = atoi(argv[1]);
    // take the message from user to encrypt
    char *plaintext = get_string("Text to encrypt: ");
    // call ceasar encryption passing the original message and the key
    caesar(plaintext, key);
}

void caesar(char *text, int key)
{
    //Print the result step by step (looks that this way is required by tests)
    printf("ciphertext: ");
    //For loop for the user message to encrypt
    for (int i = 0; text[i] != '\0'; i++)
    {
        //If the digit is a letter
        if (isalpha(text[i]) != 0)
        {
            //If the digit is upper case
            if (isupper(text[i]) != 0)
            {
                //Then the encrypted letter is printed
                printf("%c", ((text[i] - 'A' + key) % 26) + 'A');
            }
            //If the digit is in  lower case
            else
            {
                //Then the encrypted letter is printed
                printf("%c", ((text[i] - 'a' + key) % 26) + 'a');
            }
        }
        //If the digit is other than letter is printed in original
        else
        {
            printf("%c", text[i]);
        }
    }
    //Move to new line
    printf("\n");
}