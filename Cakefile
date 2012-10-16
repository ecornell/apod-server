{exec} = require 'child_process'

task 'sbuild', 'Build project', ->
    exec 'coffee -cl -o . .', (err, stdout, stderr) ->
          # throw err if err
          # 	console.log stdout + stderr
