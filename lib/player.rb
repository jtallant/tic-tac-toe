class Player
  attr_accessor :name, :id, :symbol
  def initialize(name, id, symbol)
    @id = id
    @name = name
    @symbol = symbol
  end
end