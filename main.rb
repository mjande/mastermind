# Colors: Blue, Yellow, Green, Purple, Orange, Red
# Feedback Colors: White (correct color but wrong spot),
# Black (correct color and correct spot)

require 'pry-byebug'

BLUE = ' blue   '
YELLOW = ' yellow '
GREEN = ' green  '
PURPLE = ' purple '
ORANGE = ' orange '
RED = ' red    '

# Game: handles gameplay methods and stuff that doesn't fit into other classes
class Game
  attr_accessor :player, :computer, :board, :turn, :endgame

  def initialize
    @player = Player.new
    @computer = Computer.new
    @board = GameBoard.new
    @endgame = false
    puts '||--------------------||'
    puts "||-----Let's Play-----||"
    puts '||-----Mastermind!----||'
    puts '||--------------------||'
    gamemode = choose_game_mode
    play_game(gamemode)
  end

  def choose_game_mode
    puts 'Choose a gamemode! 1. Codebreaker 2. Codemaker'
    gamemode = gets.chomp
    unless gamemode.include?('1') || gamemode.include?('2')
      puts 'ERROR: Type 1 or 2'
      gamemode = gets.chomp
    end
    gamemode
  end

  def play_game(choice)
    turn = 1
    result = 0
    case choice
    when '1'
      computer.generate_secret_code
      until turn > 12 || result == 'endgame'
        result = play_human_round(turn)
        turn += 1
      end
    when '2'
      secret_code = player.input_secret_code
      computer.store_player_code(secret_code)
      until turn > 12 || result == 'endgame'
        result = play_computer_round(turn)
        turn += 1
      end
    end
  end

  def play_human_round(round)
    puts "Guess ##{round}!"
    guess = player.input_guess
    feedback = computer.check_guess(guess, computer.secret_code)
    board.update_board(round, guess, feedback)
    end_human_game(feedback, round)
  end

  def play_computer_round(round)
    guess = computer.generate_guess
    feedback = computer.check_guess(guess, computer.secret_code)
    computer.previous_feedback = feedback
    board.update_board(round, guess, feedback)
    end_computer_game(feedback, round)
  end

  def end_human_game(feedback, round)
    secret_code = computer.secret_code
    if feedback[0] == 4
      puts 'You win! Way to go!'
      puts "Secret code = #{secret_code}"
      'endgame'
    elsif round == 12
      puts 'Game over! Better luck next time!'
      puts "Secret code = #{secret_code}"
      'endgame'
    end
  end

  def end_computer_game(feedback, round)
    secret_code = computer.secret_code
    if feedback[0] == 4
      puts 'The computer won! Better luck next time!'
      puts "Secret code = #{secret_code}"
      'endgame'
    elsif round == 12
      puts 'You did it! You beat the computer!'
      puts "Secret code = #{secret_code}"
      'endgame'
    end
  end
end

# data: 12X4 rows for guesses + 4 spots for guess feedback
# methods: create board, update board, display rows, display feedback
class GameBoard
  attr_accessor :board

  def initialize
    board = []
    board[0] = ['||---------Mastermind!----------||']
    @board = board
  end

  def update_board(round, guess, feedback)
    board[round] = []
    board[round][0] = "#{round}."
    board[round][1] = guess
    board[round][2] = "Correct color and position: #{feedback[0]},
      \ncorrect color, wrong position: #{feedback[1]}. "
    display_board
  end

  def display_board
    board.each do |row|
      if row[1].nil?
        puts row[0]
        puts ' '
      elsif row[0].nil? == false
        print row[0]
        row[1].each { |color| print color }
        puts ''
        puts row[2]
        puts ' '
      end
    end
  end
end

# methods: prompt for input, accept input, win message
class Player

  def input_guess
    puts 'b = blue, y = yellow, g = green, p = purple, o = orange, r = red'
    puts 'Type four letters and press enter to submit your guess.'
    guess = gets.chomp.downcase.split('')
    convert_color(guess)
    if guess.length != 4
      puts 'Error: please enter four of the letters shown above.'
      input_guess
    elsif guess.any?('ERROR')
      puts 'Error: please enter four of the letters shown above.'
      input_guess
    else
      guess
    end
  end

  def input_secret_code
    puts 'b = blue, y = yellow, g = green, p = purple, o = orange, r = red'
    puts 'Type four letters and press enter to submit your secret code.'
    secret_code = gets.chomp.downcase.split('')
    convert_color(secret_code)
    if secret_code.length != 4
      puts 'Error: please enter four of the letters shown above.'
      input_secret_code
    elsif secret_code.any?('ERROR')
      puts 'Error: please enter four of the letters shown above.'
      input_secret_code
    else
      secret_code
    end
  end

  def convert_color(array)
    array.map! do |color_code|
      case color_code
      when 'b'
        BLUE
      when 'y'
        YELLOW
      when 'g'
        GREEN
      when 'p'
        PURPLE
      when 'o'
        ORANGE
      when 'r'
        RED
      else
        'ERROR'
      end
    end
  end
end

# data: secret code
# methods: generate code, check code
class Computer
  attr_accessor :secret_code, :previous_feedback, :possible_guesses, :previous_guess

  def initialize
    possible_guesses = (1111..6666).to_a
    possible_guesses.map! do |guess|
      guess.to_s.chars.map(&:to_i)
    end
    possible_guesses.reject! { |guess| guess.include?(0) }
    @possible_guesses = possible_guesses
    @previous_feedack = ['']
    @previous_guess = nil
  end

  def generate_secret_code
    secret_code = []
    4.times do |num|
      secret_code[num] = rand(1..6)
    end
    @secret_code = secret_code
  end

  def store_player_code(secret_code)
    secret_code_i = secret_code.map do |str|
      case str
      when BLUE
        1
      when YELLOW
        2
      when GREEN
        3
      when PURPLE
        4
      when ORANGE
        5
      when RED
        6
      end
    end
    @secret_code = secret_code_i
  end

  def generate_guess
    p previous_feedback
    if previous_feedback.nil?
      guess = [1, 1, 2, 2]
    else
      possible_guesses.delete(previous_guess)
      possible_guesses.select! do |possible_guess|
        check_guess(previous_guess, possible_guess) == previous_feedback
      end
      guess = minmax(possible_guesses)
    end
    @possible_guesses = possible_guesses
    @previous_guess = guess
    guess_to_s(previous_guess)
  end

  def minmax(possible_guesses)
    possible_score_totals = Hash.new(0)
    possible_guesses.each do |possible_guess|
      possible_score = check_guess(previous_guess, possible_guess)
      possible_score_totals[possible_score] += 1
    end
    p possible_score_totals
    best_score = possible_score_totals.min { |a, b| a[1] <=> b[1] }
    p best_score
    next_guess = (possible_guesses.find { |guess| check_guess(previous_guess, guess) == best_score[0] })
    p next_guess
    next_guess
  end

  def guess_to_i(str_array)
    guess_i = str_array.map do |str|
      case str
      when BLUE
        1
      when YELLOW
        2
      when GREEN
        3
      when PURPLE
        4
      when ORANGE
        5
      when RED
        6
      end
    end
    @guess = guess_i
  end

  def guess_to_s(int_array)
    guess_s = int_array.map do |int|
      case int
      when 1
        BLUE
      when 2
        YELLOW
      when 3
        GREEN
      when 4
        PURPLE
      when 5
        ORANGE
      when 6
        RED
      end
    end
    @guess = guess_s
  end

  def check_guess(guess, code)
    guess = guess_to_i(guess) if guess[0].instance_of? String
    num_of_black = 0
    num_of_white = 0
    colors = (1..6).to_a
    colors.each do |color|
      if code.include?(color)
        code_count = code.count(color)
        guess_color_count = guess.count(color)
        guess.each_index do |i|
          if guess[i] == color && code[i] == color
            num_of_black += 1
            code_count -= 1
            guess_color_count -= 1
          end
        end
        while code_count.positive?
          num_of_white += 1 if guess.count(color) >= code_count
          code_count -= 1
        end
      end
    end
    [num_of_black, num_of_white]
  end
end

def play_again?
end

Game.new

# To-do: fix guess conversion (Do I need to store as instance variable?)
# finish minmax algorithm