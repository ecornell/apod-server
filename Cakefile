{exec} = require 'child_process'

task 'sbuild', 'Build project', ->
    exec 'coffee -cl -o . .'

task 'watch', 'watch project', ->
    child = exec 'supervisor -w *.coffee --ignore node_modules apod-server.coffee'
    child.stdout.on 'data', (data) -> console.log data