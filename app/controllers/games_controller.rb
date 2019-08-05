require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @word = params["word"]

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    api_serialized = open(url).read
    api = JSON.parse(api_serialized)
    @counter = 0

    if api["found"] == true

      @word.split('').each do |c|
        if params["letters"].split('').include? "#{c}"
          params["letters"].split('').each do |el|
            if el == c
              @counter += 1
              params["letters"].split('').delete(el)
              break
            end
          end
        else
          @answer = "The word can't be built out of the original grid"
        end
      end

    else
      @answer = "It's not a valid English word"
      @counter = 0
    end

    if session["score"].nil?
      session["score"] = @counter
    else
      session["score"] += @counter
    end
    @session = session["score"]
  end
end
