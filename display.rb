module Display
  def self.welcome
    puts "\nHi, welcome to Hangman!"
  end

  def self.option
    option = nil

    loop do
      puts "\nType 1 for a new game or 2 to load a saved game:\n\n"
      option = gets.chomp.gsub(/\s+/, '')
      break if %w[1 2].include?(option)

      puts "\nThat's not a valid option."
    end

    option
  end

  def self.continue?
    puts "\nWhat a nice game. Type \'y\' and go for the revange or any key to quit.\n\n"
    gets.chomp.gsub(/\s+/, '').downcase == 'y'
  end

  def self.conclusion
    puts "\nGoodbye!\n\n"
  end
end
