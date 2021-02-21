class Player
  def initialize; end

  def choose_letter(guessed_letters)
    puts "\nWhat's your next guess? Or type 'save' to save the game.\n\n"
    letter = nil

    loop do
      letter = gets.chomp.gsub(/\s+/, '').downcase

      if guessed_letters.include?(letter)
        puts "\nYou already guess that letter. Choose another one:\n\n"
      elsif (letter.length == 1 && letter.match?(/[[:alpha:]]/)) || letter == 'save'
        break
      else
        puts "\nYour guess must be one letter. Make your choice:\n\n"
      end
    end

    letter
  end
end
