// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

//Number of buckets in hash table
const unsigned int N = 26;
// Hash table
node *table[N];
//Declare a variable Hash
unsigned int Hash;
//Create a word counter to start from 0
unsigned int counter = 0;
// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    //Use the hash function as per task intructions
    Hash = hash(word);
    //Create a node to store data from table
    node *nd = table[Hash];
    //Loop the list
    while (nd != NULL)
    {
        //If the word exists return true
        if (strcasecmp(nd -> word, word) == 0)
        {
            return true;
        }
        //Move to next node
        nd = nd -> next;
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    //(stdlib recommendations for usage)
    //Generate a random number
    int number = (rand() / ((double) RAND_MAX + 1)) * N;
    //Loop for each byte in the word
    for (int i = 0; i < strlen(word); i++)
    {
        int t = atoi(&word[i]);
        //XOR each byte in transformed letter of the word
        Hash = Hash ^ t;
        //Multiply by a magic random number
        Hash = Hash * number;
    }
    return Hash;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    //Open the dictionary file
    FILE *fileOp = fopen(dictionary, "r");
    //Null checker
    if (fileOp == NULL)
    {
        printf("Error opening the file: %s", dictionary);
        return false;
    }

    //Declare a variable to store the words (from node struct)
    char wrd[LENGTH + 1];

    //Scannning each word in the file until EOF return (end of the file)
    while (fscanf(fileOp, "%s", wrd) != EOF)
    {
        //Allocate memory to store temporary a node
        node *nd = malloc(sizeof(node));
        //Null checker
        if (nd == NULL)
        {
            return false;
        }
        //Copy word from temp node to permanent
        strcpy(nd -> word, wrd);
        //Use the hash function as per task intructions
        int hashW = hash(wrd);
        //Point the node to the word
        nd -> next = table[hashW];
        //Point table to temporary node to loop
        table[hashW] = nd;
        //Increase counter
        counter++;
    }
    //Clean up.
    //Close the opened file
    fclose(fileOp);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    if (counter != 0)
    {
        return counter;
    }
    else
    {
        return 0;
    }
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        //Create a node for workflow
        node *nd = table[i];
        //Loop while the node return true
        while (nd)
        {
            //Create a temp node to clean memory
            node *tmp = nd;
            //Move to next node
            nd = nd -> next;
            //Empty the temp node
            free(tmp);
        }
        //If node is null the memory is empty
        if (nd == NULL)
        {
            return true;
        }

    }
    return false;
}
