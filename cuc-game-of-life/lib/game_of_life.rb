class Board
  attr_accessor :width, :height
  def initialize(width,height)
    @width,@height = width, height
    Array(height){
      Array(width){
        "dog"
      }
    }
  end
end
class Game
  attr_reader :board
  def initialize(width,height)
    @board = Board.new(width,height)
  end
  def set_cell_state(row_index,column_index,cell_alive)
  end
  def next_state
    self
  end
  def alive_at?(x,y)
    false
  end
end
