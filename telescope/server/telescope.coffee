#(exports ? this).Telescope = Telescope
#(exports ? this).Telescope.logger = Telescope.logger
#(exports ? this).Telescope.logger.log = Telescope.logger.log # http://stackoverflow.com/questions/4214731/coffeescript-global-variables

# The publicly accessible Singleton fetcher

###
class Telescope
  _instance = undefined # Must be declared here to force the closure on the class
  @logger: (@args) -> # Must be a static method
    _instance ?= new _Telescope args
###

class TelescopeLogger
  constructor: (log_level = 0) ->

    @_logs = new Meteor.Collection 'telescope_logs'
    @LOGLEVEL_ERROR = 0
    @LOGLEVEL_INFO = 1
    @LOGLEVEL_VERBOSE = 2
    @currentLogLevel = log_level

  log: (msg, log_type = @LOGLEVEL_ERROR, timestamp = 0, loglevel = @currentLogLevel) ->

    #@_logs ?= new Meteor.Collection 'telescope_logs'
    if loglevel >= @currentLogLevel
      @_logs.insert
        message: msg
        logType: log_type
        timestamp: timestamp

      console.log(msg)

  getLogs: ->
    ttt = @_logs.find {}




###

