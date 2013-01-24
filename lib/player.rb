class Player
  attr_accessor :name, :symbol, :computer
  def initialize(name, symbol, computer = false)
    @name = name
    @symbol = symbol
    @computer = computer
  end
end