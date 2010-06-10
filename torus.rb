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
   alive? ? "o" : " "
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
  def neighbor_coords_for(y,x)
    [
      [y,x-1],[y,x+1], # sides
      [y-1,x-1], [y-1,x], [y-1,x+1], # top
      [y+1,x-1], [y+1,x], [y+1,x+1]  # bottom
    ]
  end
  # calculate whether each cell should be alive or dead and return new grid
  def next_state
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell = @grid[y][x]
        cell_coords = [y,x]
        # for torus, every neighbor is an active neighbor
        num_active_neighbors = neighbor_coords_for(y,x).inject(0) do |sum,pos|
          sum + @grid[pos[0]% @height][pos[1]% @width].to_i
        end
        # puts "i am at #{[y,x].inspect} and I have #{num_active_neighbors} neighbors"
        cell.next_state!(num_active_neighbors)
      end
    end
  end
end

game = Game.new(100,100,0.1,100)
game.play

