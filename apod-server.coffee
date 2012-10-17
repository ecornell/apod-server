config = require("./config")

async = require("async")
restify = require("restify")
server = restify.createServer({
    name: 'APOD-Server'
  })
rc = require("redis").createClient()

#-------

getSysInfo = (req, res, next) ->
  
  res.header "Content-Type", "text/plain"

  async.parallel
    info: (callback) ->
      rc.info (err, reply) ->
        callback null, reply
    top: (callback) ->  
      rc.zrevrange "apod:rank", 0, -1, (err, reply) ->
        callback null, reply

  , (err, results) ->

    body = results.info + "\r\r" + results.top

    res.header "Content-Length", Buffer.byteLength( body )
    res.send body

getInfo = (req, res, next) ->
  
  key_id = "apod:" + req.params.photoid

  async.parallel
    score: (callback) ->
      rc.zscore "apod:rank", key_id, (err, reply) ->
        callback null, reply

  , (err, results) ->

    res.send results.score

putVote = (req, res, next) ->

  key_id = "apod:" + req.params.photoid
  key_votes = key_id + ":votes"
  key_score = key_id + ":total_score"

  rc.incr key_votes
  rc.incrby key_score, req.params.score

  async.parallel
    votes: (callback) ->
      rc.get key_votes, (err, reply) ->
        callback null, reply
    score: (callback) ->
      rc.get key_score, (err, reply) ->
        callback null, reply

  , (err, results) ->
    
    avg = results.score / results.votes
    rc.zadd "apod:rank", avg, key_id


  res.send 200, '0'

#------- 

server.use restify.bodyParser()
server.use restify.queryParser()

server.get "/sysinfo", getSysInfo
server.get "/info/:photoid", getInfo
server.put "/vote/:photoid/:score", putVote

server.listen config.web.port, ->
  console.log "%s listening at %s", server.name, server.url


