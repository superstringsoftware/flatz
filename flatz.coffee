#because of a stupid move had to decompile from javascript, so it's not real coffee

Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

Dogs.allow 
  remove:
    () -> 
      true

#creating admin user
create_admin = ->
  console.log("create_admin called")
  if Meteor.users.find({name: "admin"}).count() is 0
    console.log "Creating admin"
    Meteor.createUser({username: "admin",email: "aantich@gmail.com",password: "admin"})


#prepopulating stuff
reset_data = ->
  Dogs.remove {}
  Persons.remove {}
  Kennels.remove {}
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
  console.log Kennels

if Meteor.is_client
  create_admin()
  _.extend Template.navbar,
    events:
      "click .sort_by_name": ->
        Session.set "sort_by_name", true

      "click .sort_by_birthdate": ->
        Session.set "sort_by_name", false

      "click .reset_data": ->
        reset_data()

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
    reset_data()  if Dogs.find().count() is 0
    #create_admin

