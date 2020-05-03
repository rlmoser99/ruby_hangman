# frozen_string_literal: true

require './display'
require './database'
require 'yaml'

# Game class is the base of hangman logic
class Game
  attr_accessor :word, :available_letters, :solved_letters, :incorrect_letters
  include Display
  include Database

  def initialize
    @available_letters = ('a'..'z').to_a
    @solved_letters = []
    @incorrect_letters = []
    play_game
  end

  def play_game
    puts display_instructions
    game_type = user_input(display_start, /^[12]$/)
    new_game if game_type == '1'
    load_game if game_type == '2'
  end

  def new_game
    @word = random_word
    @solution = word.split(//)
    create_letter_blanks
    player_turns
    end_game
  end

  def random_word
    word_list = IO.readlines('5desk.txt')
    word_list.each(&:strip!).select { |word| word.length.between?(5, 12) }
    word_list[rand(0..word_list.length)]
  end

  def create_letter_blanks
    @solution.each { solved_letters << '_' }
    puts display_word_size
  end

  def update_solved_letters
    @solution.each_with_index do |item, index|
      solved_letters[index] = item if item.match(@letter_regex)
    end
  end

  def player_turns
    loop do
      puts display_letter_spaces(solved_letters.join)
      player_guess_letter
      break if @player_guess.length > 1

      turn_updates
      break if game_over? || game_solved?
    end
    save_game if @player_guess == 'save'
  end

  def turn_updates
    incorrect_guess unless word.match(@letter_regex)
    update_solved_letters if word.match(@letter_regex)
    available_letters.delete(@player_guess.downcase)
  end

  def user_input(prompt, regex)
    loop do
      print prompt
      input = gets.chomp
      input.match(regex) ? (return input) : print(display_input_warning)
    end
  end

  def player_guess_letter
    loop do
      optional_turn_info
      @player_guess = user_input(display_turn_prompt, /^[a-z]$|^exit$|^save$/i)
      break if @player_guess.length > 1
      break if available_letters.include?(@player_guess.downcase)

      puts display_turn_error
    end
    @letter_regex = /#{@player_guess}/i
  end

  def optional_turn_info
    puts display_incorrect_list unless incorrect_letters.empty?
    puts display_last_turn_warning if incorrect_letters.length == 7
  end

  def incorrect_guess
    incorrect_letters << @player_guess.downcase
    puts display_incorrect_guess
  end

  def game_over?
    incorrect_letters.length == 8
  end

  def game_solved?
    solved_letters.all? { |item| item.match?(/[a-z]/i) }
  end

  def end_game
    puts display_reveal_word if game_over?
    puts display_won_game if game_solved?
    play_again = user_input(display_play_again, /^[1-2]$/)
    puts display_thanks if play_again == '2'
    Game.new if play_again == '1'
  end
end
