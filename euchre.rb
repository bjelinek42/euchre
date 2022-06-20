class Euchre

  def initialize
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
    @player1 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player2 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player3 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player4 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @flip_card = {}
    @dealer_position = 1
    @score = {"team1" => 0, "team2" => 0}
    @bidding_team = ""
    @trump = ""
    puts "Welcome to Euchre! Please hit enter to start the game and deal out hands."
    gets
  end

  def full_deal
    @player1 = player_deal
    @player2 = player_deal
    @player3 = player_deal
    @player4 = player_deal
    trump
    bid
    convert_bowers
    p @trump
    p @player1
    p @player2
    p @player3
    p @player4
  end

  def bid
    if @dealer_position > 4 #cycle through indexes of player order, not to exceed the 4th position
      @dealer_position = 1
    end
    position = @dealer_position #mold position for rounds without changing dealer position
    puts "The flipped card is: #{@flip_card}"
    count = 0
    while count < 4
      if position == 1
        player = @player1
        order_it_up = player_bid(position, player)
      elsif position == 2
        player = @player2
        order_it_up = player_bid(position, player)
      elsif position == 3
        player = @player3
        order_it_up = player_bid(position, player)
      elsif position == 4
        player = @player4
        order_it_up = player_bid(position, player)
      end
      position += 1
      if position == 5
        position = 1
      end
      if order_it_up == true
        @trump = @flip_card.keys[0]
        break
      end
      count += 1
    end
    if order_it_up == false
      count = 0
      while count < 4
        if position == 1
          player = @player1
          trump_called = call_trump(position, player)
        elsif position == 2
          player = @player2
          trump_called = call_trump(position, player)
        elsif position == 3
          player = @player3
          trump_called = call_trump(position, player)
        elsif position == 4
          player = @player4
          trump_called = call_trump(position, player)
        end
        position += 1
        if position == 5
          position = 1
        end
        count += 1
        if trump_called == true
          break
        end
      end
    end
    p @trump
  end

  def player_bid(position, player)
    puts "Player #{position}, it is your turn."
    puts "Your Hand: Spades: #{player["spades"]}, Clubs: #{player["clubs"]}, Hearts: #{player["hearts"]}, Diamonds: #{player["diamonds"]}"
    order_it_up = false
    while true
      puts "Would you like to Order it up? y or n"
      answer = gets.chomp.downcase
      if answer == "y"
        if position == 1 || position == 3
          @bidding_team = "team1"
        else
          @bidding_team = "team2"
        end
        order_it_up = true
        break
      elsif answer == "n"
        break
      else
        puts "please enter a valid response"
      end
    end
    return order_it_up
  end

  def call_trump(position, player)
    call_trump = false
    puts "Your Hand: Spades: #{player["spades"]}, Clubs: #{player["clubs"]}, Hearts: #{player["hearts"]}, Diamonds: #{player["diamonds"]}"
    while true
      puts "Player #{position}, would you like to call trump? Please select spades, clubs, hearts, diamonds, or pass."
      answer = gets.chomp.downcase
      if answer == "spades" || answer == "clubs" || answer == "hearts" || answer == "diamonds"
        @trump = answer
        call_trump = true
        break
      elsif answer == "pass"
        break
      else
        puts "Please enter a valid response"
      end
    end
    return call_trump
  end

  def convert_bowers
    black = ["spades", "clubs"]
    red = ["hearts", "diamonds"]
    if @trump == "spades"
      off_jack = "clubs"
    elsif @trump == "clubs"
      off_jack = "spades"
    elsif @trump == "hearts"
      off_jack = "diamonds"
    elsif @trump == "diamonds"
      off_jack = "hearts"
    end
    @player1[@trump].each do |card|
      if card == "Jack"
        @player1[@trump].delete("Jack")
        @player1[@trump] << "Right_Bower"
      end
    end
    @player1[off_jack].each do |card|
      if card == "Jack"
        @player1[off_jack].delete("Jack")
        @player1[@trump] << "Left_Bower"
      end
    end
    @player2[@trump].each do |card|
      if card == "Jack"
        @player2[@trump].delete("Jack")
        @player2[@trump] << "Right_Bower"
      end
    end
    @player2[off_jack].each do |card|
      if card == "Jack"
        @player2[off_jack].delete("Jack")
        @player2[@trump] << "Left_Bower"
      end
    end
    @player3[@trump].each do |card|
      if card == "Jack"
        @player3[@trump].delete("Jack")
        @player3[@trump] << "Right_Bower"
      end
    end
    @player3[off_jack].each do |card|
      if card == "Jack"
        @player3[off_jack].delete("Jack")
        @player3[@trump] << "Left_Bower"
      end
    end
    @player4[@trump].each do |card|
      if card == "Jack"
        @player4[@trump].delete("Jack")
        @player4[@trump] << "Right_Bower"
      end
    end
    @player4[off_jack].each do |card|
      if card == "Jack"
        @player4[off_jack].delete("Jack")
        @player4[@trump] << "Left_Bower"
      end
    end
  end

  def right_bower_converstion

  end

  def left_bower_conversion

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