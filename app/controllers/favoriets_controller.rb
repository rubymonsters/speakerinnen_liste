class FavouritesController < ApplicationController

  def index
    @profiles = Profile.find(current_favourites)
  end

  def new
    favourites = cookies[:favourites] || ""
    favourites << params[:profile_id] + "-"
    cookies[:favourites] = { value: favourites, expires: Time.now + 60*60*24*365 }
  end

  def destroy
    favourites = current_favourites
    favourites.delete(params[:profile_id])
    cookies[:favourites] = { value: favourites.join("-"), expires: Time.now + 60*60*24*365 }
  end

  private

  def current_favourites
    (cookies[:favourites] || "").split("-")
  end
end
