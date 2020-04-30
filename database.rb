# frozen_string_literal: true

# Contains methods to save or load a game
module Database
  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    game_count = Dir.glob('output/**/*.yaml').count
    @filename = "Game_#{game_count + 1}.yaml"
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

  def saved_file
    show_file_list
    file_number = user_input(display_saved_prompt, /\d+/)
    file_list[file_number.to_i - 1]
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
      files << name if name.match(/(Game)/)
    end
    sorted_files = files.sort_by do |file|
      file.scan(/\d+/).map(&:to_i)
    end
    sorted_files
  end

  def load_game
    file = YAML.safe_load(File.read("output/#{saved_file}"))
    @word = file['word']
    @solution = word.split(//)
    @available_letters = file['available_letters']
    @solved_letters = file['solved_letters']
    @incorrect_letters = file['incorrect_letters']
    player_turns
    end_game
  rescue StandardError
    puts display_load_error
  end
end
