# Colors: Blue, Yellow, Green, Purple, Orange, Red
# Feedback Colors: White (correct color but wrong spot),
# Black (correct color and correct spot)

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
    feedback = computer.check_guess(guess)
    board.update_board(round, guess, feedback)
    end_human_game(feedback, round)
  end

  def play_computer_round(round)
    guess = computer.input_guess(round)
    feedback = computer.check_guess(guess)
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
  attr_accessor :secret_code, :feedback, :possible_guesses

  def generate_secret_code
    secret_code = []
    colors = [BLUE, YELLOW, GREEN, PURPLE, ORANGE, RED]
    4.times do |num|
      secret_code[num] = colors.sample
    end
    @secret_code = secret_code
  end

  def store_player_code(secret_code)
    @secret_code = secret_code
    @possible_guesses = (1111..6666).to_a
  end

  def input_guess
    case feedback
    when nil
      guess = 1122
    when [0,0]
      
  end


  def check_guess(guess)
    num_of_black = 0
    num_of_white = 0
    colors = [BLUE, YELLOW, GREEN, PURPLE, ORANGE, RED]
    colors.each do |color|
      if secret_code.include?(color)
        secret_code_color = secret_code.count(color)
        guess.each_index do |i|
          if guess[i] == color && secret_code[i] == color
            num_of_black += 1
            secret_code_color -= 1
          end
        end
        while secret_code_color.positive?
          num_of_white += 1 if guess.count(color) >= secret_code_color
          secret_code_color -= 1
        end
      end
    end
    @internal_feedback = [num_of_black, num_of_white]
  end
end

def play_again?
end

Game.new