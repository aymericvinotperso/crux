class UserActivitiesController < ApplicationController
  before_action :init_mark_down_parser, only: :show

  def update
    @user_activity = UserActivity.find_by(user: current_or_guest_user, activity: user_activity_params[:activity_id])
    @user_activity.update!(user_activity_params)
    @user_activity.update!(level: nil) if @user_activity.level == "Niveau ?"
    head 200
  end

  def show
    @city = City.find(params[:city_id])
    @trip = Trip.find(params[:trip_id])
    @user_activity = UserActivity.find(params[:id])
    @activity = Activity.find(@user_activity.activity_id)
    @mountain_range = @city.mountain_range
    @favorite_itinerary = FavoriteItinerary.new

    if params[:query].present? && !params[:query].blank?
      @itineraries = Itinerary.where("name ILIKE ?", "%#{params[:query]}%")[0..10]
      respond_to do |format|
        format.js { render partial: 'search-results', locals: {search_result_itineraries: @itineraries, favorite: @favorite_itinerary, trip: @trip}}
      end
      # @itineraries = Itinerary.where(name: params[:query])
    elsif @trip.validated
      @itineraries = @trip.itineraries.distinct.order(picture_url: :asc)
    else
      @itineraries = @city.itineraries.where(activity_id: @activity.id, universal_difficulty: @user_activity.level.downcase)
                                      # .where.not("equipment_rating = 'P1'")
    end

    @itineraries = @itineraries.to_a.sort_by { |itinerary| itinerary.score}.reverse


    # Mapbox
    @markers = @itineraries.map do |itinerary|
      {
        lng: itinerary.coord_long,
        lat: itinerary.coord_lat,
        infoWindow: render_to_string(partial: "info_iti", locals: { itinerary: itinerary }),
        image_url: helpers.asset_url('https://cdn.iconscout.com/icon/premium/png-256-thumb/mountain-233-793712.png')
      }
    end
  end

  def update_trip
    redirect_to new_user_registration_path and return if current_user.nil?

    @trip = Trip.find(params[:trip_id])
    city = City.find(params[:city_id])
    user_activity = UserActivity.find(params[:id])

    if @trip.validated
      @trip.validated = false
    else
      @trip.validated = true
      @trip.city = city
      @trip.user_activity = user_activity
    end

    @trip.save!

    if @trip.validated
      flash[:notice] = "Tes itinéraires sont sauvegardés, directement accessibles depuis 'Mes sorties'"
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def init_mark_down_parser
    renderer = Redcarpet::Render::HTML.new(no_images: true)
    @markdown = Redcarpet::Markdown.new(renderer)
  end

  def user_activity_params
    params.require(:user_activity).permit(:level, :activity_id)
  end
end
