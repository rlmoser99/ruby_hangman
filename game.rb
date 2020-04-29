# frozen_string_literal: true

require './display'

# Game class is the base of hangman logic
class Game
  include Display

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
    player_turns
    puts display_reveal_word if @incorrect_letters.length == 8
    puts display_won_game if game_solved?
  end

  def new_game
    word_selection
    create_solved_blanks
  end

  def load_game
    puts 'This is the load_game method'
    @word = 'saved'
    @solution = @word.split(//)
    @available_letters = ('b'..'y').to_a
    @solved_letters = %w[_ a _ _ _]
    @incorrect_letters = ['z']
  end

  def random_word
    lines = IO.readlines('5desk.txt')
    random_number = rand * lines.length.to_i
    lines[random_number]
  end

  def word_selection
    loop do
      @word = random_word.strip!
      break if @word.length.between?(5, 12)
    end
    @solution = @word.split(//)
  end

  def create_solved_blanks
    @solution.each { @solved_letters << '_' }
    puts display_word_size
  end

  def update_solved_letters
    @solution.each_with_index do |item, index|
      @solved_letters[index] = item if item.match(@letter_regex)
    end
  end

  def player_turns
    loop do
      puts display_letter_spaces(@solved_letters.join)
      turn_prompts
      player_guess
      update_solved_letters
      @available_letters.delete(@player_guess.downcase)
      break if game_over? || game_solved?
    end
  end

  def user_input(prompt, regex)
    loop do
      print prompt
      input = gets.chomp
      input.match(regex) ? (return input) : print(display_input_warning)
    end
  end

  def turn_prompts
    puts display_incorrect_list unless @incorrect_letters.empty?
    puts display_last_turn_warning if @incorrect_letters.length == 7
  end

  def player_guess
    loop do
      @player_guess = user_input(display_turn_prompt, /^[a-z]$/i)
      break if @available_letters.include?(@player_guess.downcase)

      puts display_turn_error
    end
    @letter_regex = /#{@player_guess}/i
    incorrect_guess unless @word.match(@letter_regex)
  end

  def incorrect_guess
    @incorrect_letters << @player_guess.downcase
    puts display_incorrect_guess
  end

  def game_over?
    @incorrect_letters.length == 8
  end

  def game_solved?
    @solved_letters.all? { |item| item.match?(/[a-z]/i) }
  end
end
