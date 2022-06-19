package main

import (
	"fmt"
)

/*
Well, suppose that a cashier owes a customer some change and in that cashier’s drawer are quarters (25¢), dimes (10¢), 
nickels (5¢), and pennies (1¢). The problem to be solved is to decide which coins and how many of each to hand to the customer.
Think of a “greedy” cashier as one who wants to take the biggest bite out of this problem as possible with each coin they
take out of the drawer. For instance, if some customer is owed 41¢, the biggest first (i.e., best immediate, or local)
bite that can be taken is 25¢. (That bite is “best” inasmuch as it gets us closer to 0¢ faster than any other coin would.) 
Note that a bite of this size would whittle what was a 41¢ problem down to a 16¢ problem, since 41 - 25 = 16. That is, 
the remainder is a similar but smaller problem. Needless to say, another 25¢ bite would be too big (assuming the cashier 
prefers not to lose money), and so our greedy cashier would move on to a bite of size 10¢, leaving him or her with a 6¢ 
problem. At that point, greed calls for one 5¢ bite followed by one 1¢ bite, at which point the problem is solved. 
The customer receives one quarter, one dime, one nickel, and one penny: four coins in total.
*/
	//Function to sort the cash
func cash(input int) {

	//Declare a slice of value of coins
	coins := []int {25, 10, 5, 1}

	//Variable slice to store results
	res := []int {}

	//Sorting loop that take the user input and check with each coin starting from the higher first
	for i:=0; i<len(coins); i++ {
		//the input is diveded by the value of the coin
		n := input/coins[i]
		//and the result are stored in the variable slice
		res = append(res, n)
		//print the the number of coins and their value
		fmt.Printf("Coins %v: %v\n", coins[i], n)
		//calculate the user input left after using a coin for the next coin
		input = input - coins[i]*n
	} 
	//Variable sum to store the total of coins
	sum := 0
	//the loop goes over the variable slice adding each element to end with the sum
	for n:=0; n <len(res); n++{
		sum = sum + res[n]
	}
	//print the number of total coins
	fmt.Printf("Total coins owed: %v\n", sum)
}


func main() {
	//variable to store the user input
	var answer int
	//forever loop to take the user input and run greedy sorting
	for { 
		fmt.Println("Please, enter the amount owed: ")
		fmt.Scanln(&answer)
		//checker to eliminate the negative numbers
		if answer >= 0 {
			cash(answer)
		} else {
			fmt.Println("Sorry, out of range...")
		}
		fmt.Println("-----------------------------")
	}
}