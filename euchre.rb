class Euchre

  def initialize
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
    @human = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer1 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer2 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer3 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @flip_card = {}
  end

  def full_deal
    @human = player_deal
    @computer1 = player_deal
    @computer2 = player_deal
    @computer3 = player_deal
    trump
    p @human
    p @computer1
    p @computer2
    p @computer3
    p @flip_card

    
  
  end

  def player_deal
    hand = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    suits = ["spades", "clubs", "hearts", "diamonds"]
    5.times do
      while true #prevents taking from suits with no cards left
        suit = suits.sample
        if @deck[suit] != []
          break
        end
      end
      value = @deck[suit].sample
      hand[suit] << value #puts card in hand
      @deck[suit].delete(value) # removes from deck
    end
    return hand
  end

  def trump
    suits = ["spades", "clubs", "hearts", "diamonds"]
    while true #prevents taking from suits with no cards left
      suit = suits.sample
      if @deck[suit] != []
        break
      end
    end
    value = @deck[suit].sample
    @flip_card[suit] = value
  end

end

euchre = Euchre.new
euchre.full_deal