# frozen_string_literal: true

require './text_content'

# Game class is the base of hangman logic
class Game
  include TextContent

  def play
    @available_letters = ('a'..'z').to_a
    @display = []
    @turns_remaining = 8
    @rejected_letters = []
    puts display_instructions
    word_selection
    display_blanks
    player_turns
    puts display_reveal_word if @turns_remaining.zero?
    puts display_won_game if game_solved?
  end

  def random_word
    lines = IO.readlines('5desk.txt')
    random_number = rand * lines.length.to_i
    lines[random_number]
  end

  def word_selection
    loop do
      @word = random_word
      break if @word.length >= 7 && @word.length <= 14
    end
    word_array = @word.split(//)
    @solution = word_array[0..word_array.length - 3]
    # puts "The random word for this game is: #{@word}"
    puts display_word_size
  end

  # Temporary Method to trouble-shoot
  # def word_selection
  #   @word = 'Tests'
  #   puts @word
  #   @solution = @word.split(//)
  # end

  def display_blanks
    @solution.each { @display << '_' }
    puts display_letter_spaces(@display.join)
  end

  def display_word(_letter)
    @solution.each_with_index do |item, index|
      @display[index] = item if item.match(@letter_regex)
    end
    puts display_letter_spaces(@display.join)
  end

  def player_turns
    loop do
      puts display_turn_prompt
      puts display_incorrect_list unless @rejected_letters.empty?
      puts display_last_turn_warning if @turns_remaining == 1
      player_guess
      display_word(@player_guess)
      @available_letters.delete(@player_guess.downcase)
      # print @available_letters
      # puts ''
      break if game_over? || game_solved?
    end
  end

  def player_guess
    loop do
      @player_guess = gets.chomp
      break if @player_guess.length == 1 &&
               @available_letters.include?(@player_guess.downcase)

      puts display_turn_error
    end
    @letter_regex = /#{@player_guess}/i
    incorrect_guess unless @word.match(@letter_regex)
  end

  def incorrect_guess
    @rejected_letters << @player_guess.downcase
    @turns_remaining -= 1
  end

  def game_over?
    game_end = false
    game_end = true if @turns_remaining.zero?
    game_end
  end

  def game_solved?
    word_solved = false
    word_solved = true if @display.all? { |item| item.match?(/[a-z]/i) }
    word_solved
  end
end
