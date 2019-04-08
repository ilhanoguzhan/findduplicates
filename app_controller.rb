require 'json'
require_relative 'models/person'

class AppController
  attr_accessor :request
  CONTENT_TYPE = { "Content-Type" => "application/json" }

  def route request
    @request = request
    # puts "Requested method: '#{request.env['REQUEST_METHOD']}', path: '#{request.env['REQUEST_PATH']}', at: #{Time.now}"
    if request.env['REQUEST_PATH'] == '/'
      [ 200, CONTENT_TYPE, [root]]
    else
      [ 400, CONTENT_TYPE , ["Not Found"] ]
    end
  end

  def root
    type = "normal"
    type = "advanced" unless @request.params['advanced'].nil? # checks parameters if user requested advanced data

    duplicates, singles = Person.grouped_duplicates(type)

    print_stdout(duplicates, singles)

    {duplicates: duplicates.map {|x| x.to_hash}, singles: singles.map {|x| x.to_hash}}.to_json
  end

  def print_stdout(duplicates, singles)
    puts "\nPotential Duplicates (#{duplicates.size})\n\n"
    duplicates.each do |duplicate_group|
      duplicate_group.records.each do |person|
        puts person.full_info
      end
      puts "------------------------------"
    end

    puts "\n\nNones Duplicates (#{singles.size})\n\n"
    singles.each do |person|
      puts person.full_info
    end
  end

end