module Database
  def self.restore_saved_files
    data = {
      secret_word:  'itinerancy',
      correct_letters: ['i', 'n', 'a', 'y', 't', 'e'],
      wrong_letters: ['s', 'o']
    }
    File.open('./saved_games/almost_there.json', 'w') { |f| f.write(data.to_json) }

    data = {
      secret_word: 'paganism',
      correct_letters: ['a', 'i', 's'],
      wrong_letters: ['e', 'o', 't']
    }
    File.open('./saved_games/my_first_game.json', 'w') { |f| f.write(data.to_json) }

    data = {
      secret_word: 'zydeco',
      correct_letters: ['e', 'd', 'o'],
      wrong_letters: ['a', 'i', 's', 't', 'w', 'n']
    }
    File.open('./saved_games/too_difficult.json', 'w') { |f| f.write(data.to_json) }
  end
end
