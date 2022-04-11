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
    @board = Gameboard.new
    puts 'Generating game board...'
    puts '||--------------------||'
    puts "||-----Let's Play-----||"
    puts '||-----Mastermind!----||'
    puts '||--------------------||'
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
  
  def initialize; end
end

# data: secret code
# methods: generate code, check code
class Computer
  def initialize
    secret_code = []
    colors = [' blue ', 'yellow', 'green ', 'purple', 'orange', ' red  ']
    4.times do |num|
      secret_code[num] = colors.sample
    end
  end
end

newgame = Game.new
