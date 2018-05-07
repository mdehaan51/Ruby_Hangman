require "json"
require "open-uri"

class Hangman

	def initialize
		@select_word = select_word.downcase
		@word_line = "_" * (@select_word.length-1)
		@guess_counter = 0
		@guessed_letter = []
		
	end

	def main_menu

		puts"What do you want to do? Select '1 or '2'"
		puts "1) Play New Game"
		puts "2) Load last saved game"
		loop do
		user_selection = gets.chomp
			if user_selection == "1" 
			puts "New Game!" 
			break
			elsif user_selection == "2" 
			puts "Load Game"
				if File.exist?("saved_game.txt")
					load_game
				else
					puts "There is no saved game"
				end
			else
			puts "Invalid Selection Please Try Again" 
			end
		end
		start_game
	end

	def save_game
		json_object = {:select_word => @select_word, :word_line => @word_line, 
						:guess_counter => @guess_counter, :guessed_letter => @guessed_letter}.to_json
		File.open("saved_game.txt", "w") { |f| f.write(json_object)}
		puts "Game Saved!"
		main_menu
		
	end

	def load_game
		saved_file = File.read("saved_game.txt")
		json_hash = JSON.load(saved_file)
		@select_word = json_hash["select_word"]
		@word_line = json_hash["word_line"]
		@guess_counter = json_hash["guess_counter"]
		@guessed_letter = json_hash["guessed_letter"]
		puts "Game Loaded!"
		start_game
	end




	def select_word
		file = IO.readlines('5desk.txt')
		selection = file[rand(61406)]
	end

	def start_game
		winner = false
			while @guess_counter != 10
				break if end_conditions
				puts @word_line
				puts "Guess a Letter or type 9 to save your game"
				puts "#{@guessed_letter}"
				player_guess = gets.chomp
				process_turn(player_guess)			
			end
	end

	def process_turn(player_guess)
		player_guess.downcase!
		current_status = "#{@word_line}"
			if player_guess == "9"
				save_game
			end
			if player_guess.length == 1
				@word_line.length.times do |index|
				@word_line[index] = player_guess if @select_word[index] == player_guess
				if @select_word.index(player_guess) == nil
					@guess_counter += 1 
					@remaining_guesses =  10 - @guess_counter
					puts "Sorry, guess again! You have #{@remaining_guesses} guesses remaining!"
					@guessed_letter.push(player_guess)
					if @remaining_guesses == 0
						puts "The word was #{@select_word.upcase}"
						puts "Sorry you lose!"
						exit
					end
					break
				end
			end
		
			end
	end

	def end_conditions
		unless @word_line.include?("_")
			puts "The word was #{@select_word.upcase}"
			puts "Contratulations you win!"
			true
			exit
		end
	end
end

Hangman.new.main_menu