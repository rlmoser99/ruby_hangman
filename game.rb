# frozen_string_literal: true

require './display'
require 'yaml'

# Game class is the base of hangman logic
class Game
  attr_accessor :word, :available_letters, :solved_letters, :incorrect_letters
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
    end_game
  end

  def new_game
    loop do
      @word = random_word.strip!
      break if @word.length.between?(5, 12)
    end
    @solution = @word.split(//)
    create_solved_blanks
  end

  def random_word
    lines = IO.readlines('5desk.txt')
    random_number = rand * lines.length.to_i
    lines[random_number]
  end

  def load_game
    file = YAML.safe_load(File.read("output/#{saved_file}"))
    @word = file['word']
    @solution = @word.split(//)
    @available_letters = file['available_letters']
    @solved_letters = file['solved_letters']
    @incorrect_letters = file['incorrect_letters']
  rescue StandardError
    puts "\nLoading game failed.\n\n"
    puts 'Would you like to play again?'
  end

  def create_solved_blanks
    @solution.each { @solved_letters << '_' }
    puts display_word_size
  end

  def update_solved_letters
    @solution.each_with_index do |item, index|
      solved_letters[index] = item if item.match(@letter_regex)
    end
  end

  def player_turns
    loop do
      puts display_letter_spaces(@solved_letters.join)
      player_guess
      break if @player_guess == 'exit'
      break if @player_guess == 'save'

      incorrect_guess unless @word.match(@letter_regex)
      update_solved_letters
      @available_letters.delete(@player_guess.downcase)
      break if game_over? || game_solved?
    end
    save_game if @player_guess == 'save'
  end

  def user_input(prompt, regex)
    loop do
      print prompt
      input = gets.chomp
      input.match(regex) ? (return input) : print(display_input_warning)
    end
  end

  def player_guess
    loop do
      optional_turn_info
      @player_guess = user_input(display_turn_prompt, /^[a-z]$|exit|save/i)
      break if @player_guess == 'exit'
      break if @player_guess == 'save'
      break if @available_letters.include?(@player_guess.downcase)

      puts display_turn_error
    end
    @letter_regex = /#{@player_guess}/i
  end

  def optional_turn_info
    puts display_incorrect_list unless @incorrect_letters.empty?
    puts display_last_turn_warning if @incorrect_letters.length == 7
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

  def end_game
    puts display_reveal_word if game_over?
    puts display_won_game if game_solved?
    puts 'Would you like to save your score and compare it to other scores?'
  end

  def save_game
    filename = "Saved_at_#{Time.now.strftime('%-I:%M:%S%p_on_%-m-%-d-%y')}.yaml"
    Dir.mkdir 'output' unless Dir.exist? 'output'
    File.open("output/#{filename}", 'w') { |file| file.write state_to_yaml }
    puts "Your game's name is: #{filename}"
  end

  def state_to_yaml
    YAML.dump(
      'word' => @word,
      'available_letters' => @available_letters,
      'solved_letters' => @solved_letters,
      'incorrect_letters' => @incorrect_letters
    )
  end

  def saved_file
    puts 'File number and file name:'
    file_list.each_with_index { |name, index| puts "[#{index + 1}] #{name}" }
    file_number = user_input('pick a file', /^[1-#{file_list.length}]$/).to_i
    file_list[file_number - 1]
  end

  def file_list
    files = []
    Dir.entries('output').each do |name|
      files << name if name.match(/(Saved_at)/)
    end
    files
  end
end
