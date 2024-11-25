require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = alphabet.sample(9)
  end

  def score
    @word = params[:word]
    @grid = JSON.parse(params[:grid])
    @score = session[:score]
    if !search_dict
      @result = "Sorry, but #{@word} doesn't seem to be a valid English word..."
    elsif !check_in_grid
      @result = "Sorry, but #{@word} can't be build out of #{@grid.join(",")} "
    else
      @result = "Congratulations! #{@word.capitalize} is a valid English word!"
      @score = (session[:score] += @word.length)
    end
  end

  private

  def search_dict
    dict_result = JSON.parse(URI.open("https://dictionary.lewagon.com/#{@word}").read)
    dict_result["found"]
  end

  def check_in_grid
    grid_copy = @grid.dup
    @word.upcase.chars.all? do |char|
      if grid_copy.include?(char)
        grid_copy.delete_at(grid_copy.index(char))
        true
      else
        false
      end
    end
  end
end
