{Adapter,TextMessage} = require 'hubot'

port = parseInt process.env.HUBOT_SOCKETIO_PORT or 9090

io = require('socket.io').listen port

if process.env.HEROKU_URL 
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling-duration", 10

class SocketIO extends Adapter

  constructor: (@robot) ->
    @sockets = {}
    super @robot

  send: (user, strings...) ->
    socket = @sockets[user.id]
    socket.emit 'message', str for str in strings

  reply: (user, strings...) ->
    socket = @sockets[user.id]
    for str in strings
      socket.emit 'message', "#{user.name}: #{str}"

  run: ->
    io.sockets.on 'connection', (socket) =>
      @sockets[socket.id] = socket

      socket.on 'message', (message) =>
        user = @userForId socket.id, name: 'Try Hubot', room: socket.id
        @receive new TextMessage user, message

      socket.on 'disconnect', =>
        delete @sockets[socket.id]

    @emit 'connected'

exports.use = (robot) ->
  new SocketIO robot
