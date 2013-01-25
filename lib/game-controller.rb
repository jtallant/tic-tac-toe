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

  def colorize_position(position)
    position = position.to_s
    return @board[position].color(:green) if @board[position] == 'X'
    return @board[position].color(:red) if @board[position] == 'O'
    @board[position.to_s]
  end

  def board_graphic
    p1 = colorize_position(1)
    p2 = colorize_position(2)
    p3 = colorize_position(3)
    p4 = colorize_position(4)
    p5 = colorize_position(5)
    p6 = colorize_position(6)
    p7 = colorize_position(7)
    p8 = colorize_position(8)
    p9 = colorize_position(9)

    board_graphic  = "\n"
    board_graphic += "     |     |     \n"
    board_graphic += "  #{p1}  |  #{p2}  |  #{p3}  \n"
    board_graphic += "_____|_____|_____\n"
    board_graphic += "     |     |     \n"
    board_graphic += "  #{p4}  |  #{p5}  |  #{p6}  \n"
    board_graphic += "_____|_____|_____\n"
    board_graphic += "     |     |     \n"
    board_graphic += "  #{p7}  |  #{p8}  |  #{p9}  \n"
    board_graphic += "\n"
    board_graphic
  end

  def position_color(position)
    if !is_not_taken?(position)
      return position.color(:red)
    end
    return position
  end

  def play_game(new_game = false)
    if new_game
      puts "\nWelcome to Tic-Tac-Toe\n".color(:red)
      puts "Would you like to play against the computer? (yes/no)\n"
      choose_game_type
    end
    game_loop
  end

  def choose_game_type
    input = gets.chomp.downcase
    if answered_yes?(input)
      gather_player_data(1) # 1player game ( human vs computer )
    elsif answered_no?(input)
      gather_player_data(2) # 2player game ( human vs human )
    else
      puts 'Please answer "yes" or "no"'
      choose_game_type
    end
  end

  def answered_yes?(answer)
    'yes' == answer || 'y' == answer
  end

  def answered_no?(answer)
    'no' == answer || 'n' == answer
  end

  def game_loop
    while true
      # clear_screen
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

  def computer_move
    if position = victory_at_hand?
      update_board(@player_two, position)
    elsif position = doom_is_near?
      update_board(@player_two, position)
    # make a fork is possible
    elsif position = fork_is_availabe?
      update_board(@player_two, position)
    # block any possible fork
    elsif position = block_potential_fork
      # puts position.empty?
      # puts position
      # puts position.nil?
      # puts "Opponent could have forked at #{position}"
      # Process.exit
      update_board(@player_two, position)
    elsif position = center_available?
      update_board(@player_two, position)
    elsif position = opposite_corner?
      update_board(@player_two, position)
    elsif position = empty_corner?
      update_board(@player_two, position)
    elsif position = empty_side?
      update_board(@player_two, position)
    else
      select_an_open_position
    end
  end

  def center_available?
    return 5 if is_not_taken?(5)
    false
  end

  # TODO
  def opposite_corner?
    if is_owned_by_human?(1) && is_not_taken?(9)
      return 9
    elsif is_owned_by_human?(9) && is_not_taken?(1)
      return 1
    elsif is_owned_by_human?(7) && is_not_taken(3)
      return 3
    elsif is_owned_by_human?(3) && is_not_taken(7)
      return 7
    end
  end

  # TODO
  def empty_corner?
    false
    # [1,3,7,9].each do |position|
    #   return position if is_not_taken?(position)
    # end
  end

  # TODO
  def empty_side?
    false
  end

  def select_an_open_position
    [1,3,7,9,2,4,6,8,5].each do |position|
      if is_not_taken?(position)
        update_board(@player_two, position)
        return
      end
    end
  end

  def victory_at_hand?

    finishing_moves.each do |position|
      if is_owned_by_computer?(position[0]) && is_owned_by_computer?(position[1]) && is_not_taken?(position[2])
        return position[2]
      end 
    end

    false
  end

  def human_has_no_position_in_line?(line)
    line.all? {|position| !is_owned_by_human?(position)}
  end

  def computer_has_no_position_in_line?(line)
    line.all? {|position| !is_owned_by_computer?(position)}
  end

  def block_potential_fork
    lines.each do |first_line|

      # next if the opponent owns none of the positions in the row
      # The opponenent cannot create a fork without owning at least 1 position in the row
      next if human_has_no_position_in_line?(first_line)

      # next if computer has already blocked (or owns at least 1) in the row
      # the enemy cant fork if the computer already owns one in the row
      next if false == computer_has_no_position_in_line?(first_line)

      lines.each do |second_line|

        next if lines_are_equal?(first_line, second_line)
        next if human_has_no_position_in_line?(second_line)
        next if false == computer_has_no_position_in_line?(second_line)

        return stop_on_corner if block_will_create_fork_from_center?
        return forced_stoppage_position if block_will_create_fork?

        intersection = first_line & second_line
        return intersection[0] if !intersection.empty? && is_not_taken?(intersection[0])
      end
    end
    false
  end

  def forced_stoppage_position
    return 2 if is_not_taken?(2) && is_not_taken?(8)
    return 4 if is_not_taken?(4) && is_not_taken?(6)
  end

  def stop_on_corner
    if is_not_taken?(3)
      return 3
    elsif is_not_taken(7)
      return 7
    end
  end

  def block_will_create_fork_from_center?
    return true if is_owned_by_human?(5) && is_owned_by_human?(9)
  end

  # more than one fork, favor a corner

  # Returns true if blocking the fork will create one
  def block_will_create_fork?
    if is_owned_by_computer?(5)
      return true if is_owned_by_human?(9) && is_owned_by_human?(1) || is_owned_by_human?(3) && is_owned_by_human?(7)
    end
    false
  end

  def lines_are_equal?(line1, line2)
    (line1 & line2).size == 3
  end

  # Computer does not own at least one position in the line
  # Return false if blocked
  # Return line if unblocked
  def is_unblocked?(line)
    return false if is_owned_by_computer?(line[0]) || is_owned_by_computer?(line[1]) || is_owned_by_computer?(line[2])
    line
  end

  # TODO check if lines are not blocked by enemy before trying to fork
  # Right now you are just checking if you own at least one in the row
  # Combine the fork methods?
  def fork_is_availabe?
    lines.each do |first_line|

      # next if they are all not owned
      # you need at least one to create a fork
      next if computer_has_no_position_in_line?(first_line)

      # next if the enemy already owns one
      # if the line blocked, you cannot create a fork
      next if false == human_has_no_position_in_line?(first_line)

      lines.each do |second_line|

        next if lines_are_equal?(first_line, second_line)
        next if computer_has_no_position_in_line?(second_line)
        next if false == human_has_no_position_in_line?(second_line)
        intersection = first_line & second_line
        return intersection[0] if !intersection.empty? && is_not_taken?(intersection[0])
      end
    end
    false
  end

  # These are sets
  # A intersect B
  def lines
    [
      [1, 2, 3],
      [1, 4, 7],
      [1, 5, 9],
      [2, 5, 8],
      [3, 5, 7],
      [3, 6, 9],
      [4, 5, 6],
      [7, 8, 9]
    ]
  end

  # could probably check if own 2 out 3
  # if so take the remaining one
  # that way you dont need to check the same combination twice
  # order matters
  def finishing_moves
    [
      [1, 2, 3],
      [1, 3, 2],
      [1, 4, 7],
      [1, 5, 9],
      [1, 7, 4],
      [1, 9, 5],

      [2, 3, 1],
      [2, 5, 8],
      [2, 8, 5],

      [3, 5, 7],
      [3, 6, 9],
      [3, 7, 5],
      [3, 9, 6],

      [4, 5, 6],
      [4, 6, 5],
      [4, 7, 1],

      [5, 6, 4],
      [5, 7, 3],
      [5, 8, 2],
      [5, 9, 1],

      [6, 9, 3],

      [7, 8, 9],
      [7, 9, 8],

      [8, 9, 7]
    ]
  end

  def doom_is_near?
    finishing_moves.each do |position|
      if is_owned_by_human?(position[0]) && is_owned_by_human?(position[1]) && is_not_taken?(position[2])
        return position[2]
      end
    end
    false
  end

  def is_owned_by_computer?(position, player = false)
    player ||= @player_two
    @board[position.to_s] == player.symbol
  end

  # returns true if the human player owns that position
  def is_owned_by_human?(position)
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
    player = @turns.odd? ? @player_one : @player_two
  end

  def player_who_moved_last
    player = @turns.odd? ? @player_two : @player_one
  end

  def update_board(player, move_position)
    @board[move_position.to_s] = player.symbol
    @turns += 1
  end

  def winner?
    winning_sections.each do |section|
      if section.uniq == [player_who_moved_last.symbol]
        return true
      end
    end
    false
  end

  def winning_sections
    [
      [@board['1'], @board['2'], @board['3']],
      [@board['4'], @board['5'], @board['6']],
      [@board['7'], @board['8'], @board['9']],
      [@board['1'], @board['4'], @board['7']],
      [@board['2'], @board['5'], @board['8']],
      [@board['3'], @board['6'], @board['9']],
      [@board['1'], @board['5'], @board['9']],
      [@board['7'], @board['5'], @board['3']]
    ]
  end

  def cat_game?
    @turns == 10
  end

  def clear_screen
    sleep 1
    system 'clear'
  end

  def check_for_endgame
    return if !winner? && !cat_game?
    message = winner? ? "#{player_who_moved_last.name} WINS !!!" : 'CAT game, no possibe winner'
    clear_screen
    puts board_graphic
    puts message
    ask_to_play_again
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
    if answered_yes?(input)
      reset_game
      play_game(false)
    elsif answered_no?(input)
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
      @player_one = Player.new(gets.chomp, 'X')
      @player_two = Player.new('Computer', 'O', true)
    else
      puts "Enter player one's name:"
      @player_one = Player.new(gets.chomp, 'X')
      puts "Enter player two's name:"
      @player_two = Player.new(gets.chomp, 'O')
    end
  end
end