import distance3d from './distance3d';

const PARAMETERS = ['id', 'grabStrength', 'pinchStrength', 'confidence'];

const Hand = function (type, socket) {
  this.type = type;
  this.svg = document.getElementById(type);
  this.id = null;
  this.isActive = false;
  this.isDisabled = true;

  this.disable = () => {
    this.isDisabled = true;
    this.svg.classList.add('disabled');
  };

  this.enable = () => {
    this.isDisabled = false;
    this.svg.classList.remove('disabled');
  };

  this.sendStatus = (status) => {
    socket.emit('OSCmsg', {
      OSCaddress: '/' + this.type + '/' + status,
      OSCargs: [
        {
          type: 's',
          value: 'hand' + this.id,
        },
      ],
    });
  };

  this.deActivate = () => {
    if (this.isDisabled) return;
    this.isActive = false;
    this.svg.classList.remove('active');
    this.sendStatus('exit');
  };

  this.activate = (id) => {
    if (this.isDisabled) return;
    this.id = id;
    this.isActive = true;
    this.svg.classList.add('active');
    this.sendStatus('enter');
  };

  this.sendData = (handData, previousFrame) => {
    if (this.isDisabled) return;

    const msg = {};
    msg.OSCaddress = '/' + handData.type + '/data';
    msg.OSCargs = [];
    PARAMETERS.forEach((parameter) => {
      msg.OSCargs.push({
        type: 's',
        value: parameter,
      });
      const type = parameter == 'id' ? 'i' : 'f';
      msg.OSCargs.push({
        type: type,
        value: handData[parameter],
      });
    });

    let translation;

    if (previousFrame && previousFrame.valid) {
      translation = handData.translation(previousFrame);
      msg.OSCargs.push({
        type: 's',
        value: 'translationLength',
      });
      msg.OSCargs.push({
        type: 'f',
        value: distance3d(translation, [0, 0, 0]),
      });
    }

    ['X', 'Y', 'Z'].forEach((coord, i) => {
      msg.OSCargs.push({
        type: 's',
        value: 'palmPos' + coord,
      });
      msg.OSCargs.push({
        type: 'f',
        value: handData.palmPosition[i],
      });
      if (previousFrame && previousFrame.valid) {
        msg.OSCargs.push({
          type: 's',
          value: 'translation' + coord,
        });
        msg.OSCargs.push({
          type: 'f',
          value: translation[i],
        });
      }
    });

    socket.emit('OSCmsg', msg);
  };
};

export default Hand;
