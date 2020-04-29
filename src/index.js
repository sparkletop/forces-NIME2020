import io from 'socket.io-client';
import Hand from './hand';
import Leap from 'leapjs';
import distance3d from './distance3d';
import config from '../config.json';
import ModeBtns from './modeBtns';

document.querySelector('.options').innerHTML = ModeBtns;

const socket = io.connect(`http://localhost:${config.oscBridgePort}`);

const hands = {
  left: new Hand('left', socket),
  right: new Hand('right', socket),
};

let previousFrame = null;

const controller = Leap.loop({ enableGestures: false }, (frame) => {
  // send the number of active hands
  socket.emit('OSCmsg', {
    OSCaddress: '/data/numHands',
    OSCargs: [
      {
        type: 'i',
        value: frame.hands.length,
      },
    ],
  });

  if (frame.hands.length) {
    const newIds = frame.hands.map((hand) => hand.id);

    // check to see if a hand has disappeared
    Object.keys(hands).forEach((oldHandKey) => {
      if (
        !newIds.includes(hands[oldHandKey].id) &&
        hands[oldHandKey].isActive
      ) {
        hands[oldHandKey].deActivate();
      }
    });

    frame.hands.forEach((hand) => {
      // check to see if a new hand has entered
      if (hands[hand.type].id != hand.id) {
        hands[hand.type].activate(hand.id);
      }
      // for each present hand, send hand data
      hands[hand.type].sendData(hand, previousFrame);
    });

    // send distance data if both hands are present
    if (frame.hands.length == 2) {
      socket.emit('OSCmsg', {
        OSCaddress: '/data/distance',
        OSCargs: [
          {
            type: 'f',
            value: distance3d(
              frame.hands[0].palmPosition,
              frame.hands[1].palmPosition
            ),
          },
        ],
      });
    }
  }
  previousFrame = frame;
});

controller.setBackground(config.leapSettings.runInBackground);

const popup = document.querySelector('.popup');

// mode selection buttons
let mode = 'off';
const optionBtns = document.querySelectorAll('.option');
optionBtns.forEach((btn) => {
  btn.addEventListener('click', function (e) {
    let enabled = this.dataset.enabledhands;

    // make all buttons inactive
    optionBtns.forEach((b) => {
      b.classList.remove('active');
    });

    if (mode == this.textContent) {
      // currently active mode was clicked -> turn off
      // ! this should be abstracted into a function/object for more DRY code
      mode = 'off';
      socket.emit('OSCmsg', {
        OSCaddress: '/mode/off',
      });
      ['left', 'right'].forEach((side) => hands[side].disable());
      popup.classList.add('hidden');
    } else {
      // a currently inactive mode button was clicked - switch to that mode
      ['left', 'right'].forEach((side) => hands[side].disable());
      enabled.split(' ').forEach((hand) => {
        hands[hand].enable();
      });
      mode = this.textContent;
      this.classList.add('active');
      popup.textContent = this.dataset.instruction;
      popup.classList.remove('hidden');
      socket.emit('OSCmsg', {
        OSCaddress: '/mode',
        OSCargs: [
          {
            type: 's',
            value: this.dataset.id,
          },
        ],
      });
    }
  });
});

// stop button
document.querySelector('#stop').addEventListener('click', () => {
  ['left', 'right'].forEach((side) => hands[side].disable());
  optionBtns.forEach((btn) => btn.classList.remove('active'));
  mode = 'off';
  socket.emit('OSCmsg', {
    OSCaddress: '/mode/off',
  });
  popup.classList.add('hidden');
});

// reset button
document.querySelector('.reset').addEventListener('click', () => {
  ['left', 'right'].forEach((side) => hands[side].disable());
  optionBtns.forEach((btn) => btn.classList.remove('active'));
  popup.textContent =
    'Resetting synth engine and user interface, please wait...';
  popup.classList.remove('hidden');
  socket.emit('OSCmsg', {
    OSCaddress: '/reset',
  });
  setInterval(() => {
    window.location.reload();
  }, config.resetTime);
});

// check for inactive hands
setInterval(() => {
  if (previousFrame) {
    const ids = previousFrame.hands.map((prevHand) => prevHand.id);
    Object.keys(hands).forEach((oldHandKey) => {
      if (!ids.includes(hands[oldHandKey].id) && hands[oldHandKey].isActive) {
        // hand has disappeared and can be deactivated
        hands[oldHandKey].deActivate();
      }
    });
  }
}, config.leapSettings.handPresenceCheckInterval);
