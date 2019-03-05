<div class="container">
  <h3>Choisis ton camp de base</h3>

    <div class="basecamps-activities-container" data-ors-api-key="<%= ENV['ORS_API_KEY'] %>">
      <div class="row">
        <% @basecamps_activities.each do |base| %>
          <div class="col s12 m4">
            <h4 class="header"><%= base.basecamp.name.encode("iso-8859-1").force_encoding("utf-8")%></h4>
            <div class="card card-basecamp-activity horizontal small">
              <div class="card-image">
                <% if base.activity.name == "ski de randonnée" %>
                  <%= image_tag "ski.png" %>

                <% elsif base.activity.name == "alpinisme" %>
                  <%= image_tag "alpi.png" %>
                <% elsif base.activity.name == "escalade" %>
                  <%= image_tag "escalade.png" %>
                <% end %>
              </div>
              <div class="card-stacked">
                <div class="card-content" data-coords="<%= { ori_lat: @trip.coord_lat, ori_long: @trip.coord_long, desti_lat: base.basecamp.coord_lat, desti_long: base.basecamp.coord_long }.to_json %>">
                  <h4><%= base.activity.name.capitalize.split(" ")[0] %></h4>
                  <br>
                  <p id="itinerary-number"><strong><%= base.nb_itineraries %></strong> itinéraires</p>
                  <br>
                  <p><img src="<%= "http:" + base.basecamp.weather.forecast[0]["day"]["condition"]["icon"].to_s %>" style="width: 32px; height: 32px;"> <%= base.basecamp.weather.forecast[0]["day"]["avgtemp_c"].to_s.gsub(".", ",") %>°C</p>
                </div>
                <div class="card-action">
                  <div class="left-align">
                    <%= link_to "Go !", trip_basecamps_activity_path(@trip, base), class: "waves-effect waves-light btn" %>
                    <button class="waves-effect waves-light btn secondary">+</button>

          <% end %>
          </div>
        </div>
        <div id="map-ba">
          <div class="slide-container" id="content-map">
            <%= render partial: "mapbox" %>
          </div>
        </div>


    </div>
  </div>





=======
          </div>
        <% end %>
      </div>
    </div>
>>>>>>> master
</div>

