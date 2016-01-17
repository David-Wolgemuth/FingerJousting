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
        io.sockets.emit("all-users", users_array);
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
    games[id] = {};
    games[id].currentPlayer = socketA;
    games[id].reversedPlayer = socketB;
    games[id].board = [1, 1, 1, 1];
    games[id].sockets = [socketA, socketB];

    users[socketA].socket.emit("start-game", [id, true]);
    users[socketA].socket.on("game-move", function(data) {
        updateGame(id, socketA, data);
    })

    users[socketB].socket.emit("start-game", [id, false]);
    users[socketB].socket.on("game-move", function(data) {
        updateGame(id, socketB, data);
    })
    
}

function updateGame(game, socketID, move) {
    var toSelf = false;
    var gameOver = false;
    
    if (move[0] + move[1] == 5) {
        toSelf = true;
    }

    if (socketID == games[game].reversedPlayer) {
        move[0] = 3 - move[0];
        move[1] = 3 - move[1];
    }

    var board = games[game].board;

    if (toSelf) {
        board[move[1]] = (board[move[0]] / 2);
        board[move[0]] /= 2;
    } else {
        board[move[1]] += board[move[0]];
    }

    if (board[move[1]] >= 5) {
        board[move[1]] = 0;
    }

    var socketA = games[game].sockets[0];
    var socketB = games[game].sockets[1];

    if (board[0] + board[1] == 0 || board[2] + board[3] == 0) {
        games[game] = null;
        users[socketA].socket.emit("game-over")
        users[socketB].socket.emit("game-over")
    }

    if (socketA == games[game].reversedPlayer) {
        users[socketA].socket.emit("game-board", games[game].board.slice(0).reverse());
    } else {
        users[socketA].socket.emit("game-board", games[game].board);    
    }
    if (socketB == games[game].reversedPlayer) {
        users[socketB].socket.emit("game-board", games[game].board.slice(0).reverse());
    } else {
        users[socketB].socket.emit("game-board", games[game].board);    
    }
}