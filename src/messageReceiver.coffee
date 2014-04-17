#!/usr/bin/env coffee

Redis = require('redis')
Pubsub = Redis.createClient()

# The 'node_redis' package doesn't let you specify
# a callback for publish() unless it's part of a multi() chain.
Pubsub.multi()
  .publish('hubot:incoming-imessage', JSON.stringify {
    message: process.argv[process.argv.length-2]
    userId: process.argv[process.argv.length-3]
    name: process.argv[process.argv.length-1]
  }).exec (err, replies) ->
    process.exit(err ? 1 : 0)

