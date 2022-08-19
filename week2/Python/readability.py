from cs50 import get_string

# Function to count letters


def countLetters(input):
	# Set counter to zero
	letters = 0
	# For loop for each letter
	for i in input:
		# Match the letters and increase the counter
		if i.isalpha():
			letters = letters + 1
	# Return the counter
	return letters

# Function to count the words


def countWords(input):
	# Set counter to zero
	words = 0
	# For loop for user input
	for i in range(0, len(input)):
		# If there is a empty space increase the counter
		if input[i] == " ":
			words = words + 1
	# Return the counter
	return words

# Function to count sentences


def countSentences(input):
	# Set the counter to zero
	sentences = 0
	# For loop for user input
	for i in range(0, len(input)):
		# If there is a match with "! ? ." increase the counter
		if input[i] == "!":
			sentences = sentences + 1
		elif input[i] == "?":
			sentences = sentences + 1
		elif input[i] == ".":
			sentences = sentences + 1
	# Return the counter
	return sentences

# Function to count the index


def indexColemanLiau(sentences, words, letters):
	calc = 0.0588 * letters/words * 100 - 0.296 * sentences/words * 100 - 15.8
	return round(calc)

# Main Function


def main():
	# Take the user input
	entry = get_string("Text: ")
	# Add a extra space a the end of text for counter
	entry = entry + " "
	# Call letter counter
	letters = countLetters(entry)
	# Call the word counter
	words = countWords(entry)
	# Call the sentence counter
	sentences = countSentences(entry)
	# Call the index function
	res = indexColemanLiau(sentences, words, letters)
	# Conditionals for index under 1, equal or over 16, and print between 1 and 16
	if res < 1:
		print("Before Grade 1")
	elif res >= 16:
		print("Grade 16+")
	else:
		print("Grade: ", res)


# Execute
main()

