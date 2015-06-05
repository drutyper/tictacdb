class User < ActiveRecord::Base
  has_many :stats
  validates_presence_of :wins, :losses

  def last_game
    games.order(played_on: :desc).first
  end
end