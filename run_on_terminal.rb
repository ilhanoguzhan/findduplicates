require_relative "models/person"
require_relative "app_controller"

puts "Enter file name"
type = gets.chomp

duplicates, singles = Person.grouped_duplicates(type)

AppController.new.print_stdout(duplicates, singles)