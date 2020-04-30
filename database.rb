# frozen_string_literal: true

# Contains methods to save or load a game
module Database
  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    @filename = "#{random_name}_game.yaml"
    File.open("output/#{@filename}", 'w') { |file| file.write save_to_yaml }
    puts display_saved_name
  end

  def save_to_yaml
    YAML.dump(
      'word' => @word,
      'available_letters' => @available_letters,
      'solved_letters' => @solved_letters,
      'incorrect_letters' => @incorrect_letters
    )
  end

  def random_name
    adjective = %w[red best dark fun blue cold last tiny new pink]
    nouns = %w[car hat star dog tree foot cake moon key rock]
    "#{adjective[rand(0 - 9)]}_#{nouns[rand(0 - 9)]}_#{rand(11..99)}"
  end

  def find_saved_file
    show_file_list
    file_number = user_input(display_saved_prompt, /\d+|^exit$/)
    @saved_game = file_list[file_number.to_i - 1] unless file_number == 'exit'
  end

  def show_file_list
    puts display_saved_games('#', 'File Name(s)')
    file_list.each_with_index do |name, index|
      puts display_saved_games((index + 1).to_s, name.to_s)
    end
  end

  def file_list
    files = []
    Dir.entries('output').each do |name|
      files << name if name.match(/(game)/)
    end
    files
  end

  def load_game
    find_saved_file
    load_saved_file
    File.delete("output/#{@saved_game}") if File.exist?("output/#{@saved_game}")
    player_turns
    end_game
  rescue StandardError
    puts display_load_error
  end

  def load_saved_file
    file = YAML.safe_load(File.read("output/#{@saved_game}"))
    @word = file['word']
    @solution = word.split(//)
    @available_letters = file['available_letters']
    @solved_letters = file['solved_letters']
    @incorrect_letters = file['incorrect_letters']
  end
end
