class Euchre

  def initialize
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
    @player1 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player2 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player3 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player4 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player_order = []
    @flip_card = {}
    @dealer_position = 0
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
    puts "Player #{@dealer_position + 1}, you are dealer."
    player_order()
    show_flipped_card()
    bid()
    convert_bowers()
    p @trump
    p @player1
    p @player2
    p @player3
    p @player4
    play_rounds()
  end

  def play_rounds
    played_cards = {}
    played_cards_order = []
    led_suit = ""
    @player_order.each_with_index do |player, index|
      if index == 0
        while true
          puts "Player X, Choose the suit of the card you would like to play (spades, clubs, hearts, diamonds)"
          puts "Your hand: Spades: #{player["spades"]}, Clubs: #{player["clubs"]}, Hearts: #{player["hearts"]}, Diamonds: #{player["diamonds"]}"
          suit = gets.chomp.downcase
          if suit != "spades" && suit != "clubs" && suit != "hearts" && suit != "diamonds"
            puts "Please choose a valid suit."
          elsif player[suit].length == 0
            puts "You have no #{suit} to play. Please enter a different suit."
          elsif player[suit].length > 0
            break
          end
        end
        exist = false
        puts "Suit options to play: #{player[suit]}"
        while true
          puts "Type the value of the card you wish to play."
          value = gets.chomp.to_s.downcase.capitalize
          exist = false
          player[suit].each do |card|
            if card == value
              exist = true
            end
          end
          if exist == false
            puts "You do not have a card with that value. Please choose valid value."
          else
            break
          end
        end
        led_suit = suit
      else
        puts "Currently played cards: #{played_cards}."
        puts "Led suit = #{led_suit}"
        if player[led_suit] != []
          suit = led_suit
          while true
            puts "Player X, You have the following #{suit}. Type the value of the card you wish to play."
            puts "Card values = #{player[suit]}"
            value = gets.chomp.to_s.downcase.capitalize
            exist = false
            player[suit].each do |card|
              if card == value
                exist = true
              end
            end
            if exist == false
              puts "You do not have a card with that value. Please choose valid value."
              
            else
              break
            end
          end
        else
          puts "Player X, you do not have the led suit. You can play any other card"
          puts "Your hand: Spades: #{player["spades"]}, Clubs: #{player["clubs"]}, Hearts: #{player["hearts"]}, Diamonds: #{player["diamonds"]}"
          while true
            puts "Player X, Choose the suit of the card you would like to play (spades, clubs, hearts, diamonds)"
            suit = gets.chomp.downcase
            if suit != "spades" && suit != "clubs" && suit != "hearts" && suit != "diamonds"
              puts "Please choose a valid suit."
            elsif player[suit].length == 0
              puts "You have no #{suit} to play. Please enter a different suit."
            elsif player[suit].length > 0
              break
            end
          end
          exist = false
          puts "Suit options to play: #{player[suit]}"
          while true
            puts "Type the value of the card you wish to play."
            value = gets.chomp.to_s.downcase.capitalize
            exist = false
            player[suit].each do |card|
              if card == value
                exist = true
              end
            end
            if exist == false
              puts "You do not have a card with that value. Please choose valid value."
            else
              break
            end
          end
        end
      end
      if played_cards[suit] == nil
        played_cards[suit] = []
      end
      played_cards[suit] << value
      played = {}
      played[suit] = value 
      played_cards_order << played
      p played_cards_order
    end
  end

  def hand_winner

  end

  def player_order
    if @dealer_position == 0
      @player_order = [@player2, @player3, @player4, @player1]
    elsif @dealer_position == 1
      @player_order = [@player3, @player4, @player1, @player2]
    elsif @dealer_position == 2
      @player_order = [@player4, @player1, @player2, @player3]
    elsif @dealer_position == 3
      @player_order = [@player1, @player2, @player3, @player4]
    end
  end

  def bid
    if @dealer_position > 3 #cycle through indexes of player order, not to exceed the 4th position
      @dealer_position = 0
    end
    position = @dealer_position + 2 #hold position for rounds without changing dealer position
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
      if order_it_up == true #dealer picks up @flipped_card, and chooses to discard a card
        players = [@player1, @player2, @player3, @player4]
        @trump = @flip_card.keys[0]
        dealer = players[@dealer_position]
        puts "Player #{@dealer_position + 1}, you have picked up #{@flip_card}. Please choose a card to discard."
        puts "Your Hand: Spades: #{dealer["spades"]}, Clubs: #{dealer["clubs"]}, Hearts: #{dealer["hearts"]}, Diamonds: #{dealer["diamonds"]}"
        while true
          puts "Choose the suit of the card you would like to discard (spades, clubs, hearts, diamonds)"
          suit = gets.chomp.downcase
          p suit
          if suit != "spades" && suit != "clubs" && suit != "hearts" && suit != "diamonds"
            puts "Please choose a valid suit."
          elsif players[@dealer_position][suit].length == 0
            puts "You have no #{suit} to discard. Please enter a different response."
          elsif players[@dealer_position][suit].length > 0
            break
          end
        end
        puts "Suit options to discard: #{dealer[suit]}"
        while true
          puts "Type the value of the card you wish to discard."
          value = gets.chomp.to_s.downcase.capitalize
          exist = false
          players[@dealer_position][suit].each do |card|
            if card == value
              exist = true
            end
          end
          if exist == false
            puts "You do not have a card with that value. Please choose valid value."
          else
            break
          end
        end
        players[@dealer_position][suit].delete(value)
        players[@dealer_position][@trump] << @flip_card[@trump]
        break
      end
      count += 1
    end
    if order_it_up == false
      count = 0
      trump_called = false
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
        if trump_called == true
          break
        end
        count += 1
        if count == 4 && trump_called == false
          while true
            puts "Sorry, Player #{position}, you are last and must call trump!"
            trump_called = call_trump(position, player)
            if trump_called == true
              break
            end
          end
        end
        position += 1
        if position == 5
          position = 1
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
    possible_suits = ["spades", "clubs", "hearts", "diamonds"]
    possible_suits.delete(@flip_card.keys[0])
    while true
      puts "Player #{position}, would you like to call trump? Please select #{possible_suits[0]}, #{possible_suits[1]}, #{possible_suits[2]}, or pass."
      answer = gets.chomp.downcase
      if answer == possible_suits[0] || answer == possible_suits[1] || answer == possible_suits[2]
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
    if @trump == "spades"
      off_jack = "clubs"
    elsif @trump == "clubs"
      off_jack = "spades"
    elsif @trump == "hearts"
      off_jack = "diamonds"
    elsif @trump == "diamonds"
      off_jack = "hearts"
    end
    right_bower_converstion()
    left_bower_conversion(off_jack)
  end

  def right_bower_converstion 
    players = [@player1, @player2, @player3, @player4]
    players.each do |player|
      player[@trump].each do |card|
        if card == "Jack"
          player[@trump].delete("Jack")
          player[@trump] << "Right_bower"
        end
      end
    end
  end

  def left_bower_conversion(off_jack)
    players = [@player1, @player2, @player3, @player4]
    players.each do |player|
      player[off_jack].each do |card|
        if card == "Jack"
          player[off_jack].delete("Jack")
          player[@trump] << "Left_bower"
        end
      end
    end
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

  def show_flipped_card
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