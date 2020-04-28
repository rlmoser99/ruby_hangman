# frozen_string_literal: true

require './display'

# Game class is the base of hangman logic
class Game
  include Display

  def play
    @available_letters = ('a'..'z').to_a
    @solved_letters = []
    @incorrect_letters = []
    puts display_instructions
    word_selection
    create_solved_blanks
    player_turns
    puts display_reveal_word if @incorrect_letters.length == 8
    puts display_won_game if game_solved?
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
      turn_prompts
      player_guess
      update_solved_letters
      @available_letters.delete(@player_guess.downcase)
      break if game_over? || game_solved?
    end
  end

  def turn_prompts
    puts display_turn_prompt
    puts display_incorrect_list unless @incorrect_letters.empty?
    puts display_last_turn_warning if @incorrect_letters.length == 7
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
  end

  def game_over?
    @incorrect_letters.length == 8
  end

  def game_solved?
    @solved_letters.all? { |item| item.match?(/[a-z]/i) }
  end
end
