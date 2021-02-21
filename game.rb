require_relative 'string_effects'
require_relative 'player'
require 'json'

class Game
  MAX_MISSINGS = 8
  MIN_CHARACTERS = 5
  MAX_CHARACTERS = 12
  FILE_PATH = '5desk.txt'
  DIR_PATH = './saved_games/'
  EXT = '.json'

  def initialize
    @player = Player.new
    @game_saved = false
  end

  def start
    @word = random_word
    @correct_letters = []
    @wrong_letters = []

    play
  end

  def load
    saved_game = choose_saved_game
    data = JSON.parse(File.read(saved_game))
    @word = data['secret_word']
    @correct_letters = data['correct_letters']
    @wrong_letters = data['wrong_letters']
    File.delete(saved_game)
    print_status

    play
  end

  private

  def random_word
    file = File.open(FILE_PATH)
    file_data = file.readlines.map(&:chomp)
    word = get_valid_word(file_data)

    print "\nComputer is choosing the secret word."
    5.times do
      sleep(0.3)
      print '.'
    end

    puts " The computer choose the word to guess, it's #{word.length} length. #{word}"
    word
  end

  def get_valid_word(file_data)
    word = file_data[rand(0..file_data.length - 1)]

    loop do
      break if word.length.between?(MIN_CHARACTERS, MAX_CHARACTERS)

      word = file_data[rand(0..file_data.length - 1)]
    end

    word.downcase
  end

  def choose_saved_game
    saved_games = show_saved_games
    puts "\nType the name of the game you want to load:\n\n"
    name = gets.chomp

    loop do
      break if saved_games.include?(name)

      puts "\nThat's not a valid name. Choose another one:\n\n"
      name = gets.chomp
    end

    DIR_PATH + name
  end

  def show_saved_games
    saved_games = Dir.entries('saved_games')[2..-1]
    puts "\n"
    saved_games.each { |name| puts name }

    saved_games
  end

  def play
    play_round until end_game?

    if @wrong_letters.length == MAX_MISSINGS
      puts "\n#{'You died!'.bold.blink} The correct word was #{@word}."
    elsif win_game?
      puts "\nBut that's enough.. #{'You survived!'.bold.blink}"
    end
  end

  def end_game?
    win_game? || @wrong_letters.length == MAX_MISSINGS || @game_saved
  end

  def win_game?
    (@word.split('') - @correct_letters).empty?
  end

  def play_round
    letter = @player.choose_letter(@correct_letters + @wrong_letters)
    if letter == 'save'
      @game_saved = true
      save_game
    else
      compute_letter(letter)
      print_status
    end
  end

  def save_game
    name = choose_valid_name
    create_and_save(name)
  end

  def choose_valid_name
    puts "\nChoose the name with which to save the game (you can use letters, numbers, '-', '_' and not white spaces):\n\n"
    name = gets.chomp.gsub(/\s+/, '')

    loop do
      break unless wrong_name?(name)

      name = gets.chomp.gsub(/\s+/, '')
    end

    name
  end

  def wrong_name?(name)
    if name.match?(/[^A-Za-z0-9_-]/)
      puts "\nThat name has invalid characters. Choose anothe one:"
    elsif Dir.entries('saved_games')[2..-1].include?(name + EXT)
      puts "\nThat name already exists. Choose anothe one:"
    end

    name.match?(/[^A-Za-z0-9_-]/) || Dir.entries('saved_games')[2..-1].include?(name + EXT)
  end

  def create_and_save(name)
    @game_saved = true
    data = {
      secret_word: @word,
      correct_letters: @correct_letters,
      wrong_letters: @wrong_letters
    }
    File.open("./saved_games/#{name}.json", 'w') { |f| f.write(data.to_json) }
    puts "\nYour game was saved with the name #{name + EXT}"
  end

  def compute_letter(letter)
    if @word.include?(letter)
      @correct_letters << letter
    else
      @wrong_letters << letter
    end
  end

  def print_status
    green_letters = @correct_letters.map { |letter| "\e[32m#{letter}\e[0m" }
    red_letters = @wrong_letters.map { |letter| "\e[31m#{letter}\e[0m" }

    all_letters = green_letters + red_letters
    puts "\n#{all_letters.join(' ')}"

    partial_word = @word.split('').reduce('') do |result, letter|
      result + (@correct_letters.include?(letter) ? "#{letter}" : '_')
    end
    puts "\n#{partial_word}"

    puts "\nYou still have #{MAX_MISSINGS - @wrong_letters.length} incorrect guesses."
  end
end
