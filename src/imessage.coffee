{User, Robot, Adapter, Message, TextMessage, Response} = require('hubot')
AppleScript = require('applescript')
path = require('path')

Redis = require("redis")
Pubsub = Redis.createClient()
Pubsub.subscribe('hubot:incoming')

class iMessageAdapter extends Adapter
  send: (envelope, strings...) ->
    user = envelope.user.id
    if user in @allowedUsers
      script = path.resolve(__dirname, 'Send iMessage.applescript')
      for message in strings
        AppleScript.execFile script,
          [user, message],
          (err, rtn) ->

  reply: (envelope, strings...) ->
    @send envelope, strings...

  run: ->
    @allowedUsers = process.env.HUBOT_IMESSAGE_HANDLES.split(",")
    Pubsub.on 'message', (channel, dataString) =>
      data = JSON.parse(dataString)
      if data.userId in @allowedUsers
        user = @userForId data.userId
        user.name = data.name
        user.room = "iMessage"

        msg = "#{@robot.name} #{data.message}"
        @receive new TextMessage(user, msg)
    @emit 'connected'

exports.use = (robot) ->
  new iMessageAdapter robot