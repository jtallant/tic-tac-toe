$board = {
  '1' => '1', '2' => '2', '3' => '3',
  '4' => '4', '5' => '5', '6' => '6',
  '7' => '7', '8' => '8', '9' => '9'
}

$turns = 1

class Player
  attr_accessor :name, :id
  def initialize(name, id)
    @id = id
    @name = name
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
  puts $turns
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
    when input.empty? || input.length > 1 || input.match(/[^1-9]/)
      puts 'invalid input'
    when $board["#{input}"].match(/[^1-9]/)
      puts 'That position is already taken'
    else
      player.move($board, input)
      $turns += 1
    end
    check_for_endgame($board, player, player_one, player_two)
  end
end

def check_equal(board, array)
  array.uniq == ['X'] || array.uniq == ['O']
end

def check_for_endgame(board, player, player_one, player_two)
  winning_sections = [
    [board['1'],board['2'],board['3']],
    [board['4'],board['5'],board['6']],
    [board['7'],board['8'],board['9']],
    [board['1'],board['4'],board['7']],
    [board['2'],board['5'],board['8']],
    [board['3'],board['6'],board['9']],
    [board['1'],board['5'],board['9']],
    [board['7'],board['5'],board['3']]
  ]
	
  winning_sections.each do |section|
    if check_equal($board,section) == true
      show_board
      puts "#{player.name} WINS!!!"
      play_again(player_one, player_two)
    elsif $turns == 10
      show_board
      puts 'CAT game, no possible winner'
      play_again(player_one, player_two)
    end
  end
end

def reset_game
  $board = {
    '1' => '1', '2' => '2', '3' => '3',
    '4' => '4', '5' => '5', '6' => '6',
    '7' => '7', '8' => '8', '9' => '9'
  }
  $turns = 1
end

def play_again(player_one,player_two)
  puts 'Would you like to play again? (yes/no)'
  input = gets.chomp
  if input == 'yes'
    reset_game
    game_controller($board,player_one,player_two)
  elsif input == 'no'
    puts 'Goodbye'
    Process.exit
  else
    puts 'Invalid input'
    play_again
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