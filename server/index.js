const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const documentRouter = require('./routes/document');
const http = require('http');
const Document = require("./models/document");

const PORT = 3001 || process.env.PORT; 


const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

const DB = "mongodb+srv://neeraj:neeraj8281@cluster0.jbhzlmk.mongodb.net/?retryWrites=true&w=majority"
mongoose.connect(DB).then(()=>{
    console.log('database connected!');
}).catch((err)=>{
    console.log(err);
});

io.on('connection',(socket)=>{
    socket.on('join',(documentId)=>{
        socket.join(documentId);
        console.log('joined!');
    });

    socket.on('typing',(data)=>{
        socket.broadcast.to(data.room).emit("changes",data);
    })
    socket.on('save',(data)=>{
        savedata(data);
    })
});
const savedata = async (data)=>{
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
}



server.listen(PORT,"0.0.0.0",()=>{
    console.log(`connected at port ${PORT}`)
});
