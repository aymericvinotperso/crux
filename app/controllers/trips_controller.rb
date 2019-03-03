class TripsController < ApplicationController

  def new
    if current_user != nil
      @user_activities = current_user.user_activities
    else
      @user_activities = []
    end
    @trip = Trip.new
  end

  def index
    # @trips = Trip.where(user_id: current_user.id).order('trips.created_at desc')
    @trips = Trip.all
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    @trip.save!
    redirect_to trip_path(@trip)
  end

  def show
    @user = current_user
    @trip = Trip.find(params[:id])

    # See how many itineraries match the user profile

    basecamps_activities = BasecampsActivity.select("basecamps_activities.*, COUNT(basecamps_activities_itineraries.itinerary_id) as nb_itineraries").joins(:itineraries)
      .joins("INNER JOIN user_activities ON user_activities.activity_id = itineraries.activity_id")
      .where(user_activities: {user_id: current_user.id})
      .where("user_activities.level = itineraries.level")
      .group("basecamps_activities.id")
      .order("COUNT(basecamps_activities_itineraries.itinerary_id) DESC")
      .to_a

    # Compute score also considering weather and localisation ater

    basecamps_activities.sort_by! do |base|
      Math.log(base.nb_itineraries) + base.weather.weekend_score
      # + trip.distance_from(base.basecamp)
    end

    # Take only top 12

    @basecamps_activities = basecamps_activities.reverse[0..11]
  end

  def update
  end

  def edit
  end

  private

  def trip_params
    params.require(:trip).permit(:start_date, :end_date, :location)
  end

end
