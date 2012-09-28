_.extend Template.dogPage,

  currentDog: ->
    kid = Session.get("current_dog_id")
    console.log("current dog id is " + kid)
    cd = if kid then Dogs.findOne {_id:kid} else Dogs.findOne {}, sort: {name: 1}
    console.log("found dog " + cd?.name)
    Session.set("current_dog_id",cd._id) if cd
    cd

