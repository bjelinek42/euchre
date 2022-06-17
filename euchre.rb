class Euchre

  def initialize
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
    @human = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer1 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer2 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @computer3 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @flip_card = {}
    @player_order = ["human", "computer1", "computer2", "computer3"]
    @dealer_position = 1
    @score = {"team1" => 0, "team2" => 0}
    @bidding_team = ""
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
    bid
  end

  def bid
    if @dealer_position > 4 #cycle through indexes of player order, not to exceed the 4th position
      @dealer_position = 1
    end
    position = @dealer_position #mold position for rounds without changing dealer position
    puts "The flipped card is: #{@flip_card}"
    while true
      if position == 1
        puts "Your Hand: Spades: #{@human["spades"]}, Clubs: #{@human["clubs"]}, Hearts: #{@human["hearts"]}, Diamonds: #{@human["diamonds"]}"
        puts "Would you like to Order it up? y or n"
        answer = gets.chomp.downcase
        if answer == "y"
          @bidding_team = "team1"
          break
        end
      elsif position == 2
        player = @computer1
      elsif position == 3
        player = @computer2
      elsif position == 4
        player = @computer3
      end
    end
  end

  def convert_bowers

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