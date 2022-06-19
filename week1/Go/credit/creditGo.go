package main

/*
American Express uses 15-digit numbers, 
MasterCard uses 16-digit numbers, and 
Visa uses 13- and 16-digit numbers.

All American Express numbers start with 34 or 37; 
most MasterCard numbers start with 51, 52, 53, 54, or 55
all Visa numbers start with 4
*/

/*
Luhn’s Algorithm
So what’s the secret formula? Well, most cards use an algorithm invented by Hans Peter Luhn of IBM.
According to Luhn’s algorithm, you can determine if a credit card number is (syntactically) valid as follows:

Multiply every other digit by 2, starting with the number’s second-to-last digit, and then add those products’ digits together.
Add the sum to the sum of the digits that weren’t multiplied by 2.
If the total’s last digit is 0 (or, put more formally, if the total modulo 10 is congruent to 0), the number is valid!
*/

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

	//Function to take the input from the user
func input() []int {
	fmt.Println("Waiting for the entry of a card number: ")
	//Read the line of entered numbers in the terminal
    console := bufio.NewReader(os.Stdin)
    line, _, _ := console.ReadLine()
	//Declare a variable slice to store the input
	var newSlice []int
		//Loop that go over the input and clean if there are empty or - entries
		for i:=0; i<len(line); i++ {
			if (string(line[i]) != " " && string(line[i]) != "-"){
			//convert the string to int
			number, _ := strconv.Atoi(string(line[i]))
			//additional filter if there any negatives or - left
			if number >= 0 {
				//slice builder
				newSlice = append(newSlice, number)
			}
		}		
	}
	//returning  a slice to work with math ops
	return newSlice
}
	//The checksum function to validate the cards is done in 2 steps (the final sum checker is done in a extra function to keep this function clean)
func checksum(slice []int) string {
//step 1
	//slice to store numbers filtered in step1
	var step1 []int
	//Loop to over the slice from end starting at -1 position skiping 1 number
	for i := len(slice)-2; i >= 0; i -= 2 {	
		//each number is multiplyed by 2
		number := slice[i]*2
		//If the number is composed from 2 digits is transformed in string
		if number > 9 {
			n := strconv.Itoa(number)
			//Loop goes over the string
			for _, digit := range n {
				//each number is converted to int and added to the step1 slice
				c, _ := strconv.Atoi(string(digit))
				step1 = append(step1, c)
			}
		} else {
			//the number is added to the step1 slice
			step1 = append(step1, number)	
		}
		
	}

//step 2
	//slice to store results for the step2
	var step2 []int
	//The loop goes over the slice strating from the end skiping 1 number
	for i := len(slice)-1; i >= 0; i -= 2 {
		//the number is added to the step2 slice
		step2 = append(step2, slice[i])
	}
	//variable check call the sum function for both slices and transform result to a string
	check := strconv.Itoa(sum(step1)+sum(step2))
	//empty string used for the return
	res := ""
	//in the result has a result ending with 0 and 0 is not the value of checksum return valid else invalid
	if strings.HasSuffix(check, "0") && check != "0" {
		res = "VALID"
		return res
	} else {
		res = "INVALID"
		return res
	}
}

	//Simple function that sum all int in a slice
func sum(slice []int) int {
	total :=0
	for _, val := range slice {
		total = total + val
	}
	return total
}
	//The cleaner function is required to built a string from a slice and return the card number in a string
func clean(slice []int) string {
	//card is assigned as a string builder
	card := strings.Builder{}
	//the loop take each int in the slice transform into string
	for _, v := range slice {
		i := strconv.Itoa(v)
		//card builder is writing each string element
		card.WriteString(i)
	}
	// return the full build string
	return card.String()
}
	//american express card checker
func checkA(clean string) string {
	res := ""
	//lenght check + prefixes of card issuer
	if len(clean) == 15 {
		if strings.HasPrefix(clean, "34") {
			res = "American Express"
		} else if strings.HasPrefix(clean, "37") {
			res = "American Express"
		} else {
			res = "INVALID"
		}
	}
	//return card issuer or invalid
	return res
}
	//Master card checker
func checkM(clean string) string {
	//Slice of predefined prefixes
	prefix := []string{"51", "52", "53", "54", "55"}
	res := "INVALID"
	//lenght check + prefixes of card issuer
	for i := 0; i < len(prefix); i++ {
			if len(clean) == 16 && strings.HasPrefix(clean, prefix[i]) {
				res = "MasterCard"
			} 
		} 
		//return card issuer or invalid
		return res
	}

func checkV(clean string) string {
	res := ""
	//lenght check + prefixes of card issuer
	if len(clean) == 13 {
		if strings.HasPrefix(clean, "4"){
			res = "Visa"
			}
		} else if len(clean) == 16 {
			if strings.HasPrefix(clean, "4"){
		 	res = "Visa"
			}
		} else {
			res = "INVALID"
	}
	//return card issuer or invalid
	return res
}
	//func checker for all cards calling each function return card issuer or invalid
func check(clean string) string {
	res := ""
	if checkA(clean) == "American Express" {
		res = "American Express"
	} else if checkM(clean) == "MasterCard" {
		res = "MasterCard"
	} else if checkV(clean) == "Visa" {
		res = "Visa"
	} else {
		res = "INVALID"
	}
	return res
}


	//Main executable function
func main() {
	//take the input from a user
	i := input()
	//clean up the input
	c := clean(i)
	//check the type of card
	ch := check(c)
	//check the sum if is a valid card or not
	a := checksum(i)
	//Print the results
	fmt.Printf(">>>>>> %s card: %s  >>>>>>>>>> checksum: %s <<<<<<<<<<<<<<<", ch, c, a)
}