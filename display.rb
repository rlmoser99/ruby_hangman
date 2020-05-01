# frozen_string_literal: true

# Contains any text content for the the game
module Display
  def display_word_size
    <<~HEREDOC
      \e[34mYour random word has been chosen, it has #{@solution.length} letters:\e[0m

    HEREDOC
  end

  def display_last_turn_warning
    <<~HEREDOC
      \e[31mThink carefully, this could be your last chance to win.\e[0m
    HEREDOC
  end

  def display_turn_error
    <<~HEREDOC
      \e[31mYou guess should only be 1 letter that has not been guessed.\e[0m
    HEREDOC
  end

  def display_turn_prompt
    <<~HEREDOC
      Your turn to guess one letter in the secret word.
      You can also type 'save' or 'exit' to leave the game.
    HEREDOC
  end

  def display_instructions
    <<~HEREDOC

      How to play Hangman in the console.

      A random word with 5-12 letters will be chosen. On each turn, you can guess one letter. To win, you must find all the letters in the word before using 8 incorrect guesses.

    HEREDOC
  end

  def display_incorrect_list
    <<~HEREDOC

      You have already guessed: \e[31m#{incorrect_letters.join(' ')}\e[0m
    HEREDOC
  end

  def display_letter_spaces(string)
    <<~HEREDOC

      \e[34;1m#{string}\e[0m


    HEREDOC
  end

  def display_reveal_word
    <<~HEREDOC

      The word that you were trying to solve was: \e[34m#{@solution.join}\e[0m

      \e[31m¯\\_(ツ)_/¯\e[0m

    HEREDOC
  end

  def display_won_game
    <<~HEREDOC

      \e[34;1m#{word}\e[0m

      CONGRATULATIONS! You figured out the secret word, with #{8 - incorrect_letters.length} incorrect guess(es) remaining!

    HEREDOC
  end

  def display_start
    <<~HEREDOC
      Let's play hangman in the console! Would you like to:

      \e[34m[1]\e[0m Play a new game
      \e[34m[2]\e[0m Load a saved game

    HEREDOC
  end

  def display_input_warning
    <<~HEREDOC
      \e[31mSorry, that is an invalid answer. Please, try again.\e[0m

    HEREDOC
  end

  def display_incorrect_guess
    <<~HEREDOC
      Sorry, '#{@player_guess}' is not in the secret word.
      You have #{8 - incorrect_letters.length} incorrect guess(es) left.

    HEREDOC
  end

  def display_saved_name
    <<~HEREDOC
      Your game is now saved. The name of the game is: \e[34m#{@filename}\e[0m

    HEREDOC
  end

  def display_saved_games(number, name)
    <<~HEREDOC

      \e[34m[#{number}]\e[0m #{name}
    HEREDOC
  end

  def display_saved_prompt
    <<~HEREDOC

      Enter the game \e[34m[#]\e[0m that you would like to play.
      You can also type 'exit' to leave the game.

    HEREDOC
  end

  def display_load_error
    <<~HEREDOC

      There was either an error while loading the game, or you wanted to exit the game.

    HEREDOC
  end

  def display_play_again
    <<~HEREDOC

      Would you like to play again?

      \e[34m[1]\e[0m yes
      \e[34m[2]\e[0m no

    HEREDOC
  end

  def display_thanks
    <<~HEREDOC

      \e[34mThanks for playing Hangman!\e[0m

    HEREDOC
  end
end
