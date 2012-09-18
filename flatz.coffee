#because of a stupid move had to decompile from javascript, so it's not real coffee

Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

#TLogger = new TelescopeLogger

#setting permissions on the dogs collection so that only admin can remove
Dogs.allow {
  remove:
    (userId,docs) -> 
      u = Meteor.users.findOne({_id:userId})
      console.log u
      if u.role is "admin"
        true
      else
        false
  #everybody can insert
  insert: 
    () -> true
  }

#creating admin user (server only - sends an email to activate)
create_admin = ->
  console.log("create_admin called")
  if Meteor.users.find({username: "admin"}).count() is 0
    console.log "Creating admin"
    aid = Meteor.createUser({username: "admin", email: "aantich@gmail.com"},{role:"admin"})
    console.log "Created admin", aid


#prepopulating stuff
reset_data = ->
  Dogs.remove {}
  Persons.remove {}
  Kennels.remove {}
  Meteor.users.remove {}
  kennels_tmp = [["Солнце Балтии", "Solntse Baltii", "Наталья Чижова", "Санкт-Петербург", "http://www.solntsebaltii2007.narod.ru/"]]
  dogs_tmp = [["Meeka", "brown", "21/12/2002"], ["Uta", "black", "30/10/2004"], ["Toma", "brown", "21/08/2007"]]

  for dg in dogs_tmp
  
    Dogs.insert
      name: dg[0]
      color: dg[1]
      date: dg[2]
    
  for kn in kennels_tmp
    Kennels.insert
      ru_name: kn[0]
      name: kn[1]
      owner: kn[2]
      city: kn[3]
      url: kn[4]
  

if Meteor.is_client
  
  _.extend Template.navbar,
    events:
      "click .sort_by_name": ->
        Session.set "sort_by_name", true

      "click .sort_by_birthdate": ->
        Session.set "sort_by_name", false

      "click .reset_data": ->
        reset_data()
        #console.log TLogger
        TLogger.log  "reset_date called on the client"

  _.extend Template.leaderboard,
    players: ->
      sort = undefined
      sort = (if Session.get("sort_by_name") then name: 1 else date: -1)
      Dogs.find {},
        sort: sort


    events:
      "click .sort_by_name": ->
        Session.set "sort_by_name", true

      "click .sort_by_birthdate": ->
        Session.set "sort_by_name", false

      "click #add_button, keyup #player_name": (evt) ->
        input = undefined
        return  if evt.type is "keyup" and evt.which isnt 13
        input = $("#player_name")
        if input.val()
          Dogs.insert
            name: input.val()
            color: $("#dog_color").val()
            date: $("#dog_birthdate").val()

          input.val ""
          $("#dog_birthdate").val ""

  _.extend Template.player,
    events:
      "click .remove": ->
        Dogs.remove @_id

      click: ->
        $(".tooltip").remove()

    enable_tooltips: ->
      _.defer ->
        $("[rel=tooltip]").tooltip()

      ""

if Meteor.is_server
  Meteor.startup ->
    console.log("Firing up")
    TLogger.log("Firing up in TelescopeLogger")
    reset_data()  if Dogs.find().count() is 0
    create_admin()

