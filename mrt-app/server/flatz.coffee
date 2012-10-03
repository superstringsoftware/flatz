Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

#publishing collections
#publishing all kennels (it's not like it's going to be one million of them)
Meteor.publish 'kennels',() ->
  Kennels.find {}

#publishing dogs
Meteor.publish 'dogs', (all, kennel_id) ->
  if all
    TL.info "returning ALL dogs"
    Dogs.find {}
  else
    TL.info "returning dogs for " + kennel_id
    Dogs.find
      kennel_id: kennel_id

#function that only lets admins do stuff
requireAdmin = (userId, docs) ->
  u = Meteor.users.findOne({_id:userId})
  TL.verbose "Found user " + u
  if u?.role is "admin"
    true
  else
    false

#set correct permissions that only admin can manipulate
setAdminPermissions = (collection)->
  #setting permissions so that only admin can remove etc
  collection.allow
    remove:
      (userId,docs) ->
        requireAdmin(userId,docs)
    insert:
      (userId,docs) ->
        requireAdmin(userId,docs)
    update:
      (userId,docs) ->
        requireAdmin(userId,docs)



#allow the world to do anything
setInsecure = (collection)->
  collection.allow
    remove: true
    insert: true
    update: true

Meteor.startup ->
  TL.info("Firing up in TelescopeLogger")
  #reset_data()  if Dogs.find().count() is 0
  create_admin()

  setAdminPermissions Dogs
  setAdminPermissions Kennels
  setAdminPermissions Meteor.users
  ###
  setInsecure Dogs
  setInsecure Kennels
  ###