Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

_.extend Template.navbar,
  events:
    "click .sort_by_name": ->
      Session.set "sort_by_name", true

    "click .sort_by_birthdate": ->
      Session.set "sort_by_name", false

    "click .reset_data": ->
      reset_data()
      #console.log TLogger
      TelescopeLogger.log  "reset_date called on the client"

