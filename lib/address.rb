require_relative 'geocoding'

class Address
  attr_accessor :lat, :lng, :full_address

  def reverse_geocode(lat, lng)
	  results = Geocoder.search([lat, lng])
	  results.first.address
  end

  def reverse_geocoded?
    if @lat and @lng
      true
    else
      false
    end
  end

  def geocode(full_address)

    @full_address = full_address

	  results = Geocoder.search(@full_address)

    return false unless results

    # points = results.first
    #
    # @lat = points[0]
    # @lng = points[1]

    results
  end

  def geocoded?
    if @lat && @lng
      true
    else
      false
    end
  end

  def coordinates
    [@lat, @lng]
  end

  def miles_to(to)
    Geocoder::Calculations.distance_between(@full_address || coordinates, to)
  end
end
