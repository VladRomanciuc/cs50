package main

/*
There’s another kind of voting system known as a ranked-choice voting system. 
In a ranked-choice system, voters can vote for more than one candidate. 
Instead of just voting for their top choice, they can rank the candidates in order of preference. 
The resulting ballots might therefore look like the below.

Who should win this election? In a plurality vote where each voter chooses their first preference only, 
Charlie wins this election with four votes compared to only three for Bob and two for Alice. 
But a majority of the voters (5 out of the 9) would be happier with either Alice or Bob instead of Charlie. 
By considering ranked preferences, a voting system may be able to choose a winner that better reflects the preferences of the voters.

One such ranked choice voting system is the instant runoff system. 
In an instant runoff election, voters can rank as many candidates as they wish. 
If any candidate has a majority (more than 50%) of the first preference votes, that candidate is declared the winner of the election.

If no candidate has more than 50% of the vote, then an “instant runoff” occurrs. 
The candidate who received the fewest number of votes is eliminated from the election, 
and anyone who originally chose that candidate as their first preference now has their second preference considered. 
Why do it this way? Effectively, this simulates what would have happened if the least popular candidate 
had not been in the election to begin with.

The process repeats: if no candidate has a majority of the votes, the last place candidate is eliminated, 
and anyone who voted for them will instead vote for their next preference (who hasn’t themselves already been eliminated). 
Once a candidate has a majority, that candidate is declared the winner.

Expectations:
./runoff Alice Bob Charlie
Number of voters: 5
Rank 1: Alice
Rank 2: Charlie
Rank 3: Bob

Rank 1: Alice
Rank 2: Charlie
Rank 3: Bob

Rank 1: Bob
Rank 2: Charlie
Rank 3: Alice

Rank 1: Bob
Rank 2: Charlie
Rank 3: Alice

Rank 1: Charlie
Rank 2: Alice
Rank 3: Bob

Alice
*/

func main(){

}