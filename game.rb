# frozen_string_literal: true

# Game class is the base of hangman logic
class Game
  def play
    puts 'The random word for this game is:'
    select_word
  end

  def random_word
    lines = IO.readlines('5desk.txt')
    random_number = rand * lines.length.to_i
    lines[random_number]
  end

  def select_word
    loop do
      @word = random_word
      break if @word.length >= 5 && @word.length <= 12
    end
    puts @word
  end
end
