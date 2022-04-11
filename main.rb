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
    puts "Generating secret code..."
    @board = Gameboard.new
    puts "Generating game board..."
    puts '||--------------------||'
    puts "||-----Let's Play-----||"
    puts '||-----Mastermind!----||'
    puts '||--------------------||'
  end
end

class GameBoard
  attr_accessor :board
  # data: 12X4 rows for guesses + 4 spots for guess feedback
  # methods: create board, update board, display rows, display feedback 
  def initialize 
    board = Array.new()
    @board = board
  end
end

class Player
  # methods: prompt for input, accept input, win message
  def initialize 
  end 
end

class Computer
  # data: secret code
  # methods: generate code, check code
  def initialize 
  end
end

newgame = Game.new
