#!/usr/bin/env ruby

require "csv"

# It returns an 2D-array: [[row1_col1, row1_col2,...], [row2_col1, row2_col2,...], ...]
# In this case: [[word1, gender1, meaning1], [word2, gender2, meaning2], ...]
def getCSVContent(csv_path, separator)

	content = ""

	if File.file?(csv_path) 
		content = CSV.read(csv_path, {:col_sep => separator})
	else
		abort("The file #{csv_path} doesn't exist.")
	end

	return content
end

# It returns a 1D array: [word, gender, meaning]
def getRandomEntryFromDict(dictionary)

	if dictionary.length == 0
		STDERR.puts("[Guesslova] Error: empty dictionary.")
		exit(false)
	end

	random_entry = ""

	num_of_words = dictionary.length
	random_entry_number = rand(num_of_words)

	random_entry = dictionary[random_entry_number]

	return random_entry
end

def askEntryToUser(word, gender, meaning)

	#Code color: 220 = yellow
	start_code_color = "\e[38;5;220m"
	restore_to_default_color = "\e[0m"

	puts start_code_color + word + "\n\nGender: " + gender +  restore_to_default_color

	# Undefined genders are represented by "-" in the CSV, and no need to ask those.
	
	#if gender != "-"
	if 1 == 2
		printf "\nGender: "
		user_input = STDIN.gets.chomp
		puts "\n#{gender}"
	end
	
	printf "\nMeaning: "
	user_input = STDIN.gets.chomp
	puts "\n#{meaning}"
end

#Ask the user whether he wants to quit the program.
def askExit()
	puts "\n\nPress Enter to continue or Q to exit."
	user_input = STDIN.gets.chomp

	if user_input == "Q"
		puts "\e[H\e[2J"
		exit(true)
	end
end

def main()

	#file_path = ARGV[0]
	file_path = "../words-and-sentences.csv"
	separator = "\t"
	user_input = ""

	entries_already_asked = []

	dictionary = getCSVContent(file_path, separator)
	
	# https://ruby-doc.org/core-2.2.0/Interrupt.html
	begin

		while(true)
			
			# To clear the screen (https://stackoverflow.com/questions/3170553/how-can-i-clear-the-terminal-in-ruby#comment50429692_19058589)
			puts "\e[H\e[2J"

			random_entry = getRandomEntryFromDict(dictionary - entries_already_asked)

			word = random_entry[2]
			gender = random_entry[1]
			meaning = random_entry[0]

			askEntryToUser(word, gender, meaning)
			askExit()

			entries_already_asked.insert(0, random_entry)

			# In case that we've asked all the words, 'restart' the program.
			if entries_already_asked.length == dictionary.length
				entries_already_asked = []
			end

		end

	# Capture Ctrl + C and terminate the program.
	rescue Interrupt => e
		puts "\e[H\e[2J"
	end

end


main()


=begin

V0.2

Future features:

- Option to ask the English name and the user to input the Czech part
- If the Czech plural and singular are the same, make it explicit when asking it to the user (example: "ovoce" is the same in singular and in plural. Therefore, ask for "ovoce (singular)" or "ovoce (plural)")


=end