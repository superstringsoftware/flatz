root = exports ? this

_global_logs = new Meteor.Collection 'telescope_logs'

_global_logs.allow {
  insert:
    () -> true
}

###
class TelescopeLogger
  #_instance = undefined # Must be declared here to force the closure on the class
  @getLogger: (args = 0) -> # Must be a static method
    _instance ?= new _TelescopeLogger args
###

class TelescopeLogger
  @_logs = _global_logs
  @LOGLEVEL_ERROR = 0
  @LOGLEVEL_INFO = 1
  @LOGLEVEL_VERBOSE = 2
  @currentLogLevel = 0
  
  #constructor: () ->

  @log: (msg, log_type = @LOGLEVEL_ERROR, timestamp = new Date(), loglevel = @currentLogLevel) ->

    #@_logs ?= new Meteor.Collection 'telescope_logs'
    if loglevel >= @currentLogLevel
      if Meteor.is_server 
        m = "[SERVER]"
      else 
        m = "[CLIENT]"
      m+= ' ' + msg
      @_logs.insert
        message: m
        logType: log_type
        timestamp: timestamp

      console.log(m)

  @getLogs: (sort)->
    @_logs.find {}, sort: sort


###

