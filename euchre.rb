class Euchre

  def initialize
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
    @human = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer1 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer2 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer3 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @burn_pile = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
  end

  def deal
    suits = ["spades", "clubs", "hearts", "diamonds"]
    24.times do
      while true #prevents taking from suits with no cards left
        suit = suits.sample
        if @deck[suit] != []
          break
        end
      end
      value = @deck[suit].sample
      @human[suit] << value #puts card in hand
      @deck[suit].delete(value) # removes from deck
      p @human
      p @deck

    end
  
  end

end

euchre = Euchre.new
euchre.deal