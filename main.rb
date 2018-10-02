require 'sinatra/base'
require 'sinatra/activerecord'
# hot reloading for sinatra
require 'sinatra/reloader'

# requires anything in the lib folder
Dir['./lib/*.rb', './models/*.rb'].each { |f| require f }

class Main < Sinatra::Base
  before do
    new_address
  end

  get '/' do
    locations = Location.all
    p locations.to_json
    erb :index, :locals => { :locations => locations }
  end

  post '/geocode' do
    # guard statement -- needs an error
    return unless params['street'].present? and params['city'].present? and params['state'].present? and params['country'].present?

    coords = @address.reverse_geocode(params['street'], params['city'], params['state'], params['country'])

    location = Location.new(
      lat: coords[0],
      lng: coords[1],
      full_address: parse_full_address(params['street'], params['city'], params['state'], params['country'])
    )

    if location.save
      redirect '/'
    else
      redirect '/error'
    end
  end

  post '/reverse_geocode' do
    return unless params['lat'].present? or params['lng'].present? # guard statement -- needs an error

    address = @address.geocode(params[:lat], params[:lng])

    location = Location.new(
      lat: params['lat'],
      lng: params['lng'],
      full_address: address
    )

    if location.save
      redirect '/'
    else
      redirect '/error'
    end
  end

  protected

  def parse_full_address(street, city, state, country)
    [street, city, state, country].compact.join(', ')
  end

  def new_address
    @address ||= Address.new
  end
end
