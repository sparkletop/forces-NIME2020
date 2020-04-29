import config from '../config.json';

export default config.modes.reduce((acc, mode) => {
  return (
    acc +
    `
    <div
        class="option btn"
        data-id="${mode.id}"
        data-enabledhands="${mode.hands}"
        data-instruction="${mode.instruction}"
    >${mode.label}</div>
    `
  );
}, ``) +
  `
<div class="btn" id="stop">Stop</div>
`;
