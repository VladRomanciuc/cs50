package main

/*
According to Scholastic, E.B. White’s Charlotte’s Web is between a second- and fourth-grade reading level, 
and Lois Lowry’s The Giver is between an eighth- and twelfth-grade reading level. What does it mean, though, 
for a book to be at a particular reading level?

Well, in many cases, a human expert might read a book and make a decision on the grade (i.e., year in school) 
for which they think the book is most appropriate. But an algorithm could likely figure that out too!

So what sorts of traits are characteristic of higher reading levels? Well, longer words probably correlate 
with higher reading levels. Likewise, longer sentences probably correlate with higher reading levels, too.

A number of “readability tests” have been developed over the years that define formulas for computing the 
reading level of a text. One such readability test is the Coleman-Liau index. 
The Coleman-Liau index of a text is designed to output that (U.S.) grade level that is needed to understand some text.
The formula is

index = 0.0588 * L - 0.296 * S - 15.8

where L is the average number of letters per 100 words in the text, and S is the average number of sentences 
per 100 words in the text.

Write a program called readability that takes a text and determines its reading level. 
For example, if user types in a line of text from Dr. Seuss, the program should behave as follows:

Text: Congratulations! Today is your day. You're off to Great Places! You're off and away!
Grade 3
The text the user inputted has 65 letters, 4 sentences, and 14 words. 
65 letters per 14 words is an average of about 464.29 letters per 100 words (because 65 / 14 * 100 = 464.29). 
And 4 sentences per 14 words is an average of about 28.57 sentences per 100 words (because 4 / 14 * 100 = 28.57).
Plugged into the Coleman-Liau formula, and rounded to the nearest integer, we get an answer of 3 
(because 0.0588 * 464.29 - 0.296 * 28.57 - 15.8 = 3): so this passage is at a third-grade reading level.
If the resulting index number is 16 or higher (equivalent to or greater than a senior undergraduate reading level), 
your program should output "Grade 16+" instead of outputting an exact index number. 
If the index number is less than 1, your program should output "Before Grade 1".
*/

import (
	"fmt"
	"os"
	"bufio"
	"strings"
	"math"
)


//Taking the user input
func input() string {
	//print the message for entering the text
	fmt.Println("Enter the text:") 
	
	//Scan the all entered text
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()

	//transform to text
	textInput := scanner.Text()
	return textInput
}


//Function to count letters
func countLetters(input string, alph []string) int{
	//transform all text to upper case
	text := strings.ToUpper(input)
	//set counter to zero
	letters := 0
	//for loop for each letter
	for i:=0; i<len(input); i++ {
		//for loop for alphabet
		for l:=0; l<len(alph); l++ {
			//match the letters and increase the counter
			if string(text[i]) == alph[l] {
				letters = letters + 1
			}
		}
	 }
	 //return the counter
	 return letters
}

//Function to count the words
func countWords(input string) int{
	//set counter to zero
	words := 0
	//for loop for user input
	for i:=0; i<len(input); i++ {
			// if there is a empty space increase the counter
			if string(input[i]) == " " {
				words = words + 1
			}
	 }
	 //return the counter
	 return words
}

//Function to count sentences
func countSentences(input string) int{
	//set the counter to zero
	sentences := 0
	//for loop for user input
	for i:=0; i<len(input); i++ {
		//if there is a match with "! ? ." increase the counter
		if string(input[i]) == "!" {
			sentences = sentences + 1
		} else if string(input[i]) == "?" {
			sentences = sentences + 1
		} else if string(input[i]) == "." {
			sentences = sentences + 1
		}
	 }
	 //return gthe counter
	 return sentences
}

//Function to count the index
func indexColemanLiau(sentences, words, letters float64) float64{
	calc := 0.0588*letters/words*100 - 0.296*sentences/words*100 - 15.8
	return calc
}

func main(){
	//Alphabet slice
	alph := []string{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
	//take the user input
	input := input()
	//add a extra space a the end of text for counter
	input = input + " "
	
	//call letter counter
	letters := countLetters(input, alph)
	fmt.Printf("Total letters: %v\n", letters)
	//call the word counter
	words := countWords(input)
	fmt.Printf("Total words: %v\n", words)
	// call the sentence counter
	sentences := countSentences(input)
	fmt.Printf("Total sentences: %v\n", sentences)
	// call the index function
	res := math.Round(indexColemanLiau(float64(sentences), float64(words), float64(letters)))

	//conditionals for index under 1, equal or over 16, and print between 1 and 16
	if res < 1 {
		fmt.Println("Index: Before Grade 1")
	} else if res >= 16 {
		fmt.Println("Index: Grade 16+")
	} else {
		fmt.Printf("Index: %v\n", res)
	}

}