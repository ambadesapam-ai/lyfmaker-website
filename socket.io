// backend/socket.js
const socketio = require('socket.io');

module.exports = function(server) {
  const io = socketio(server, {
    cors: {
      origin: process.env.FRONTEND_URL,
      methods: ["GET", "POST"]
    }
  });

  io.on('connection', (socket) => {
    console.log('New WebRTC connection:', socket.id);
    
    // Join call room
    socket.on('join-call', (callId) => {
      socket.join(callId);
    });
    
    // WebRTC signaling
    socket.on('signal', ({ callId, signal }) => {
      socket.to(callId).emit('signal', signal);
    });
    
    socket.on('disconnect', () => {
      console.log('User disconnected:', socket.id);
    });
  });
  
  return io;
};
