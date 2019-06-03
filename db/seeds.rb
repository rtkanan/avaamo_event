# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'
require 'date'

# ============
# Seed Users
# ============
puts "\n\n Seed Users"
csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  phone, ext = row['phone'].split(/ ?x/)
  phone.gsub!(/[\s+()-\.]/,'')
  # puts ext.nil? ? phone : phone + " x" + ext

  user = User.find_or_initialize_by(email: row['email'])
  user.username = row['username']
  user.phone = phone
  user.ext = ext unless ext.nil?
  user.password = 'qwerty'
  user.password_confirmation = 'qwerty'
  user.save!

  puts "#{user.email} saved"
end


# ============
# Seed Events
# ============

# /Users/kannah/workspace/ruby/avaamo_event/lib/seeds

puts "\n\n Seed Events"
events_text = File.read(Rails.root.join('lib', 'seeds', 'events.csv'))
events = CSV.parse(events_text, :headers => true)
events.each do |e|
  event = Event.where(title: e['title'], starttime: DateTime.parse(e['starttime']),
    endtime: DateTime.parse(e['endtime'])).first
  if event
    puts "Event '#{event.title}'' already created"
  else
    event = Event.new
    event.title = e['title']
    event.description = e['description']
    event.starttime = DateTime.parse(e['starttime'])
    event.allday = (e['allday'] == "TRUE") ? true : false

    endtime = DateTime.parse(e['endtime'])
    event.is_complete = DateTime.now > endtime ? true : false
    event.endtime = endtime unless event.allday

    # TODO: Process RSVPs

    event.save!

    puts "Created Event '#{event.title}'"
  end
end