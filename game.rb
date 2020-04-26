# frozen_string_literal: true

# Game class is the base of hangman logic
class Game
  def play
    @available_letters = ('a'..'z').to_a
    @display = []
    @turns_remaining = 8
    @rejected_letters = []
    puts 'The random word for this game is:'
    word_selection
    display_blanks
    player_turns
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
    puts @word
    word_array = @word.split(//)
    @solution = word_array[0..word_array.length - 3]
    # print @solution
    # puts ''
  end

  def display_blanks
    @solution.each { @display << '_' }
    puts @display.join
  end

  def display_word(letter)
    @solution.each_with_index do |item, index|
      @display[index] = item if item.include?(letter.downcase || letter.upcase)
    end
    puts @display.join
  end

  def player_turns
    loop do
      puts "Guess a letter. You have #{@turns_remaining} bad guesses left"
      unless @rejected_letters.empty?
        puts "Except for: #{@rejected_letters.join(' ')}"
      end
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

      puts 'You guess should only be 1 letter that has not been guessed.'
    end
    @turns_remaining -= 1 unless @solution.include?(@player_guess)
    @rejected_letters << @player_guess unless @solution.include?(@player_guess)
  end

  # Bug: If word has capital letter, the guessed lowercase letter does not work to solve it.

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
