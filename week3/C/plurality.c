#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>

// Max number of candidates
#define MAX 9

// Candidates have name and vote count
typedef struct
{
    string name;
    int votes;
}
candidate;

// Array of candidates
candidate candidates[MAX];

// Number of candidates
int candidate_count;

// Function prototypes
bool vote(string name);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: plurality [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
    }

    int voter_count = get_int("Number of voters: ");

    // Loop over all voters
    for (int i = 0; i < voter_count; i++)
    {
        string name = get_string("Vote: ");

        // Check for invalid vote
        if (!vote(name))
        {
            printf("Invalid vote.\n");
        }
    }

    // Display winner of election
    print_winner();
}

// Update vote totals given a new vote
bool vote(string name)
{
//for loop on candidates
    for (int i = 0; i < candidate_count; i++)
    {
//if the name match, the number of votes is increased by 1
        if (strcasecmp(name, candidates[i].name) == 0)
        {
            candidates[i].votes++;
//return true if there is a match, else return false
            return true;
        }
    }
    return false;
}

// Print the winner (or winners) of the election
void print_winner(void)
{
//variable to store the max numer of votes
    int votes = 0;
//for loop comparing the current state of number of vote with the number of votes in the array
    for (int i = 0; i < candidate_count; i++)
    {
//if the value of variable is less than actual value of votes in the arrray assign the value to variable
        if (votes < candidates[i].votes)
        {
            votes = candidates[i].votes;
        }
    }
//for loop that check the value of variable with the value in the array
    for (int l = 0; l < candidate_count; l++)
    {
//if there is a match print the name
        if (votes == candidates[l].votes)
        {
            printf("%s\n", candidates[l].name);
        }
    }
    return;
}