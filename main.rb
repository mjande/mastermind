# Colors: Blue, Yellow, Green, Purple, Orange, Red
# Feedback Colors: White (correct color but wrong spot),
# Black (correct color and correct spot)
class Game
  BLUE = ' blue '
  YELLOW = 'yellow'
  GREEN = 'green '
  PURPLE = 'purple'
  ORANGE = 'orange'
  RED = ' red  '
  
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
    @player.input_guess
  end
end

# data: 12X4 rows for guesses + 4 spots for guess feedback
# methods: create board, update board, display rows, display feedback
class GameBoard
  attr_accessor :board

  def initialize
    board = []
    @board = board
  end
end

# methods: prompt for input, accept input, win message
class Player
  attr_accessor :guess

  def initialize
    @guess = ''
  end

  def input_guess
    puts 'B = blue, Y = yellow, G = green, P = purple, O = orange, R = red'
    puts 'Type four letters and press enter to submit your guess.'
    guess = gets.chomp.split('')
    if guess.any?('ERROR')
      puts "Error: please enter one of the letters shown above."
      input_guess
    else 
      @guess = guess
    end
  end

  def convert_color(array)
    guess.map! do |color_code|
      case color_code
      when 'b' || 'B'
        color_code = BLUE
      when 'y' || 'Y'
        color_code = YELLOW
      when 'g' || 'G'
        color_code = GREEN
      when 'p' || 'P'
        color_code = PURPLE
      when 'o' || 'O'
        color_code = ORANGE
      when 'r' || 'R'
        color_code = RED
      else 
        color_code = 'ERROR'
        
        break
      end
    end
  end
end

# data: secret code
# methods: generate code, check code
class Computer
  def initialize
    generate_secret_code
  end

  def generate_secret_code
    secret_code = []
    colors = [BLUE, YELLOW, GREEN, PURPLE, ORANGE, RED]
    4.times do |num| 
    secret_code[num] = colors.sample
    @secret_code = secret_code
    end
  end
end

Game.new
