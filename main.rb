require_relative 'game'
require_relative 'display'
require_relative 'database'

Display.welcome

loop do
  option = nil

  loop do
    option = Display.option

    break if %w[1 2].include?(option)
  end

  option == '1' ? Game.new.start : Game.new.load
  break unless Display.continue?
end

Display.conclusion
Database.restore_saved_files
