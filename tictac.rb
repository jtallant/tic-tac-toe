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

	def move(board, move_position)
		if @id == 1
			$board["#{move_position}"] = 'X'
		else
			$board["#{move_position}"] = 'O'
		end
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
	while true
		show_board
		$turns.odd? ? player = player_one : player = player_two
		puts "Your move #{player.name}"
		input = gets.chomp
		case
		when input == 'q'
			break
		when input.match(/[1-9]/)
			player.move($board, input)
			$turns +=1
		else
			puts 'invalid input'
		end
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