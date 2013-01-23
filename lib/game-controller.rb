class Game_Controller

  attr_accessor :board, :turns, :player_one, :player_two

  def initialize

    @turns = 1

    @board = {
      '1' => '1', '2' => '2', '3' => '3',
      '4' => '4', '5' => '5', '6' => '6',
      '7' => '7', '8' => '8', '9' => '9'
    }

    play_game
  end

  def show_board

    puts "Turn Number: #{@turns}"
    board_graphic  = "\n"
    board_graphic += "     |     |     \n"
    board_graphic += "  #{@board["1"]}  |  #{@board["2"]}  |  #{@board["3"]}  \n"
    board_graphic += "_____|_____|_____\n"
    board_graphic += "     |     |     \n"
    board_graphic += "  #{@board["4"]}  |  #{@board["5"]}  |  #{@board["6"]}  \n"
    board_graphic += "_____|_____|_____\n"
    board_graphic += "     |     |     \n"
    board_graphic += "  #{@board["7"]}  |  #{@board["8"]}  |  #{@board["9"]}  \n"
    board_graphic += "\n"
    puts board_graphic
  end

  def play_game(new_players = true)

    welcome if new_players

    while true

      show_board

      player = current_player

      puts "Your move #{player.name}"

      input = gets.chomp

      case
      when input == 'q' || input == 'quit' || input == 'exit'
        break
      when input.empty? || input.length > 1 || input.match(/[^1-9]/)
        puts 'invalid input'
      when @board["#{input}"].match(/[^1-9]/)
        puts 'That position is already taken'
      else
        update_board(player, input)
      end

      check_for_endgame
    end
  end

  def current_player

    if @turns.odd?
      player = @player_one
    else
      player = @player_two
    end

    player
  end

  def player_who_moved_last

    if @turns.odd?
      player = @player_two
    else
      player = @player_one
    end

    player
  end

  def update_board(player, move_position)

    @board[move_position] = player.symbol
    @turns += 1
  end

  def check_for_winner(array, player)

    if array.uniq == [player.symbol]
      return player
    end

    false
  end

  def check_for_endgame

    winning_sections = [
      [@board['1'], @board['2'], @board['3']],
      [@board['4'], @board['5'], @board['6']],
      [@board['7'], @board['8'], @board['9']],
      [@board['1'], @board['4'], @board['7']],
      [@board['2'], @board['5'], @board['8']],
      [@board['3'], @board['6'], @board['9']],
      [@board['1'], @board['5'], @board['9']],
      [@board['7'], @board['5'], @board['3']]
    ]
    
    winning_sections.each do |section|

      winner = check_for_winner(section, player_who_moved_last)

      if winner
        show_board
        puts "#{player_who_moved_last.name} WINS!!!"
        ask_to_play_again
      elsif @turns == 10
        show_board
        puts 'CAT game, no possible winner'
        ask_to_play_again
      end

    end
  end

  def reset_game

    @board = {
      '1' => '1', '2' => '2', '3' => '3',
      '4' => '4', '5' => '5', '6' => '6',
      '7' => '7', '8' => '8', '9' => '9'
    }

    @turns = 1
  end

  def ask_to_play_again

    puts 'Would you like to play again? (yes/no)'
    input = gets.chomp

    if input == 'yes'
      reset_game
      play_game(false)
    elsif input == 'no'
      puts "Fine but it's not like you've got anything better to do"
      Process.exit
    else
      puts 'Invalid input'
      ask_to_play_again
    end
  end

  def welcome

    puts ''
    puts 'Welcome to Tic-Tac-Toe.'
    puts ''
    puts "Enter player one's name:"
    @player_one = Player.new(gets.chomp, 1, 'X')
    puts "Enter player two's name:"
    @player_two = Player.new(gets.chomp, 2, 'O')
  end
end