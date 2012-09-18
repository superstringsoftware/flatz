#root = exports ? this

_global_logs = new Meteor.Collection 'telescope_logs'

_global_logs.allow {
  insert:
    () -> true
}

class TelescopeLogger
  constructor: (log_level = 0) ->
    
    @_logs = _global_logs
    @LOGLEVEL_ERROR = 0
    @LOGLEVEL_INFO = 1
    @LOGLEVEL_VERBOSE = 2
    @currentLogLevel = log_level

  log: (msg, log_type = @LOGLEVEL_ERROR, timestamp = new Date(), loglevel = @currentLogLevel) ->

    #@_logs ?= new Meteor.Collection 'telescope_logs'
    if loglevel >= @currentLogLevel
      @_logs.insert
        message: msg
        logType: log_type
        timestamp: timestamp

      console.log(msg)

  getLogs: ->
    ttt = @_logs.find {}

TLogger = new TelescopeLogger(0)


###

