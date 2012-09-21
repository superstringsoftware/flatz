Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")
  

#function that only lets admins do stuff
require_admin = (userId, docs) ->
  u = Meteor.users.findOne({_id:userId})
  console.log u
  if u.role is "admin"
    true
  else
    false

#setting permissions so that only admin can remove etc
Dogs.allow {
  remove: 
    (userId,docs) ->
      require_admin(userId,docs)
  insert: 
    (userId,docs) ->
      require_admin(userId,docs)
  update: 
    (userId,docs) ->
      require_admin(userId,docs)
  
  }

Kennels.allow {
  remove: 
    (userId,docs) ->
      require_admin(userId,docs)
  insert: 
    (userId,docs) ->
      require_admin(userId,docs)
  update: 
    (userId,docs) ->
      require_admin(userId,docs)
  
  }


Meteor.startup ->
  console.log("Firing up")
  TelescopeLogger.log ("Firing up in TelescopeLogger")
  reset_data()  if Dogs.find().count() is 0
  create_admin()
 