Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

#publishing collections
#publishing all kennels (it's not like it's going to be one million of them)
Meteor.publish 'kennels',
  () ->
    Kennels.find {}

#publishing only those dogs that belong to a certain kennel
#!!! may need to change this as for dog show editing functionality we shouldn't be tied to a kennel but work with ALL dogs rather
Meteor.publish 'dogs', (kennel_id) ->
  kennel = Kennels.findOne 
    _id:kennel_id
  if kennel
    console.log("Found kennel name: " + kennel.name)
    Dogs.find 
      kennel: kennel.name

    

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
 