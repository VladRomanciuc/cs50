package main

import (
	"fmt"
	"log"
	"strings"
	
)
//Build a simple scrabble game

//Function to read the entry from console
func input() string {
	var input string
	_, err := fmt.Scan(&input)
	if err != nil {
		log.Fatal(err)
	}
	return input
}

func score(input string) int {
	letters := []string{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
	numbers := []int{1,	3,	3,	2,	1,	4,	2,	4,	1,	8,	5,	1,	3,	1,	1,	3,	10,	1,	1,	1,	1,	4,	4,	8,	4,	10}

	word := strings.ToUpper(input)
	
	sum := []int{}
	
	for _, l := range word {
		for i:=0; i < len(letters); i++ {
			if string(l) == letters[i] {
				sum = append(sum, numbers[i])
			}
		}
	}

	res := 0
	for index := 0; index<len(sum); index++ {
		res = res + sum[index]
	}
	return res
}

func main(){
	fmt.Println("Player-1, waiting for your word: ")
	input1 := input()
	fmt.Println("Player-2, waiting for your word: ")
	input2 := input()

	player1 := score(input1)
	player2 := score(input2)

	if player1 < player2 {
		fmt.Printf("WOW... Cogratulations Player 2 !!! you scored: << %v >> vs << %v >>", player2, player1)
	} else if player1 > player2 {
		fmt.Printf("WOW... Cogratulations Player 1 !!! you scored: << %v >> vs << %v >>", player1, player2)
	} else if player1 == player2 {
		fmt.Printf("Well... you need one more game !!! the players scored: << %v >> vs << %v >>", player1, player2)
	}

}