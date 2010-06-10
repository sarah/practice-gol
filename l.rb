class Cell
  attr_accessor :state, :next_state
  DeathNumber = 3
  LifeNumber  = 3
  DeathThreshold = 2

  def initialize(state)
    @alive = state == "alive" ? true : false
  end
  def evolve!
    next_state.call    
  end
  def alive?
    @alive
  end
  def to_s
    alive? ? "0" : " "
  end
  def to_i
    alive? ? 1 : 0
  end
  def next_state!(alive_neighbor_count)
    # puts "in next_state!. alive: #{alive?}. alive_neighbor_count: #{alive_neighbor_count}. @alive : #{@alive}"
    if alive?
      @alive = false if (alive_neighbor_count < DeathThreshold) || (alive_neighbor_count > DeathNumber)
    else
      @alive = true if alive_neighbor_count == LifeNumber
    end 
    # puts "alive now: #{@alive}"
    # puts "    "
  end
end
class Game
  def initialize(width,height,seed,steps)
    @steps = steps
    @colony = Colony.new(width,height,seed)
  end
  def play
    @steps.times do |i|
      # puts "Time: #{i}"
      @colony.draw
      `clear`
      @colony.prepare
      @colony.evolve
    end
  end
end
class Colony
  def initialize(width,height,seed)
    @width, @height = width, height
    @cells = Array.new(height){
     Array.new(width){
       Cell.new(seed > rand ? "alive" : "dead")
      }
    } 
  end
  def draw
    @cells.each do |row|
      puts row.map{|cell|
        cell.to_s
      }.join("")
    end
  end
  def prepare
    @cells.each_with_index do |row,y|
      row.each_with_index do |cell,x|
        cell = @cells[y][x]
        cell_coords = [y,x]
        neighbors = get_neighbors(y,x)
        active_neighbors = count_alive_neighbors(neighbors)
        cell.next_state = lambda{cell.next_state!(active_neighbors)}
        # puts "me: #{cell_coords.inspect} : neighbors : #{neighbors.inspect}"
        # puts "I have #{active_neighbors} active_neighbors"
        # puts "---------------"
      end
    end
  end
  def evolve
    @cells.each_with_index do |row,y|
      row.each_with_index do |cell,x|
        cell.evolve!
      end
    end
  end
  
  private
  def count_alive_neighbors(neighbors)
    neighbors.inject(0) do |sum,coords|
      cell = @cells[coords[0]][coords[1]]
      sum  + cell.to_i
    end
  end

  def possible_neighbors(y,x)
    up      = y-1
    down    = y+1
    my_row  = y
    left    = x-1
    right   = x+1
    my_column = x
    [
      [up,left], [up,my_column], [up,right], #top
      [my_row, left], [my_row, right], # sides
      [down, left], [down, my_column], [down, right] # bottom 
    ]
  end
  def get_neighbors(y,x)
    possible_neighbors(y,x).select do |neighbor_coords|
      on_grid?(neighbor_coords)
    end
  end
  def on_grid?(coords)
    # puts "in on_grid, coords: #{coords.inspect}"
    y,x = coords[0], coords[1]
    (y>=0) && (x >= 0) && (x < @width) && (y < @height)
  end
end

# game = Game.new(4,4,0.2,2)
game = Game.new(50,50,0.1,200)
game.play
# c = Cell.new("dead")
# puts c.state
# c.next_state = lambda{1==1 ? "alive" : "dead"}
# puts c.state
# c.evolve
# c.next_state = lambda{1==1 ? "dead" : "alive"}
# puts c.state
# c.evolve
# puts c.state
