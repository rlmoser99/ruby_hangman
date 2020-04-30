# frozen_string_literal: true

# Contains methods to save or load a game
module Database
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

  def load_game
    file = YAML.safe_load(File.read("output/#{saved_file}"))
    @word = file['word']
    @solution = word.split(//)
    @available_letters = file['available_letters']
    @solved_letters = file['solved_letters']
    @incorrect_letters = file['incorrect_letters']
  rescue StandardError
    puts "\nLoading game failed.\n\n"
    puts 'Would you like to play again?'
  end
end
