class RatesController < ApplicationController
  include ActiveMerchant::Shipping

  def address_params
    params.require(:data).permit(:street, :city, :state, :postal_code)
  end

  def rates
    u = USPS.new(:login =>ENV['USPS_USERNAME'])
    o = Location.new(country: "US", city: "Seattle", state: "WA", zip: "98101")
    d = Location.new(address_params)
    p = Package.new(10, [10,10])

    @rate = u.find_rates(o, d, p)

    # usps_rates = @rate.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    rate_quote = []

    # @usps_rates.rates.each do |r|
    #   rate_quote << {service: r.service_name, price: r.price } if r.service_name == "USPS First-Class Mail Parcel"

    @rate.rates.each do |r|
      rate_quote << {service: r.service_name, price: r.price } if r.service_name == "USPS First-Class Mail Parcel"
    end

    render json: rate_quote

    # render json: usps_rates
  end

end
