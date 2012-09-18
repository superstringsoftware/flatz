#because of a stupid move had to decompile from javascript, so it's not real coffee

Dogs = new Meteor.Collection("dogs")
Persons = new Meteor.Collection("persons")
Kennels = new Meteor.Collection("kennels")

reset_data = ->
  Dogs.remove {}
  Persons.remove {}
  Kennels.remove {}
  kennels_tmp = [["Солнце Балтии", "Solntse Baltii", "Наталья Чижова", "Санкт-Петербург", "http://www.solntsebaltii2007.narod.ru/"]]
  dogs_tmp = [["Meeka", "brown", "21/12/2002"], ["Uta", "black", "30/10/2004"], ["Toma", "brown", "21/08/2007"]]
  _results = []
  _i = 0
  _len = dogs_tmp.length

  while _i < _len
    dg = dogs_tmp[_i]
    _results.push Dogs.insert(
      name: dg[0]
      color: dg[1]
      date: dg[2]
    )
    _i++
  _results

if Meteor.is_client
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
    reset_data()  if Dogs.find().count() is 0
