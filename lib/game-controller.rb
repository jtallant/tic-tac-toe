class Game_Controller

  attr_accessor :board, :turns, :player_one, :player_two

  def initialize

    @turns = 1

    @board = {
      '1' => '1', '2' => '2', '3' => '3',
      '4' => '4', '5' => '5', '6' => '6',
      '7' => '7', '8' => '8', '9' => '9'
    }

    play_game(true)
  end

  def board_graphic
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
    board_graphic
  end

  def play_game(new_game = false)

    if new_game

      puts "\n Welcome to Tic-Tac-Toe\n"

      puts "Would you like to play against the computer?\n"

      input = gets.chomp.downcase

      if input == 'yes' || input == 'y'
        # 1 player
        gather_player_data(1)
      else
        # 2 player
        gather_player_data(2)
      end

    end

    while true

      sleep 1
      system "clear"
      puts board_graphic
      puts "Turn Number: #{@turns}"
      puts "Your move #{current_player.name}"

      if current_player.computer
        computer_move
      else
        human_move(gets.chomp.downcase, current_player)
      end

      check_for_endgame
    end
  end

  # get rid of all the to_s
  def computer_move
    if position = victory_at_hand?
      update_board(@player_two, position.to_s)
    elsif position = doom_is_near?
      update_board(@player_two, position.to_s)
    # create a fork if possible
    elsif position = fork_available?
      update_board(@player_two, position.to_s)
    elsif is_not_taken?(1)
      update_board(@player_two, '1')
    elsif is_not_taken?(3)
      update_board(@player_two, '3')
    elsif is_not_taken?(7)
      update_board(@player_two, '7')
    elsif is_not_taken?(9)
      update_board(@player_two, '9')
    elsif is_not_taken?(5)
      update_board(@player_two, '5')
    elsif is_not_taken?(2)
      update_board(@player_two, '2')
    elsif is_not_taken?(4)
      update_board(@player_two, '4')
    elsif is_not_taken?(6)
      update_board(@player_two, '6')
    elsif is_not_taken?(8)
      update_board(@player_two, '8')
    end
  end

  def fork_available?
    false
  end

  def victory_at_hand?

    finishing_moves.each do |position|
      if is_owned?(position[0]) && is_owned?(position[1]) && is_not_taken?(position[2])
        return position[2]
      end 
    end

    false
  end

  def finishing_moves
    [
      [1, 2, 3],
      [1, 3, 2],
      [1, 4, 7],
      [1, 5, 9],
      [1, 7, 4],
      [1, 9, 5],
      [2, 3, 1],
      [2, 5, 7],
      [2, 8, 5],
      [3, 5, 7],
      [3, 6, 9],
      [3, 7, 5],
      [3, 9, 6],
      [4, 5, 6],
      [4, 7, 1],
      [5, 6, 4],
      [5, 7, 3],
      [5, 9, 1],
      [6, 9, 3],
      [7, 8, 9],
      [7, 9, 8]
    ]
  end

  # share that array
  def doom_is_near?

    finishing_moves.each do |position|
      if is_owned_by_enemy?(position[0]) && is_owned_by_enemy?(position[1]) && is_not_taken?(position[2])
        return position[2]
      end
    end

    false
  end

  def is_owned?(position, player = false)
    player ||= @player_two
    @board[position.to_s] == player.symbol
  end

  def is_owned_by_enemy?(position)
    @board[position.to_s] == @player_one.symbol
  end

  def is_not_taken?(position)
    @board[position.to_s] != 'X' && @board[position.to_s] != 'O'
  end

  def human_move(input, player)
    case
    when input == 'q' || input == 'quit' || input == 'exit'
      Process.exit
    when input.empty? || input.length > 1 || input.match(/[^1-9]/)
      puts 'Invalid input! Try again dumbass.'
      human_move(gets.chomp.downcase, player)
    when @board["#{input}"].match(/[^1-9]/)
      puts 'That position is already taken fool.'
      human_move(gets.chomp.downcase, player)
    else
      update_board(player, input)
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

  # Doing too much here, try and just return true or false
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
        sleep 1
        system "clear"
        puts board_graphic
        puts "#{player_who_moved_last.name} WINS!!!"
        ask_to_play_again
      elsif @turns == 10
        sleep 1
        system "clear"
        puts board_graphic
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

  # Doing too much here
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

  def gather_player_data(number_players)
    if 1 == number_players
      puts "What is your name?"
      @player_one = Player.new(gets.chomp, 1, 'X', false)
      @player_two = Player.new('Computer', 2, 'O', true)
    else
      puts "Enter player one's name:"
      @player_one = Player.new(gets.chomp, 1, 'X', false)
      puts "Enter player two's name:"
      @player_two = Player.new(gets.chomp, 2, 'O', false)
    end
  end
end