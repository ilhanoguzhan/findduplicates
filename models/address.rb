require_relative "application_model"

class Address < ApplicationModel
  attr_accessor :street, :sub_number, :zip, :city, :state_long, :state # defines instance variables

  def initialize(params) # constructor method accepts flexible parameters
    params.each do |key, value|
      instance_variable_set("@#{key}", value)  # sets instance variables
    end
  end

  def full_address
    "#{@street}, #{@sub_number}, #{@city}, #{@state} #{@zip}"
  end
end