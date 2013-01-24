class Player
  attr_accessor :name, :id, :symbol, :computer
  def initialize(name, id, symbol, computer)
    @id = id # Don't need this
    @name = name
    @symbol = symbol
    @computer = computer
  end

  # def is_computer?
  #   @computer
  # end
end