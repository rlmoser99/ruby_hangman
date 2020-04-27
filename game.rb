# frozen_string_literal: true

require './display'

# Game class is the base of hangman logic
class Game
  include Display

  def play
    @available_letters = ('a'..'z').to_a
    @solved_letters = []
    @turns_remaining = 8
    @incorrect_letters = []
    puts display_instructions
    word_selection
    create_solved_blanks
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
      break if @word.length.between?(7, 14)
    end
    word_array = @word.split(//)
    @solution = word_array[0..word_array.length - 3]
    puts display_word_size
  end

  def create_solved_blanks
    @solution.each { @solved_letters << '_' }
    puts display_letter_spaces(@solved_letters.join)
  end

  def update_solved_letters
    @solution.each_with_index do |item, index|
      @solved_letters[index] = item if item.match(@letter_regex)
    end
    puts display_letter_spaces(@solved_letters.join)
  end

  def player_turns
    loop do
      puts display_turn_prompt
      puts display_incorrect_list unless @incorrect_letters.empty?
      puts display_last_turn_warning if @turns_remaining == 1
      player_guess
      update_solved_letters
      @available_letters.delete(@player_guess.downcase)
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
    @incorrect_letters << @player_guess.downcase
    @turns_remaining -= 1
  end

  def game_over?
    @turns_remaining.zero?
  end

  def game_solved?
    @solved_letters.all? { |item| item.match?(/[a-z]/i) }
  end
end
