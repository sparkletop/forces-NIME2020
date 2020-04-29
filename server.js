// Data bridge between browser and supercollider

const config = require('./config.json');
const express = require('express');
const osc = require('osc');
const io = require('socket.io')();

const logV = (...args) => {
  if (config.verbose) {
    console.log(...args);
  }
};

const OSCPort = new osc.UDPPort(config.supercolliderAddress);

io.on('connection', (socket) => {
  logV('Client connected on socket', socket.id);

  socket.on('OSCmsg', (msg) => {
    OSCPort.send({
      address: msg.OSCaddress,
      args: msg.OSCargs,
    });
  });

  socket.on('disconnect', () => {
    logV('Client disconnected from socket', socket.id);
  });
});

OSCPort.on('ready', () => {
  logV('--- OSC Bridge Ready ---');
  logV(
    'Listening for socket connections from UI on port',
    config.oscBridgePort
  );
  logV(
    'Sending OSC messages to SuperCollider on port',
    OSCPort.options.remotePort
  );
});

io.listen(config.oscBridgePort);

OSCPort.open();

// Serve the user interface with express
const app = express();

app.use(express.static('public'));

app.listen(config.browserPort, 'localhost', () => {
  logV('--- User Interface Ready ---');

  console.log(
    `Visit http://localhost:${config.browserPort} in your browser to view the user interface (press Ctrl-C here to stop server)`
  );
});
