_.extend Template.dogPage,

  currentDog: ->
    kid = Session.get("current_dog_id")
    TL.info("current dog id is " + kid)
    cd = if kid then Dogs.findOne {_id:kid} else Dogs.findOne {}, sort: {name: 1}
    TL.info("found dog " + cd?.name)
    Session.set("current_dog_id",cd._id) if cd
    cd

