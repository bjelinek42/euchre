class Euchre

  def initialize
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
    @player1 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player2 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player3 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player4 = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    @player_order = []
    @text_player_order = []
    @flip_card = {}
    @dealer_position = 0
    @score = {"team1" => 0, "team2" => 0}
    @hands_won = {"team1" => 0, "team2" => 0}
    @bidding_team = ""
    @trump = ""
    puts "Welcome to Euchre! Please hit enter to start the game and deal out hands."
    gets
  end

  def full_game
    while @score["team1"] < 10 && @score["team2"] < 10
      @player1 = player_deal
      @player2 = player_deal
      @player3 = player_deal
      @player4 = player_deal
      initial_player_order()
      puts "#{@text_player_order[3]}, you are dealer."
      show_flipped_card()
      bid()
      convert_bowers()
      5.times do
        play_hand()
        add_to_hands_won()
        puts "***************************************"
        puts "Trick completed. Team 1: #{@hands_won["team1"]}, Team 2: #{@hands_won["team2"]}"
        puts "***************************************"
      end
      add_to_score()
      prepare_for_next_hand()
    end
    if @score["team1"] >= 10
      puts 'Team 1 is the winner! Thanks for playing!'
    elsif @score["team2"] >= 10
      puts 'Team 2 is the winner! Thanks for playing!'
    end
  end

  def prepare_for_next_hand #reset variables and move dealer position
    puts "***************************************"
    puts "End of hand! The bidding team last round was #{@bidding_team}, and they took #{@hands_won[@bidding_team]} tricks. The score is currently:"
    puts "Team 1: #{@score["team1"]}, Team 2: #{@score["team2"]}."
    puts "***************************************"
    puts "Press enter to deal next hand."
    gets
    @dealer_position += 1
    if @dealer_position > 3
      @dealer_position = 0
    end
    @hands_won = {"team1" => 0, "team2" => 0}
    @flip_card = {}
    @deck = {"spades" => ["Ace", "King", "Queen", "Jack", "10", "9"], "clubs" => ["Ace", "King", "Queen", "Jack", "10", "9"], "hearts" => ["Ace", "King", "Queen", "Jack", "10", "9"], "diamonds" => ["Ace", "King", "Queen", "Jack", "10", "9"]}
  end

  def play_hand #follow player order to play hand
    played_cards = {"spades" => [], "clubs" => [], "hearts" => [], "diamonds" => []}
    played_cards_order = []
    led_suit = ""
    @player_order.each_with_index do |player, index|
      puts "***************************************"
      if index == 0 #first player picks suit to be followed
        while true
          puts "Trump is #{@trump.capitalize}"
          puts "#{@text_player_order[index]}, Choose the suit of the card you would like to play (spades, clubs, hearts, diamonds)"
          show_hand(player)
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
        puts "Suit options to play: #{player[suit]}" #shows all values from the selected suit
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
      else #other players must follow suit chosen
        currently_played_cards(played_cards)
        puts "Trump is #{@trump.capitalize}"
        puts "Led suit is #{led_suit.capitalize}"
        if player[led_suit] != [] #if they have led suit, must follow suit
          suit = led_suit
          while true
            puts "#{@text_player_order[index]}, You have the following #{suit}. Type the value of the card you wish to play."
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
        else #if player has none of the led suit, they can choose any card to play
          puts "#{@text_player_order[index]}, you do not have any #{led_suit.capitalize}. You can play any other card."
          show_hand(player)
          while true
            puts "#{@text_player_order[index]}, Choose the suit of the card you would like to play (spades, clubs, hearts, diamonds)"
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
      played_cards[suit] << value
      played = {}
      played[suit] = value 
      played_cards_order << played
      player[suit].delete(value)
    end
    hand_winner(played_cards_order, led_suit)
  end

  def currently_played_cards(played_cards)
    puts "Current played cards: Spades: #{played_cards["spades"]}, Clubs: #{played_cards["clubs"]}, Hearts: #{played_cards["hearts"]}, Diamonds: #{played_cards["diamonds"]}"
  end

  def show_hand(player)
    puts "Your Hand: Spades: #{player["spades"]}, Clubs: #{player["clubs"]}, Hearts: #{player["hearts"]}, Diamonds: #{player["diamonds"]}"
  end

  def hand_winner(played_cards_order, led_suit)
    cards = []
    played_cards_order.each_with_index do |card, index| #pulls all trump out of the hand, preserving the index to find hand winner
      if card.keys[0] == @trump
        cards[index] = card
      else
        cards[index] = nil
      end
    end
    if cards != [nil, nil, nil, nil] #if there is trump, use these to find the winner
      trump = true
      winner(cards, trump, led_suit)
    else #if no trump, find all the card of the led suit and calculate winner than way
      trump = false
      cards = []
      played_cards_order.each_with_index do |card, index|
        if card.keys[0] == led_suit
          cards[index] = card
        else
          cards[index] = nil
        end
      end
      winner(cards, trump, led_suit)
    end
  end

  def winner(cards, trump, led_suit) #assign values at each level, find highest value index, that index is the winner from @player_order
    if trump == true
      suit = @trump
    else
      suit = led_suit
    end
    cards.each_with_index do |card, index|
      if card == nil
        cards[index] = 0
      elsif card[suit] == "Right_bower"
        cards[index] = 8
      elsif card[suit] == "Left_bower"
        cards[index] = 7
      elsif card[suit] =="Ace"
        cards[index] = 6
      elsif card[suit] == "King"
        cards[index] = 5
      elsif card[suit] == "Queen"
        cards[index] = 4
      elsif card[suit] == "Jack"
        cards[index] = 3
      elsif card[suit] == "10"
        cards[index] = 2
      elsif card[suit] == "9"
        cards[index] = 1
      end
    end
    winner_index = cards.index(cards.max)
    subsequent_player_order(winner_index)
  end

  def add_to_hands_won
    if @text_player_order[0] == "Player 1" || @text_player_order[0] == "Player 3"
      @hands_won["team1"] += 1
    else
      @hands_won["team2"] += 1
    end
  end

  def add_to_score
    if @bidding_team == "team1" && @hands_won["team1"] == 5
      @score["team1"] += 2
    elsif @bidding_team == "team1" && @hands_won["team1"] >= 3
      @score["team1"] += 1
    elsif @bidding_team == "team1" 
      @score["team2"] += 2
    elsif @bidding_team == "team2" && @hands_won["team2"] == 5
      @score["team2"] += 2
    elsif @bidding_team == "team2" && @hands_won["team2"] >= 3
      @score["team2"] += 1
    elsif @bidding_team == "team2" 
      @score["team1"] += 2
    end
  end

  def initial_player_order
    if @dealer_position == 0
      @player_order = [@player2, @player3, @player4, @player1]
      @text_player_order = ["Player 2", "Player 3", "Player 4", "Player 1"]
    elsif @dealer_position == 1
      @player_order = [@player3, @player4, @player1, @player2]
      @text_player_order = ["Player 3", "Player 4", "Player 1", "Player 2"]
    elsif @dealer_position == 2
      @player_order = [@player4, @player1, @player2, @player3]
      @text_player_order = ["Player 4", "Player 1", "Player 2", "Player 3"]
    elsif @dealer_position == 3
      @player_order = [@player1, @player2, @player3, @player4]
      @text_player_order = ["Player 1", "Player 2", "Player 3", "Player 4"]
    end
  end

  def subsequent_player_order(winner_index) #decide new order based on winner of last hand
    if winner_index == 1
      shift = @player_order.shift(1)
      shift.each do |player|
        @player_order << player
      end
      shift = @text_player_order.shift(1)
      shift.each do |player|
        @text_player_order << player
      end
    elsif winner_index == 2
      shift = @player_order.shift(2)
      shift.each do |player|
        @player_order << player
      end
      shift = @text_player_order.shift(2)
      shift.each do |player|
        @text_player_order << player
      end
    elsif winner_index == 3
      shift = @player_order.shift(3)
      shift.each do |player|
        @player_order << player
      end
      shift = @text_player_order.shift(3)
      shift.each do |player|
        @text_player_order << player
      end
    end
  end

  def bid
    puts "The flipped card is: #{@flip_card.values[0]} of #{@flip_card.keys[0].capitalize}"
    order_it_up = false
    @player_order.each_with_index do |player, index|
      puts "***************************************"
      if index == 0
        order_it_up = player_bid(index, player)
      elsif index == 1
        order_it_up = player_bid(index, player)
      elsif index == 2
        order_it_up = player_bid(index, player)
      elsif index == 3
        order_it_up = player_bid(index, player)
      end
      if order_it_up == true #dealer picks up @flipped_card, and chooses to discard a card
        @trump = @flip_card.keys[0]
        dealer = @player_order[3]
        puts "***************************************"
        puts "#{@text_player_order[3]}, you have picked up the #{@flip_card.values[0]} of #{@flip_card.keys[0].capitalize}. Please choose a card to discard."
        show_hand(@player_order[3])
        while true
          puts "Choose the suit of the card you would like to discard (spades, clubs, hearts, diamonds)"
          suit = gets.chomp.downcase
          if suit != "spades" && suit != "clubs" && suit != "hearts" && suit != "diamonds"
            puts "Please choose a valid suit."
          elsif @player_order[3][suit].length == 0
            puts "You have no #{suit} to discard. Please enter a different response."
          elsif @player_order[3][suit].length > 0
            break
          end
        end
        puts "Suit options to discard: #{dealer[suit]}"
        while true
          puts "Type the value of the card you wish to discard."
          value = gets.chomp.to_s.downcase.capitalize
          exist = false
          @player_order[3][suit].each do |card|
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
        @player_order[3][suit].delete(value)
        @player_order[3][@trump] << @flip_card[@trump]
        break
      end
    end
    if order_it_up == false #if no one orders it up, now players can call trump
      trump_called = false
      @player_order.each_with_index do |player, index|
        puts "***************************************"
        if index == 0
          trump_called = call_trump(index, player)
        elsif index == 1
          trump_called = call_trump(index, player)
        elsif index == 2
          trump_called = call_trump(index, player)
        elsif index == 3
          trump_called = call_trump(index, player)
        end
        if trump_called == true
          break
        end
        if index == 3 && trump_called == false #if get to dealer and no trump called, dealer is forced to call it
          while true
            puts "Sorry, #{@text_player_order[index]}, you are dealer and must call trump!"
            trump_called = call_trump(index, player)
            if trump_called == true
              break
            end
          end
        end
      end
    end
  end

  def player_bid(position, player)
    puts "#{@text_player_order[position]}, it is your turn."
    show_hand(player)
    order_it_up = false
    while true
      puts "Would you like to Order it up? Y or N"
      answer = gets.chomp.downcase
      if answer == "y"
        bidding_team(position)
        order_it_up = true
        break
      elsif answer == "n"
        break
      else
        puts "Please enter a valid response"
      end
    end
    return order_it_up
  end

  def call_trump(position, player)
    call_trump = false
    show_hand(player)
    possible_suits = ["spades", "clubs", "hearts", "diamonds"]
    possible_suits.delete(@flip_card.keys[0]) #cannot choose same suit as flip_card
    while true
      puts "#{@text_player_order[position]}, would you like to call trump? Please select #{possible_suits[0]}, #{possible_suits[1]}, #{possible_suits[2]}, or pass."
      answer = gets.chomp.downcase
      if answer == possible_suits[0] || answer == possible_suits[1] || answer == possible_suits[2]
        @trump = answer
        bidding_team(position)
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

  def bidding_team(position) #record bidding team for score calc based on position
    if @text_player_order[position] == "Player 1" || @text_player_order[position] == "Player 3"
      @bidding_team = "team1"
    else
      @bidding_team = "team2"
    end
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
        suit = suits.sample #choose random suit
        if @deck[suit] != []
          break
        end
      end
      value = @deck[suit].sample #choose random value from suit
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
euchre.full_game