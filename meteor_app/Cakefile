#read https://github.com/jashkenas/coffee-script/wiki/[HowTo]-Compiling-and-Setting-Up-Build-Tools for more
fs = require 'fs'

{print} = require 'sys'
{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

preprocess = (callback) ->
	coffee = exec 'ls', (err, stdout,stderr) ->
    	throw err if err
    	console.log stdout + stderr

task 'preprocess', 'run cpp to remove debug info', ->
	preprocess()
