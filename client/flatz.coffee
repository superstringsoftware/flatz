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

 _.extend Template.kennels_list,
  kennels: ->
    Kennels.find {}
      

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

_.extend Template.logs,
  log_messages: ->
    TelescopeLogger.getLogs
      timestamp: -1


  

