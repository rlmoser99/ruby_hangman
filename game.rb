# frozen_string_literal: true

# Game class is the base of hangman logic
class Game
  def play
    puts 'The random word for this game is:'
    word_selection
    display_blanks
    player_turn
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
    print @solution
    puts ''
  end

  def display_blanks(letter = nil)
    @solution.each do |item|
      print '_' if item != letter
      print letter if item == letter
    end
    puts ''
  end

  def player_turn
    @available_letters = ('a'..'z').to_a
    player_guess
    display_blanks(@player_guess)
    @available_letters.reject! { |letter| letter == @player_guess }
    # need to downcase/upcase guesses, available & word
    print @available_letters
    puts ''
  end

  def player_guess
    puts 'Guess a letter'
    loop do
      @player_guess = gets.chomp
      break if @player_guess.length == 1 &&
               @available_letters.include?(@player_guess.downcase)

      puts 'You guess should only be 1 letter that has not been guessed.'
    end
  end
end
