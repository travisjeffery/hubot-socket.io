{Adapter,TextMessage} = require 'hubot'

class SocketIO extends Adapter

  constructor: (@robot) ->
    @sockets = {}
    @io = require('socket.io').listen robot.server
    super @robot

  send: (envelope, strings...) ->
    socket = @sockets[envelope.user.id]
    for str in strings
      socket.emit 'message', str

  reply: @prototype.send

  run: ->
    @io.sockets.on 'connection', (socket) =>
      @sockets[socket.id] = socket

      socket.on 'message', (message) =>
        user = @robot.brain.userForId socket.id
        @receive new TextMessage user, message

      socket.on 'disconnect', =>
        delete @sockets[socket.id]

    @emit 'connected'

exports.use = (robot) ->
  new SocketIO robot
