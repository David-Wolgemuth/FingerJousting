var express = require('express');
var app = express();
var bodyParser = require('body-parser');

app.use(bodyParser.json());

var server = app.listen(8000, function() {
  console.log('App listening on Port 8000');
});

var users = {};
var games = {};

var io = require("socket.io").listen(server);
io.sockets.on("connection", function(socket) {

    console.log(socket.id);
    
    users[socket.id] = {"name": "", messages: []};

    //  listens for username from iPhone
    socket.on("user-name", function(data) {
        users[socket.id].name = data;
        users[socket.id].socket = socket;
        users_array = [];
        for (user in users) {
            users_array.push(users[user].name);
        }
    });

    //  returns all users currently connected
    socket.on("all-users", function(data) {
        users_array = [];
        for (user in users) {
            if (user != socket.id) {
                users_array.push(users[user].name);
            }
        }
        socket.emit("all-users", users_array);
    });

    //  requests another user for game
    socket.on("requestGame", function(data) {
        var otherSocket;
        for (user in users) {
            if (users[user].name == data) {
                otherSocket = user;
            }
        }
        users[otherSocket].socket.emit("user-request", users[socket.id].name);
        users[otherSocket].socket.on("response", function(data) {
            if (data) {
                createGame(socket.id, otherSocket);
            } else {
                socket.emit("game-denied");
            }
        })
    });


    socket.on("disconnect", function() {
        console.log(socket.id, "disconnected");
        delete users[socket.id];
        users_array = [];
        for (user in users) {
            users_array.push(users[user].name);
        }
        io.sockets.emit("all-users", users_array); 
    });
});

function createGame(socketA, socketB) 
{
    var id = socketA + socketB;
    games[id].currentPlayer = socketA;
    games[id].reversedPlayer = socketB;
    games[id][socketA] = [1, 1];
    games[id][socketB] = [1, 1];
    users[socketA].socket.emit("start-game", id);
    users[socketB].socket.emit("start-game", id);
}