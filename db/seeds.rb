require 'csv'
require 'date'

# ============
# Seed Users
# ============
puts "\n\n Seed Users"
csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv = CSV.parse(csv_text, :headers => true)
users = []

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
  users << user
end
user_summary = User.import users


# ============
# Seed Events
# ============
puts "\n\n Seed Events"
events_text = File.read(Rails.root.join('lib', 'seeds', 'events.csv'))
events_csv = CSV.parse(events_text, :headers => true)
events = []

events_csv.each do |e|
  event = Event.where(title: e['title'], starttime: DateTime.parse(e['starttime']),
    endtime: DateTime.parse(e['endtime'])).first
  if event
    puts "Event '#{event.title}' already created"
  else
    event = Event.new
    event.title = e['title']
    event.description = e['description']
    event.starttime = DateTime.parse(e['starttime'])
    event.allday = (e['allday'] == "TRUE") ? true : false

    endtime = DateTime.parse(e['endtime'])
    event.is_complete = DateTime.now > endtime ? true : false
    event.endtime = endtime unless event.allday

    # Process RSVPs
    unless e['users#rsvp'].nil?
      rsvps_text = e['users#rsvp'].split(';')
      rsvps_text.each do |rsvp|
        un, status = rsvp.split('#')
        status.downcase!

        user = User.find_by(username: un)
        status = status == 'no' ? 0 : (status == 'yes' ? 1 : 2)
        event.rsvps.build(user: user, status: status)
      end
    end
    events << event
  end
end
event_summary = Event.import events, recursive: true