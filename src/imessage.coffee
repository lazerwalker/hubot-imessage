{Robot, User, Adapter, TextMessage} = require('hubot')
AppleScript = require('applescript')

Redis = require("redis")
Pubsub = Redis.createClient()
Pubsub.subscribe('hubot:incoming')

class iMessageAdapter extends Adapter
  send: (envelope, strings...) ->
    user = envelope.user.id
    if user in @allowedUsers
      for message in strings
        AppleScript.execFile '/Users/michaelwalker/Dropbox/Code/hubot-imessage/sendMessage.scpt',
          [user, message],
          (err, rtn) ->
            if (err)
              console.log "Failed!", err

  reply: (envelope, strings...) ->
    @send envelope, strings...

  run: ->
    @allowedUsers = process.env.HUBOT_IMESSAGE_HANDLES.split(",")
    Pubsub.on 'message', (channel, dataString) =>
      data = JSON.parse(dataString)
      if data.user in @allowedUsers
        user = new User(data.user, {name: data.user, room:"iMessage"})#@userForId data.user name: 'iMessage', room: 'iMessage'
        message = new TextMessage user, data.message, 'messageId'
        @receive message
    @emit 'connected'

exports.use = (robot) ->
  new iMessageAdapter robot