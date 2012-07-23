{Adapter,TextMessage} = require 'hubot'

io = require('socket.io').listen process.env PORT or 8080

class SocketIO extends Adapter

  constructor: (@robot) ->
    super @robot

  send: (user, strings...) ->
    io.sockets.emit 'send', str for str in strings

  reply: (user, strings...) ->
    for str in strings
      io.sockets.emit 'reply', "#{user.name}: #{str}"

  run: ->
    io.configure ->
      io.set 'transports', ['xhr-polling']
      io.set 'polling duration', 10

    io.sockets.on 'connection', (socket) =>

      socket.on 'message', (message) =>
        user = @userForId '1', name: 'Try Hubot', room: 'TryHubot'
        @receive new TextMessage user, message
