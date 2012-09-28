Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

#publishing collections
#publishing all kennels (it's not like it's going to be one million of them)
Meteor.publish 'kennels',() ->
  Kennels.find {}

#publishing only those dogs that belong to a certain kennel
#!!! may need to change this as for dog show editing functionality we shouldn't be tied to a kennel but work with ALL dogs rather
Meteor.publish 'dogs', (kennel_id) ->
  Dogs.find 
    kennel_id: kennel_id

#function that only lets admins do stuff
requireAdmin = (userId, docs) ->
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
      requireAdmin(userId,docs)
  insert: 
    (userId,docs) ->
      requireAdmin(userId,docs)
  update: 
    (userId,docs) ->
      requireAdmin(userId,docs)
  
  }

Kennels.allow {
  remove: 
    (userId,docs) ->
      requireAdmin(userId,docs)
  insert: 
    (userId,docs) ->
      requireAdmin(userId,docs)
  update: 
    (userId,docs) ->
      requireAdmin(userId,docs)
  
  }


Meteor.startup ->
  console.log("Firing up")
  TelescopeLogger.log ("Firing up in TelescopeLogger")
  reset_data()  if Dogs.find().count() is 0
  create_admin()
 