from sys import argv
import csv
from collections import Counter


def main():

    # TODO: Check for command-line usage
    if len(argv) != 3:
        print("Usage: python dna.py data.csv sequence.txt")

    # TODO: Read database file into a variable
    with open(argv[1], newline='') as csvFile:
        csvReader = csv.DictReader(csvFile)
    # Read the headers for subsequence
        subSeq = csvReader.fieldnames
    # TODO: Read DNA sequence file into a variable
    with open(argv[2]) as seqFile:
        seq = seqFile.read()
    # TODO: Find longest match of each STR in DNA sequence
    # Create own dictionary for longest matches
    matches = {}
    for s in range(1, len(subSeq)):
        matches[subSeq[s]] = str(longest_match(seq, subSeq[s]))
    # Create a list to store the matched names
    ls = []
    # TODO: Check database for matching profiles
    # Open the Db file
    with open(argv[1], newline='') as csvDb:
        csvDbReader = csv.DictReader(csvDb)
        # Iterate each row
        for row in csvDbReader:
            # Iterate key, value pairs in the row
            for k, v in row.items():
                # Iterate each key, value in the longest matched
                for key, val in matches.items():
                    # If there is a match of pairs, add to the list of matched names
                    if k == key and v == val:
                        ls.append(row['name'])

    # Variable counter that uses native list function Counter to return the most common name
    count = Counter(ls).most_common(1)
    # For the key in count
    for key in count:
        # If there is a match of over 43% and the value of the match is more than 3 (manual ML deduction)
        if int(key[1]/len(ls)*100) > 43 and key[1] >= 3:
            # Print the name
            print(key[0])
        else:
            # Print no match
            print("No match")
    return


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()
