var express = require('express');
var app = express();
var bodyParser = require('body-parser');

app.use(bodyParser.json());

var server = app.listen(8000, function() {
  console.log('App listening on Port 8000');
});

var users = {};

var io = require("socket.io").listen(server);
io.sockets.on("connection", function(socket) {

    console.log(socket.id);
    
    users[socket.id] = {"name": "", messages: []};

    socket.on("ToServer", function(data) {
        console.log(data);
    });

    //  listens for username from iPhone
    socket.on("user-name", function(data) {
        console.log("username", data);
        users[socket.id].name = data;
        console.log("usersA", users);
        users_array = [];
        for (user in users) {
            users_array.push(users[user].name);
        }
        // io.sockets.emit("all-users", users_array);
    });
    socket.on("all-users", function(data) {
        console.log("alluser");
        users_array = [];
        for (user in users) {
            if (user != socket.id) {
                users_array.push(users[user].name);
            }
        }
        console.log(users_array)
        console.log("usersB", users)
        socket.emit("all-users", users_array);
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