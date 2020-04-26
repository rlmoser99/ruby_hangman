# frozen_string_literal: true

# Contains any text content for the the game
module TextContent
  def turn_message(message)
    {
      'incorrect' => "Except for: #{@rejected_letters.join(' ')}",
      'error' => 'You guess should only be 1 letter that has not been guessed.'
    }[message]
  end

  def game_message(message)
    {
      guess: <<~HEREDOC,

        Your turn to guess a letter.
        You have #{@turns_remaining} incorrect guesses remaining!
      HEREDOC
      instructions: <<~HEREDOC

        How to play Hangman in the console.

        A random word with 5-12 letters will be chosen. On each turn, you can guess one letter. To win, you must find all the letters in the word before using 8 incorrect guesses.

      HEREDOC
    }[message]
  end
end
