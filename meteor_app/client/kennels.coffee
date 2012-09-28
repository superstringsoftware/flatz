#hack(?) to set the "selected" property on the current_kennel from Session in the dropdown list
#there may be a better way to do it via helpers as we are mixing controller with a view here
Template.kennels_list.rendered = ->
	nst = @find("##{Session.get("current_kennel_id")}")
	if nst
		nst.setAttribute("selected","selected")
		#console.log(nst,nst.nodeName,nst.attributes)

#rest of kennel_list methods, properties & events
_.extend Template.kennels_list,
  kennels: ->
    Kennels.find {}, sort: {ru_name: 1}

  current_kennel: ->  	
  	kid = Session.get("current_kennel_id")
  	ck = if kid then Kennels.findOne {_id:kid} else Kennels.findOne {}, sort: {ru_name: 1}
  	if ck
  		gid = ck._id
  		Session.set("current_kennel_id",gid)
  	ck
  	
  events:
    #need some niceties - resetting current kennel to something that makes sense etc
    "click #remove_kennel": ->
      kid = Session.get("current_kennel_id")
      Kennels.remove kid if kid
      #Kennels.remove _id:current_kennel._id

    "change #current_kennel": ->
      Session.set("current_kennel_id",$("#current_kennel").val())

    "click #add_kennel_button": (evt) ->
      input = undefined
      console.log("Add new kennel pressed!")
      input = $("#kennel_name")
      if input.val()
        Kennels.insert
          name: input.val()
          ru_name: $("#kennel_ru_name").val()
          city: $("#kennel_city").val()
          owner: $("#kennel_owner").val()
          url: $("#kennel_url").val()
          

        input.val ""
        $("#kennel_ru_name").val ""
        $("#kennel_city").val ""
        $("#kennel_owner").val ""
        $("#kennel_url").val ""
        
      

 