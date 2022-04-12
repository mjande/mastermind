# Colors: Blue, Yellow, Green, Purple, Orange, Red
# Feedback Colors: White (correct color but wrong spot),
# Black (correct color and correct spot)

BLUE = '  blue  '
YELLOW = ' yellow '
GREEN = ' green  '
PURPLE = ' purple '
ORANGE = ' orange '
RED = '  red   '

# Game: handles gameplay methods and stuff that doesn't fit into other classes
class Game
  attr_accessor :player, :computer, :board
  
  def initialize
    @player = Player.new
    @computer = Computer.new
    puts 'Generating secret code...'
    @board = GameBoard.new
    puts 'Generating game board...'
    puts '||--------------------||'
    puts "||-----Let's Play-----||"
    puts '||-----Mastermind!----||'
    puts '||--------------------||'
    play_round(1)
  end

  def play_round(round)
    puts "Guess ##{round}!"
    guess = player.input_guess
    feedback = computer.check_guess(guess)
    board.update_board(round, guess, feedback)
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
    board[round][2] = feedback
    display_board
  end

  def display_board
    board.each do |row|
      print row[0]
      row[1].each { |color| print color } unless row[1].nil?
      puts ''
      print '   ' unless row[1].nil?
      row[2].each { |color| print color } unless row[2].nil?
    end
  end
end

# methods: prompt for input, accept input, win message
class Player
  attr_accessor :guess

  def input_guess
    puts 'b = blue, y = yellow, g = green, p = purple, o = orange, r = red'
    puts 'Type four letters and press enter to submit your guess.'
    guess = gets.chomp.split('')
    convert_color(guess)
    if guess.any?('ERROR')
      puts 'Error: please enter one of the letters shown above.'
      input_guess
    else
      guess
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
  attr_accessor :secret_code
  
  def initialize
    generate_secret_code
  end

  def generate_secret_code
    secret_code = []
    colors = [BLUE, YELLOW, GREEN, PURPLE, ORANGE, RED]
    4.times do |num|
      secret_code[num] = colors.sample
    end
    @secret_code = secret_code
  end

  def check_guess(guess)
    feedback = ['------ ', ' ------ ', ' ------ ', ' ------ ']
    guess.each_with_index do |color, i|
      if color == secret_code[i]
        feedback[i] = ' black  '
      elsif secret_code.include?(color)
        feedback[i] = ' white  '
      end
    end
    feedback.shuffle
  end
end

Game.new
