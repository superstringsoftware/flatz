_.extend Template.dogPage,

  created: ->
  	Session.set("editing_dog", false)

  currentDog: ->
    kid = Session.get("current_dog_id")
    TL.info("current dog id is " + kid)
    cd = if kid then Dogs.findOne {_id:kid} else Dogs.findOne {}, sort: {name: 1}
    TL.info("found dog " + cd?.name)
    Session.set("current_dog_id",cd._id) if cd
    cd

  isEditing: ->
  	TL.verbose("isEditing helper called")
  	ed = Session.get("editing_dog")
  	TL.verbose("editing_dog is " + ed)
  	ed

  events:
  	"dblclick .dogPage": (evt)->
  		TL.verbose("Dog table double-clicked")
  		Session.set("editing_dog", true)
  		Meteor.flush()

  	"keyup .dogPage": (evt)->
  		TL.verbose("Pressed key " + evt.which)
  		#ESC pressed, cancelling all edits
  		if evt.which is 27
  			Session.set("editing_dog",false)
  		else
  		# return pressed, recording edits.
  		#TODO: add validation
  			if evt.which is 13
  				kid = Session.get("current_dog_id")
  				fn = (nm)->
  					$("[name*=#{nm}]").val()
  				TL.info("Recording changes to the dog: " + kid + " owned by " + fn("owner") + " imported from " + fn("imported_from"))

  				Dogs.update(_id:kid,
  					$set:
  					  
				      system: fn("system")
				      pedigree: fn("pedigree")
				      #name: dg[3]
				      sex: fn("sex")
				      birthdate: fn("birthdate")
				      color: fn("color")
				      microchip: fn("microchip")
				      brand: fn("brand")
				      father: fn("father")
				      mother: fn("mother")
				      owner: fn("owner")
				      city: fn("city")
				      breeder: fn("breeder")
				      imported_from: fn("imported_from")
				      
  					)
  				Session.set("editing_dog",false)
  		Meteor.flush()

_.extend Template.newDogModalTemplate,

  events:
    "click #btnAddNewFlat": (evt)->
      TL.verbose("Add New Flat clicked")
      #TODO: need to figure out the correct selector - for cases where we may have multiple elements with a given name!!!
      fn = (nm)->
        $("[name*=#{nm}]").val()
      TL.info("Recording changes to the dog: " + fn("name") + " owned by " + fn("owner"))
      kid = 
        Dogs.insert
          system: fn("system")
          pedigree: fn("pedigree")
          name: fn("name")
          sex: fn("sex")
          birthdate: fn("birthdate")
          color: fn("color")
          microchip: fn("microchip")
          brand: fn("brand")
          father: fn("father")
          mother: fn("mother")
          owner: fn("owner")
          city: fn("city")
          breeder: fn("breeder")
          imported_from: fn("imported_from")
      if kid
        Session.get("current_dog_id", kid)
        TL.info("Added dog " + kid)
        