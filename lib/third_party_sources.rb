require 'csv' # importing ruby's builtin library for parsing the csv file

module ThirdPartySources
  def load_people(type)
    ProviderValidity.get_from_source(type) + [] # we can add other sources here.
  end

  class ProviderValidity # defining class for per data source (here is only validity)
    # if any extra attribute or methods in the future, will be here

    def self.get_from_source(type)
      records = CSV.read("data/#{type}.csv", encoding: 'utf-8', headers: true) # parsing the file

      i = 0
      records.map do |rec|
        i += 1
        person = Person.new(id: i, first_name: rec[1], last_name: rec[2], company: rec[3], email: rec[4], phone: rec[11]) # creating people object
        person.build_address(street_name: rec[5], sub_number: rec[6], zip: rec[7], city: rec[8], state_long: rec[9], state: rec[10]) # building address for the person
        person
      end
    end
  end
end