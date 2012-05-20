$board = {
	'1' => '1', '2' => '2', '3' => '3',
	'4' => '4', '5' => '5', '6' => '6',
	'7' => '7', '8' => '8', '9' => '9'
}
board_graphic = ''
$turns = 1

class Player
	attr_accessor :name, :id
	def initialize(name, id)
		@id = id
		@name = name
		# @board = board
	end

	def move(board,player_one,player_two)
		input = gets.chomp
		if input.to_i < 1 || input.to_i > 9
			puts "You must put a number between 0 and 10."
			game_controller($board,player_one,player_two)
		end
		if @id == 1
			$board["#{input}"] = 'X'
		else
			$board["#{input}"] = 'O'
		end
		$turns += 1
		game_controller($board,player_one,player_two)
	end
end

def show_board
	board_graphic  = "\n"
	board_graphic += "     |     |     \n"
	board_graphic += "  #{$board["1"]}  |  #{$board["2"]}  |  #{$board["3"]}  \n"
	board_graphic += "_____|_____|_____\n"
	board_graphic += "     |     |     \n"
	board_graphic += "  #{$board["4"]}  |  #{$board["5"]}  |  #{$board["6"]}  \n"
	board_graphic += "_____|_____|_____\n"
	board_graphic += "     |     |     \n"
	board_graphic += "  #{$board["7"]}  |  #{$board["8"]}  |  #{$board["9"]}  \n"
	board_graphic += "\n"
	puts board_graphic
end


def game_controller(board,player_one,player_two)
	show_board
	if $turns.odd?
		puts "Your move #{player_one.name}"
		player_one.move($board, player_one, player_two)
	else
		puts "Your move #{player_two.name}"
		player_two.move($board, player_one, player_two)
	end
end

def welcome(board)
	puts ''
	puts 'Welcome to Tic-Tac-Toe.'
	puts ''
	puts "Enter player one's name:"
	player_one = Player.new(gets.chomp, 1)
	puts "Enter player two's name:"
	player_two = Player.new(gets.chomp, 2)
	game_controller($board,player_one,player_two)
end

welcome($board)