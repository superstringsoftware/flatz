Dogs = new Meteor.Collection 'dogs'

reset_data = -> # Executes on both client and server.
  Dogs.remove {}

  dogs_tmp = [
    ['Meeka','brown','21/12/2002'],
    ['Uta','black','30/10/2004'],
    ['Toma','brown','21/08/2007']
  ]

  for dg in dogs_tmp
    Dogs.insert
      name: dg[0]
      color: dg[1]
      date: dg[2]

if Meteor.is_client

  _.extend Template.navbar,
    events:
      'click .sort_by_name': -> Session.set 'sort_by_name', true
      'click .sort_by_birthdate': -> Session.set 'sort_by_name', false
      'click .reset_data': -> reset_data()

  _.extend Template.leaderboard,
    players: ->
      sort = if Session.get('sort_by_name') then name: 1 else date: -1
      Dogs.find {}, sort: sort

    events:
      'click .sort_by_name': -> Session.set 'sort_by_name', true
      'click .sort_by_birthdate': -> Session.set 'sort_by_name', false

      'click #add_button, keyup #player_name': (evt) ->
        return if evt.type is 'keyup' and evt.which isnt 13 # Key is not Enter.
        input = $('#player_name')
        if input.val()
          Dogs.insert
            name: input.val()
            color: $('#dog_color').val()
            date: $('#dog_birthdate').val()
          input.val ''
          $('#dog_birthdate').val ''

  _.extend Template.player,
    events:
      'click .remove': -> Dogs.remove @_id
      'click': -> $('.tooltip').remove()  # To prevent zombie tooltips.

    enable_tooltips: ->
      # Update tooltips after the template has rendered.
      _.defer -> $('[rel=tooltip]').tooltip()
      ''

# On server startup, create some players if the database is empty.
if Meteor.is_server
  Meteor.startup ->
    reset_data() if Dogs.find().count() is 0
