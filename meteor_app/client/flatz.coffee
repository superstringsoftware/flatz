Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

#subscribing
# easy for kennels
Meteor.subscribe('kennels')

# subscribing to just current kennel's dogs
Meteor.autosubscribe ->
  kid = Session.get("current_kennel_id")
  console.log("Found kennel id:" + kid)
  Meteor.subscribe 'dogs', kid if kid



_.extend Template.navbar,
  events:
    "click .sort_by_name": ->
      Session.set "sort_by_name", true

    "click .sort_by_birthdate": ->
      Session.set "sort_by_name", false

    "click .reset_data": ->
      #create_admin()
      reset_data()
      #console.log TLogger
      TelescopeLogger.log  "reset_data called on the client"

