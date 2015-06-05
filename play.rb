require './db/setup'
require './lib/all'

require 'pry'

class Player
  attr_reader :symbol, :name

  def initialize symbol
    @symbol = symbol
    print "Player #{symbol}! What is your name? "
    @name = gets.chomp
  end
end

class TicTacToe
  attr_accessor :current_player

  def initialize
    @players = [Player.new(:x), Player.new(:o)]
    @board   = Array.new 9

    @current_player = @players.first
  end

  def over?
    winner || board_full?
  end

  def board_full?
    !@board.include?(nil)
  end

  def value_in position
    @board[position.to_i - 1]
  end

  def record_move position
    @board[position.to_i - 1] = @current_player.symbol
  end

  def lines
    [
      [1,2,3],
      [4,5,6],
      [7,8,9],
      [1,4,7],
      [2,5,8],
      [3,6,9],
      [1,5,9],
      [3,5,7]
    ]
  end

  def winner
    lines.each do |line|
      values = line.map { |position| value_in position }
      if values.all? { |v| v == :x }
        return :x
      elsif values.all? { |v| v == :o }
        return :o
      end
    end
    return nil # no winner yet
  end

  def display_board
    "#{display_row(7,8,9)}\n#{display_row(4,5,6)}\n#{display_row(1,2,3)}"
  end

  def display_row a,b,c
    [a,b,c].map { |position| value_in(position) || position }.join ""
  end

  def take_move position
    record_move position
    toggle_players
  end

  def toggle_players
    if @current_player == @players.first
      @current_player = @players.last
    else
      @current_player = @players.first
    end
  end
end

name = [Player.new(:x), Player.new(:o)]

player = User.where(name: name).first
if player
  puts "Welcome back, #{ttt.current_player.name}"
else
  puts "Welcome, new player!"
  player = User.create name: name, wins: 0, losses: 0
end

ttt = TicTacToe.new

until ttt.over?
  puts ttt.display_board
  print "#{ttt.current_player.name} - where would you like to play?"

  move = gets.chomp
  ttt.take_move move
end

if ttt.winner
  puts "#{ttt.current_player.name} wins!"
  player.wins += 1
else
  puts "It's a draw"
end
player.save

player.stat.create!(won: ttt.winner)

puts "You've won #{ttt.current_player.wins}"
binding.pry
