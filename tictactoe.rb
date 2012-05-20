class Board
	attr_accessor :squares
	def initialize
		@squares = {
			'1' => ' ', '2' => ' ', '3' => ' ',
			'4' => ' ', '5' => ' ', '6' => ' ',
			'7' => ' ', '8' => ' ', '9' => ' '
		}
	end
end

class Player
	attr_accessor :name, :board
	def initialize(name, id)
		@id = id
		@name = name
		@board = Board.new
	end

	def move(square)
		if square.to_i < 1 || square.to_i > 9
			puts "You must put a number between 0 and 7."
			return
		end
		if @id == 1
			@board.squares["#{square}"] = 'X'
		else
			@board.squares["#{square}"] = 'O'
		end
		$turns += 1
	end
end

def game_controller
	$turn = 0

	puts 

	if $turn.odd?
		puts "Your move #{player_one.name}"

	else
		# player two update board
	end

end

def welcome
	puts ''
	puts 'Welcome to Tic-Tac-Toe.'
	puts ''
	puts "Enter player one's name:"
	puts "Enter player one's name:"
	player_one = Player.new(gets.chomp, 1)
	puts "Enter player two's name:"
	player_two = Player.new(gets.chomp, 2)

	game_controller
end



# puts player_one.name

# puts player_two.name

board  = "     |     |     \n"
board += "     |     |     \n"
board += "_____|_____|_____\n"
board += "     |     |     \n"
board += "     |     |     \n"
board += "_____|_____|_____\n"
board += "     |     |     \n"
board += "     |     |     \n"
board += "     |     |     \n"
puts ''
puts ''

puts board 
# puts "Your move #{player_one.name}. Select a square."

puts ''
puts ''

puts "     |     |     "
puts "  1  |  2  |  3  "
puts "_____|_____|_____"
puts "     |     |     "
puts "  4  |  5  |  6  "
puts "_____|_____|_____"
puts "     |     |     "
puts "  7  |  8  |  9  "
puts "     |     |     "

# square = gets.chomp

# player_one.move(square)

# puts player_one.board.squares["1"]

# square = gets.chomp

# player_two.move(square)

# puts player_two.board.squares["1"]