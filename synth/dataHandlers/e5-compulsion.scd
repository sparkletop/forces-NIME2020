~newHandler.value(\e5);

// minimum hand movement vector length to trigger sound
h[\e5][\threshold] = 5;

// time to hold max amplitude after hand movement goes below threshold
h[\e5][\hold] = 1;

h[\e5][\start] = {
	h[\e5][\right][\s] = Synth(\rez, [
		\amp, 0.1,
		\gate, 0,
		\out, ~bus[\reverb]
	], ~group[\synth]);
};

h[\e5][\right][\exit] = {
	h[\e5][\right][\s].set(\gate, 0);
};

h[\e5][\stop] = {
	~group[\synth].set(\endGate, 0);
};


// preconfigured arrays to control amplitudes of resonators at different hand positions
h[\e5][\ampMap] = Array.series(16, 0, 1/15).collect({ |i|
	Array.series(16, 0, 1/15).collect({ |x|
		(1-(i-x).abs).clip(0,1);
	});
});

// task to reset amplitude and hold flag
h[\e5][\right][\t] = Task.new({{
	h[\e5][\right][\maxed] = false;
	h[\e5][\amp] = 0.2;
	h[\e5][\hold].wait;
}.loop});

h[\e5][\right][\data] = { |data|
	if (data[\translationLength] > h[\e5][\threshold],
		{
			var amp, calcAmp;
			calcAmp = data[\translationLength].linexp(h[\e5][\threshold], 15, 0.2,1);
			if (calcAmp > h[\e5][\right][\amp] || h[\e5][\right][\maxed].not, {
				/* a longer translation vector has
				been detected in current gesture */
				amp = calcAmp;
				h[\e5][\right][\amp] = calcAmp;
				h[\e5][\right][\maxed] = true;
				h[\e5][\right][\t].stop;
				h[\e5][\right][\t].start;
			}, {
				/* hand is still moving above threshold
				   but not faster than before*/
				amp = h[\e5][\right][\amp]; // we use previous value
			});

			h[\e5][\right][\s].set(
				\gate, 1,
				\rel, 1,
				\pan, data[\palmPosX]
				.linlin(-150,150,-1,1),
			);
			h[\e5][\right][\s].setn(\amps, h[\e5][\ampMap][
				data[\palmPosY]
				.linlin(100,400,0,15)
				.round(1)
				.asInteger
			] * amp
			);
		}, {
			// hand is present, but not moving fast enough
			h[\e5][\right][\s].set(
				\gate, 0
			);
			h[\e5][\right][\amp] = 0.2;
	});
};
