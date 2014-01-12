require 'rubygems'
require 'sinatra'
require 'pry'
require 'sinatra/reloader'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MIN_HIT = 17
INITIAL_POT_AMOUNT = 500

helpers do
  def calculate_total(cards)
    val = 0
    aces_count = 0
    arr = cards.map{|element| element[1]}

    cards_aceless = arr.dup
    cards_aceless.delete_if do |card|
      if card == 'ace'
        aces_count += 1
        true
      end
    end

    cards_aceless.each do |card|
      if card.to_i == 0
        val += 10
      else
        val += card.to_i
      end
    end

    aces_count.times do
      if val + 11 > 21
        val += 1
      else
        val += 11
      end
    end
    val
  end

  def set_deck
    suits = %w(hearts diamonds clubs spades)
    ranks = %w(2 3 4 5 6 7 8 9 10 jack queen king ace)
    session[:deck] = suits.product(ranks)
    session[:deck].shuffle!
  end

  def deal
    session[:player_cards] << session[:deck].pop
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
    session[:dealer_cards] << session[:deck].pop
  end

  def winner!(msg)
    @play_again = true
    @show_hit_or_stay = false
    session[:player_pot] = session[:player_pot] + session[:player_bet]
    @success = "<strong>#{session[:player_name]} WINS</strong> #{msg}"
  end
  
  def loser!(msg)
    @play_again = true
    @show_hit_or_stay = false
    session[:player_pot] = session[:player_pot] - session[:player_bet]
    @error = "<strong>#{session[:player_name]} LOSES.</strong> #{msg}"  
  end

  def draw!(msg)
    @play_again = true
    @show_hit_or_stay = false
    @success = "<strong>DRAW.</strong> #{msg}"
  end
end

before do
  @show_hit_or_stay = true
end

get '/' do
  # if session[:player_name]
  #   redirect '/game'
  # else
  #   redirect '/set_name'
  # end
      redirect '/set_name'
end

get '/set_name' do
  session[:player_pot] = INITIAL_POT_AMOUNT
  erb :set_name
end

post '/set_name' do
  if params[:player_name].empty?
    @error = "Name is required"
    halt erb(:set_name)
  end

  session[:player_name] = params[:player_name]
  redirect '/bet'
end

get '/bet' do
  session[:player_bet] = nil
  erb :bet
end

post '/bet' do
  if params[:bet_amount].nil? || params[:bet_amount].to_i == 0
    @error = "Make a bet"
    halt erb(:bet)
  elsif params[:bet_amount].to_i > session[:player_pot]
    @error = "Bet amount cannot be greater than what you have ($#{session[:player_pot]})"
    halt erb(:bet)
  else
    session[:player_bet] = params[:bet_amount].to_i
    redirect '/game'  
  end
end

get '/game' do
  session[:turn] = session[:player_name]
  session[:player_cards] = []
  session[:dealer_cards] = []

  set_deck
  deal

  erb :game
end

post '/player/hit' do
  session[:player_cards] << session[:deck].pop

  player_total = calculate_total(session[:player_cards])
  if player_total == BLACKJACK_AMOUNT
    winner!("#{session[:player_name]} has blackjack.")
  elsif player_total > BLACKJACK_AMOUNT
    loser!("#{session[:player_name]} went bust.")
  end

  erb :game
end

post '/player/stay' do
  @success = "#{session[:player_name]} stays."
  @show_hit_or_stay = false
  redirect '/dealer'
end

get '/dealer' do
  session[:turn] = "dealer"
  @show_hit_or_stay = false

  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == BLACKJACK_AMOUNT
    loser!("Dealer hit blackjack.")
  elsif dealer_total > BLACKJACK_AMOUNT
    winner!("Dealer went bust at #{dealer_total}.")
  elsif dealer_total >= DEALER_MIN_HIT
    redirect '/game/compare'
  else
    @show_dealer_hit = true
  end

  erb :game
end
  
post '/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect 'dealer'
end

get '/game/compare' do
  @show_hit_or_stay = false

  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])

  if player_total < dealer_total
    loser!("#{session[:player_name]} has #{player_total} and the dealer has #{dealer_total}.")
  elsif player_total > dealer_total
    winner!("#{session[:player_name]} has #{player_total} and the dealer has #{dealer_total}.")
  else
    draw!("Tied at #{player_total}.")
  end  
       
  erb :game 
end

get '/game_over' do
  erb :game_over
end