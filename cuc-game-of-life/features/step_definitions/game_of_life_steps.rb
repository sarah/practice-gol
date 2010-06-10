def cell_alive?(with_this_representation)
  with_this_representation == 'x'
end

def load_initial_state(board)
  width = board.length
  height = board[0].length
  game = Game.new width, height
  board.each_with_index do |row, row_index|
    row.each_with_index do |cell_state, column_index|
      game.set_cell_state row_index, column_index, cell_alive?(cell_state)
    end
  end
  game
end

Given /^the following setup$/ do |board|
  @game = load_initial_state(board.raw)
  puts "game board: #{@game.board.inspect}"
end

When /^I evolve the board$/ do
  @game = @game.next_state
end

Then /^the center cell should be dead$/ do
  @game.alive_at?(1, 1).should be_false
end

Then /^the center cell should be alive$/ do
  @game.alive_at?(1, 1).should be_true
end

Then /^I should see the following board$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

