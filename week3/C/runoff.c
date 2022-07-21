#include <cs50.h>
#include <stdio.h>
#include <strings.h>

// Max voters and candidates
#define MAX_VOTERS 100
#define MAX_CANDIDATES 9

// preferences[i][j] is jth preference for voter i
int preferences[MAX_VOTERS][MAX_CANDIDATES];

// Candidates have name, vote count, eliminated status
typedef struct
{
    string name;
    int votes;
    bool eliminated;
}
candidate;

// Array of candidates
candidate candidates[MAX_CANDIDATES];

// Numbers of voters and candidates
int voter_count;
int candidate_count;

// Function prototypes
bool vote(int voter, int rank, string name);
void tabulate(void);
bool print_winner(void);
int find_min(void);
bool is_tie(int min);
void eliminate(int min);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: runoff [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX_CANDIDATES)
    {
        printf("Maximum number of candidates is %i\n", MAX_CANDIDATES);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
        candidates[i].eliminated = false;
    }

    voter_count = get_int("Number of voters: ");
    if (voter_count > MAX_VOTERS)
    {
        printf("Maximum number of voters is %i\n", MAX_VOTERS);
        return 3;
    }

    // Keep querying for votes
    for (int i = 0; i < voter_count; i++)
    {

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            // Record vote, unless it's invalid
            if (!vote(i, j, name))
            {
                printf("Invalid vote.\n");
                return 4;
            }
        }

        printf("\n");
    }

    // Keep holding runoffs until winner exists
    while (true)
    {
        // Calculate votes given remaining candidates
        tabulate();

        // Check if election has been won
        bool won = print_winner();
        if (won)
        {
            break;
        }

        // Eliminate last-place candidates
        int min = find_min();
        bool tie = is_tie(min);

        // If tie, everyone wins
        if (tie)
        {
            for (int i = 0; i < candidate_count; i++)
            {
                if (!candidates[i].eliminated)
                {
                    printf("%s\n", candidates[i].name);
                }
            }
            break;
        }

        // Eliminate anyone with minimum number of votes
        eliminate(min);

        // Reset vote counts back to zero
        for (int i = 0; i < candidate_count; i++)
        {
            candidates[i].votes = 0;
        }
    }
    return 0;
}

// Record preference if vote is valid
bool vote(int voter, int rank, string name)
{
//for loop on candidates
    for (int i = 0; i < candidate_count; i++)
    {
//if the name match, the preferences are asigned the index
        if (strcasecmp(name, candidates[i].name) == 0)
        {
            preferences[voter][rank] = i;
//return true if there is a match, else return false
            return true;
        }
    }
    return false;
}

// Tabulate votes for non-eliminated candidates
void tabulate(void)
{
//loop on preferences map using 2 indexes for voter and candidate
    for (int i = 0; i < voter_count; i++)
    {
        for (int l = 0; l < candidate_count; l++)
        {
//check if the candidate it is not eliminated
            if (candidates[preferences[i][l]].eliminated == false)
            {
//increase the count on number of votes
                candidates[preferences[i][l]].votes++;
//stop and move to next candidate
                break;
            }
        }
    }
    return;
}

// Print the winner of the election, if there is one
bool print_winner(void)
{
//lopp over candidates map
    for (int i = 0; i < candidate_count; i++)
    {
//check if there are candidates with number of votes more than half of total votes
        if (voter_count / 2 < candidates[i].votes)
        {
//print the candidates name
            printf("%s\n", candidates[i].name);
//return true at this point
            return true;
        }
    }
    return false;
}

// Return the minimum number of votes any remaining candidate has
int find_min(void)
{
//declare a variable to store the identified minimum votes
    int counter = voter_count;
//loop over candidates votes
    for (int i = 0; i < candidate_count; i++)
    {
//if the initial value of the counter is higher than the
//number of votes of an candidate and the candidate is not eliminated
        if (counter > candidates[i].votes && candidates[i].eliminated == false)
        {
//assign the current number of votes to counter
            counter = candidates[i].votes;
        }
    }
//return the value of the counter
    return counter;
}

// Return true if the election is tied between all candidates, false otherwise
bool is_tie(int min)
{
//declare 2 variable to store the counters on the number of eliminates and votes
    int elim = 0;
    int vot = 0;
//loop on candidates array
    for (int i = 0; i < candidate_count; i++)
    {
//if the candidate is not eliminated
        if (!candidates[i].eliminated)
        {
//increase the eliminates counter
            elim++;
        }
//if the candidate has a min number of votes
        if (candidates[i].votes == min)
        {
//increase the counter on votes
            vot++;
        }
    }
//if the number of eliminates are equal to the number of voters return true
    if (elim == vot)
    {
        return true;
    }
    return false;
}

// Eliminate the candidate (or candidates) in last place
void eliminate(int min)
{
//loop over candidates array
    for (int i = 0; i < candidate_count; i++)
    {
//if a candidate has a minimum number of votes
        if (candidates[i].votes == min)
        {
//the candidate is eliminated
            candidates[i].eliminated = true;
        }
    }
    return;
}