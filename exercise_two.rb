 # 1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
 # 2. Any live cell with more than three live neighbours dies, as if by overcrowding.
 # 3. Any live cell with two or three live neighbours lives on to the next generation.
 # 4. Any dead cell with exactly three live neighbours becomes a live cell.
class Cell
  DeathNumber = 3
  DeathThreshold = 2
  LifeNumber = 3

  def initialize(seed)
    @alive = seed > rand
  end
  def alive?
    @alive
  end
  def to_s
   alive? ? "O" : " "
  end
  def to_i
    alive? ? 1 : 0
  end
  def next_state!(alive_neighbor_count)
    if alive?
      @alive = false if (alive_neighbor_count < DeathThreshold) || (alive_neighbor_count >DeathNumber)
    else
      @alive = true if alive_neighbor_count == LifeNumber
    end
  end
end

class Game
  # Make a grid of cells
  def initialize(width,height,seed,steps)
    @width,@height,@seed,@steps = width, height, seed, steps
    @grid = Array.new(@height){
      Array.new(@width){
        Cell.new(@seed)
      }
    }
  end
  # draw the grid, showing the state of each cell
  def draw
    @grid.each do |row|
      puts row.map{|cell|
        cell.to_s
      }.join("")
    end
  end
  # draw the grid as many times as specified when the game started (@steps)
  def play
    draw
    @steps.times do 
       next_state
       `clear`
       draw
     end
  end
  # there are 8 possible postions for any cell in a grid
  def possible_neighbors(y,x)
    # (-1..1).to_a.map do |row_offset|
      # (-1..1).to_a.map do |col_offset|
        # return y - row_offset, x - col_offset
      # end
    # end
    up = y-1
    down = y + 1
    my_row = y
    left = x - 1
    right = x + 1
    my_column = x

    [
      [my_row,x-1],[y,x+1], # sides
      [up,x-1], [y-1,x], [y-1,x+1], # top
      [down,x-1], [y+1,x], [y+1,x+1]  # bottom
    ]
  end

  def next_state
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell = @grid[y][x]
        cell_coords = [y,x]
        neighbors = get_neighbors(possible_neighbors(y,x), cell_coords)
        num_active_neighbors = count_active_neighbors(neighbors)
        cell.next_state!(num_active_neighbors)
      end
    end
  end
  def get_neighbors(possible_neighbors,cell_coords)
    possible_neighbors.select do |neighbor_coords|
      off_grid? neighbor_coords
    end
  end

  def off_grid?(coords)
    y,x = coords[0], coords[1]
    (y >= 0) && (x >= 0) && (x < @width) && (y < @height)
  end

  def count_active_neighbors(neighbors)
    # take my neighbors, select the active, count them
    neighbors.inject(0) do |sum,coords|
      sum + @grid[coords[0]][coords[1]].to_i
    end
  end
end

game = Game.new(100,100,0.1,100)
game.play

