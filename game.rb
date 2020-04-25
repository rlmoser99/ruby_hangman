# frozen_string_literal: true

# Game class is the base of hangman logic
class Game
  def play
    puts 'play in Game'
    select_word
  end

  def random_word
    lines = IO.readlines('5desk.txt')
    random_number = rand * lines.length.to_i
    lines[random_number]
  end

  def select_word
    word = random_word
    puts word if word.length >= 5 && word.length <= 12
  end
end
