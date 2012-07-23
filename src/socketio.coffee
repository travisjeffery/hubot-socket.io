{Adapter,TextMessage} = require 'hubot'

port = parseInt process.env.HUBOT_SOCKETIO_PORT or 9090

io = require('socket.io').listen port

class SocketIO extends Adapter

  send: (user, strings...) ->
    io.sockets.emit 'message', str for str in strings

  reply: (user, strings...) ->
    for str in strings
      io.sockets.emit 'message', "#{user.name}: #{str}"

  run: ->
    io.sockets.on 'connection', (socket) =>
      socket.on 'message', (message) =>
        user = @userForId '1', name: 'Try Hubot', room: 'TryHubot'
        @receive new TextMessage user, message

    @emit 'connected'

exports.use = (robot) ->
  new SocketIO robot
