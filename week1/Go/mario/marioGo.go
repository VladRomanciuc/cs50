package main

//task1: build:
//        #
//       ##
//      ###
//     ####
//    #####
//   ######
//  #######
// ########

//task2: build:
//        # #
//       ## ##
//      ### ###
//     #### ####
//    ##### #####
//   ###### ######
//  ####### #######
// ######## ########

import (
	"fmt"
)
	//Function builder of pyrimid for task 1
func marion(input int) {

	//Declare 2 variables for space and hash
	s := " "
	d := "#"

	//Builder loop
	for i:=1; i <= input; i++ {
		//calculate how many empty spaces a needed for current row
		space := (input-i)
		
		//Loop to print empty spaces
		for n := space; n>0; n--{
			fmt.Print(s)
		}
		//Loop to print hashes
		for m := input; m>space; m--{
			fmt.Print(d)
		}
		//Move to a new line
		fmt.Print("\n")
	}
	
}
	//Function builder of pyrimid for task 2 (first modified)
func marion2(input int ) {
	//Declare 2 variables for space and hash
	s := " "
	h := "#"
	//Builder loop
	for line:=1; line <= input; line++ { //i = line

		//calculate how many empty spaces a needed for current row
		space := (input-line)
		//Loop to print empty spaces
		for n := space; n > 0; n--{
			fmt.Print(s)
		}
		//Loop to print hashes
		for m := input; m > space; m--{
			fmt.Print(h)
		}
		//Prin a empty space before the inverted pyramid
		fmt.Print(s)
		//Loop to print hashes first
		for m := input; m > space; m--{
			fmt.Print(h)
		}
		//Loop to print empty spaces
		for n := space; n > 0; n--{
			fmt.Print(s)
		}
		//Move to a new line
		fmt.Print("\n")

	}
}
	//Main function
func main(){
	//Variable for the user input
	var input int
	//Forever loop to take the input from the user and build the pyramid
	for { 
		fmt.Println("Enter a number between 1 and 8:")
		fmt.Scanln(&input)
		//check the input to be between 1 and 8
		if input >= 1 && input <=8 {
			//Call the builder functions
			marion(input)
			fmt.Print("\n-----------\n")
			marion2(input)
		}
	}

}