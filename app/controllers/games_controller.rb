require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alpha = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alpha.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @result = Hash.new(0)

    if in_a_grid? && english_word?
      @result[:message] = "Congratulation! #{@word.upcase} is a valid English word!"
    elsif !in_a_grid?
      @result[:message] = "Sorry but #{@word.upcase} can't be build out of #{@grid.split.join(", ")}"
    else
      @result[:message] = "Sorry but #{@word.upcase} does not seem to be valid English word.."
    end
  end

  private 

  def in_a_grid?
    @word.chars.all? do |letter|
      @word.count(letter) <= @grid.count(letter)
    end
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word["found"]
  end
end
