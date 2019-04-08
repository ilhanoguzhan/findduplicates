require_relative 'application_model'
require_relative 'address'
require_relative 'duplicate_people_group'
require_relative '../lib/third_party_sources'

class Person < ApplicationModel
  extend ThirdPartySources

  attr_accessor :id, :first_name, :last_name, :company, :email, :phone  # defines instance variables
  attr_accessor :address, :full_address # Address is nested object related with Address class

  def initialize(params) # constructor method accepts flexible parameters
    params.each do |key, value|
      instance_variable_set("@#{key}", value) # sets instance variables
    end
  end

  def build_address(params) # simple helper method for creating nested address object
    @address = Address.new(params)
    @full_address = @address.full_address
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def full_info
    "#{self.id}, #{self.first_name}, #{self.last_name}, #{self.company}, #{self.email}, #{self.address.full_address}, #{self.phone}"
  end

  def self.grouped_duplicates(type = "normal")
    DuplicatePeopleGroup.group_records(load_people(type))
  end

end