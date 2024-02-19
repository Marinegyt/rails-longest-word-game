require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { Array('A'..'Z').sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase

    wagon_dlc = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read)

    if attempt_valid?(@word, @letters)
      if wagon_dlc['found']
        @result = "Congratulation! #{@word.upcase} is a valid English word."
      else
        @result = "Sorry but #{@word.upcase} is not english."
      end
    else
      @result = "Sorry #{@word.upcase} can't be built out of #{@letters}"
    end
  end

  def attempt_valid?(word, letters)
    @letters_count = letters.split.tally.sort_by { |_key, value| -value }.to_h
    @word_count = word.chars.tally.sort_by { |_key, value| -value }.to_h
    @word_count.each do |key, _value|
      return false unless @letters_count.key?(key) && @letters_count[key] >= @word_count[key]
    end
    return true
  end
end
