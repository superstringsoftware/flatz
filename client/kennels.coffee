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
    "change #current_kennel": ->
      Session.set("current_kennel_id",$("#current_kennel").val())


 