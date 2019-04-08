require "damerau-levenshtein"
require_relative 'person'
require_relative 'application_model'

class DuplicatePeopleGroup < ApplicationModel

  # These multipliers can be defined dynamically based on how much the data dirty and when user select and confirm one record is duplicate then we can recalculate here based on the selected group
  # if something want to make it exactly same just write sam number MAX_DIFF with any multiplier in this list
  MAX_DIFF = 32
  FULL_NAME_MULTIPLIER = 3.0 # max diff 10
  COMPANY_MULTIPLIER    = 2.0 # max diff 16
  EMAIL_MULTIPLIER      = 5.0 # max diff 6
  PHONE_MULTIPLIER      = 2.0 # max diff 16
  ADDRESS_MULTIPLIER    = 1.0 # max diff 32

  attr_accessor :records # people seem duplicate in a group it can be more than two records
  attr_accessor :overall_distance_rate
  attr_accessor :full_name_rate, :company_rate, :email_rate, :phone_rate, :address_rate

  def initialize
    @records = Array.new
    @overall_distance_rate = 0.0
    @full_name_rate = 0.0
    @company_rate = 0.0
    @email_rate = 0.0
    @phone_rate = 0.0
    @address_rate = 0.0
  end

  # makes group records and returns groups and singles
  def self.group_records(people)
    groups = Array.new
    individuals = Array.new
    people.delete_at(0)

    people.each_with_index do |person, index_1|
      next if groups.any? {|g| ([person.id] - g.records.map(&:id)).empty?} # if we had matched record before in the sub iteration, then ignores this iteration
      duplicate_group = self.new
      duplicate_group.records.push person

      # here checks remaining records if something is similar
      people.each_with_index do |checking_person, index_2|

        next if index_1 == index_2 # no check if same record
        next if groups.any? {|g| ([person.id, checking_person.id] - g.records.map(&:id)).empty?} # if we had match before then ignores this

        full_name_dis = self.distance(person.full_name, checking_person.full_name) * FULL_NAME_MULTIPLIER # here calculates char differences on two words and multiplies with multiplier
        next if full_name_dis > MAX_DIFF # if differences more than max difference value we break current iteration here.
        company_dis = self.distance(person.company, checking_person.company) * COMPANY_MULTIPLIER
        next if company_dis > MAX_DIFF
        email_dis = self.distance(person.email, checking_person.email) * EMAIL_MULTIPLIER
        next if email_dis > MAX_DIFF
        phone_dis = self.distance(person.phone, checking_person.phone) * PHONE_MULTIPLIER
        next if phone_dis > MAX_DIFF
        address_dis = self.distance(person.address.full_address, checking_person.address.full_address) * ADDRESS_MULTIPLIER
        next if address_dis > MAX_DIFF

        duplicate_group.records.push checking_person

        # extra values for statistics
        duplicate_group.full_name_rate += full_name_dis
        duplicate_group.company_rate += company_dis
        duplicate_group.email_rate += email_dis
        duplicate_group.phone_rate += phone_dis
        duplicate_group.address_rate += address_dis
      end
      if duplicate_group.records.size == 1 # If there is no matches, not adding to group array
        individuals.push person
      else
        duplicate_group.calculate_rates
        groups.push(duplicate_group)
      end
    end
    return groups, individuals
  end

  # here calculates extra values for statistical data also overall_distance_rate can be used for matching similar data in the future
  def calculate_rates
    record_size = (self.records.size / 2)
    if record_size > 0 # if just one unique records there skip calculation
      self.full_name_rate = (self.full_name_rate / record_size).round(1)
      self.company_rate = (self.company_rate / record_size).round(1)
      self.email_rate = (self.email_rate / record_size).round(1)
      self.phone_rate = (self.phone_rate / record_size).round(1)
      self.address_rate = (self.address_rate / record_size).round(1)
      self.overall_distance_rate = ((self.full_name_rate + self.company_rate + self.email_rate + self.phone_rate + self.address_rate) / 5).round(1)
    end
  end

  private
  def self.distance(str1, str2)
    DamerauLevenshtein.distance(str1.to_s, str2.to_s)
  end

end
