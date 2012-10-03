_.extend Template.allDogsPage,
  viewDogs: ->
    sort = undefined
    sort = (if Session.get("sort_by_name") then name: 1 else date: -1)
    Dogs.find {},
      sort: sort

  events:
    "click .fl-paginator": (evt)->
      TL.verbose("Clicked paginator letter " + evt.target.innerText)
      Session.set("current_doglist_name_letter",evt.target.innerText)


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



_.extend Template.dogLine,
  drawColor: (color)->
    if color is "ливер"
      "fl-dog-brown"
    else
      "fl-dog-black"
  
  drawSex: (sex)->
    if sex is "сука" then '/img/glyphicons/png/glyphicons_247_female.png' else '/img/glyphicons/png/glyphicons_246_male.png'

#TODO: need to implement finding dog's id by name. Difficulty is we are only subscribed to the current letter, so need to call a server method.
  findIDbyName: (name)->

  events:
    "click .remove": ->
      Dogs.remove @_id

    "click .fl-dog-name": (evt)->
      kid = evt.target.id
      TL.verbose("Clicked from the " + kid + " dog")
      Session.set("current_dog_id",kid) if kid
      Router.navigate("dog")
      Router.dogPage()


    click: ->
      $(".tooltip").remove()

  

  enable_tooltips: ->
    _.defer ->
      $("[rel=tooltip]").tooltip()