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

      Your turn to guess a letter. You have #{@turns_remaining} incorrect guesses remaining.
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
      You have already guessed: \e[31m#{@incorrect_letters.join(' ')}\e[0m
    HEREDOC
  end

  def display_letter_spaces(string)
    "\e[34;1m#{string}\e[0m"
  end

  def display_reveal_word
    <<~HEREDOC

      The word that you were trying to solve was: \e[34m#{@word}\e[0m
                           \e[31m¯\\_(ツ)_/¯\e[0m

    HEREDOC
  end

  def display_won_game
    <<~HEREDOC

      \e[34mCONGRATULATIONS! Yon won!\e[0m
      You figured out the word with #{@turns_remaining} incorrect guesses remaining!

    HEREDOC
  end
end
