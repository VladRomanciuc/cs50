#include <cs50.h>
#include <stdio.h>

/*
Greedy cashier
What’s all that mean? Well, suppose that a cashier owes a customer some change and in that cashier’s drawer are quarters (25¢), 
dimes (10¢), nickels (5¢), and pennies (1¢). The problem to be solved is to decide which coins and how many of each to hand 
to the customer. Think of a “greedy” cashier as one who wants to take the biggest bite out of this problem as possible with 
each coin they take out of the drawer. For instance, if some customer is owed 41¢, the biggest first (i.e., best immediate, 
or local) bite that can be taken is 25¢. (That bite is “best” inasmuch as it gets us closer to 0¢ faster than any other coin would.)
*/

int get_cents(void);
int calculate_quarters(int cents);
int calculate_dimes(int cents);
int calculate_nickels(int cents);
int calculate_pennies(int cents);

int main(void)
{
    // Ask how many cents the customer is owed
    int cents = get_cents();

    // Calculate the number of quarters to give the customer
    int quarters = calculate_quarters(cents);
    cents = cents - quarters * 25;

    // Calculate the number of dimes to give the customer
    int dimes = calculate_dimes(cents);
    cents = cents - dimes * 10;

    // Calculate the number of nickels to give the customer
    int nickels = calculate_nickels(cents);
    cents = cents - nickels * 5;

    // Calculate the number of pennies to give the customer
    int pennies = calculate_pennies(cents);
    cents = cents - pennies * 1;

    // Sum coins
    int coins = quarters + dimes + nickels + pennies;

    // Print total number of coins to give the customer
    printf("Total coins owed: %i\n", coins);
}

int get_cents(void)
{
    //var for the user input
    int input;
    //do/while loop to get the input (if negative promt again)
    do
    {
    input = get_int("Please, enter the amount owed: ");
    }
    while (input < 0);
    //return the input to use in the main function
    return input;
}

int calculate_quarters(int cents)
{
    //var for the result of number of coins with the value 25
    int n;
    n = cents / 25;
    //print the number of quarters owed
    printf("Quarters: %i\n", n);
    //return result to main
    return n;
}

int calculate_dimes(int cents)
{
    //var for the result of number of coins with the value 10
    int n;
    n = cents / 10;
    //print the number of dimes owed
    printf("Dimes: %i\n", n);
    //return result to main
    return n;
}

int calculate_nickels(int cents)
{
    //var for the result of number of coins with the value 5
    int n;
    n = cents / 5;
    //print the number of nickels owed
    printf("Nickels: %i\n", n);
    //return result to main
    return n;
}

int calculate_pennies(int cents)
{
    //var for the result of number of coins with the value 1
    int n;
    n = cents / 1;
    //print the number of pennies owed
    printf("Pennies: %i\n", n);
    //return result to main
    return n;
}
