class PokemonController < ApplicationController
  def index
  end

  def start
    ap session
    session[:actions] = [] if !session[:actions]
    if !session[:pokemon]
      get_pokemon
    end

    if !session[:caught_pokemon]
      session[:caught_pokemon] = []
    end

      ap session[:pokemon]
  end

  def hit
    session[:actions] = [] if !session[:actions]

    damage = rand(1..20)
    session[:actions].push("You did #{damage} to the #{session[:pokemon]["name"]}!")

    session[:pokemon]["hp"] = session[:pokemon]["hp"] - damage
    if session[:pokemon]["hp"] < 0
      session[:actions].push("You knocked out the #{session[:pokemon]["name"]}!")
      get_pokemon
    end
    redirect_to '/start'
  end

  def catch
    percent_to_catch = session[:pokemon]["hp"].to_f / session[:pokemon]["max_hp"]

    percent_to_catch = (percent_to_catch * 100).to_i

    random_num = rand(0..100)
    puts "percent_to_catch: #{percent_to_catch}"
    if random_num > percent_to_catch
      session[:actions].push("You CAUGHT the wild #{session[:pokemon]["name"]}!")
      session[:caught_pokemon].push(session[:pokemon]["image"])
      get_pokemon
    else
      session[:actions].push("You FAILED to catch the wild #{session[:pokemon]["name"]}!")
    end

    redirect_to '/start'
  end

  private

  def get_pokemon
      number = rand(1..500)
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{number}")
      body = JSON.parse(response.body)
      image = body["sprites"]["front_shiny"]
      hp = body["stats"].first["base_stat"]
      name = body["name"]

      session[:actions].push("You found a wild #{name}!")

      session[:pokemon] = {
        image: image,
        hp: hp,
        max_hp: hp,
        name: name
      }
  end
end
