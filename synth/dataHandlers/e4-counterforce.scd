~newHandler.value(\e4);

h[\e4][\thresholdX] = 80;
h[\e4][\thresholdYlow] = 180;
h[\e4][\thresholdYhigh] = 300;

h[\e4][\start] = {
	h[\e4][\s] = Synth(\sampler, [
		\out, ~bus[\reverb],
		\buf, ~buffers[0]
	], ~group[\synth])
};

h[\e4][\stop] = {
	h[\e4][\s].set(\gate, 0);
};

h[\e4][\right][\exit] = {
	h[\e4][\s].set(\rate, 1);
	h[\e4][\s].set(\rq, 1);
	h[\e4][\s].set(\lpCutoff, 10000);
	h[\e4][\s].set(\hpCutoff, 20);
};

h[\e4][\right][\data] = { |data|
	var px = data[\palmPosX], py = data[\palmPosY];
	h[\e4][\s].set(
		\filterQ, data[\pinchStrength].linexp(0, 1, 1, 0.3)
	);
	// x-coordinate: playback rate
	if (px < h[\e4][\thresholdX].neg,
		{
			h[\e4][\s].set(
				\rate, px.linlin(-250, h[\e4][\thresholdX].neg, 0.5, 1)
			);
		}, {
			if (px > h[\e4][\thresholdX],
				{
					h[\e4][\s].set(\rate, px.linlin(h[\e4][\thresholdX], 250, 1, 2));
				},
				{
					h[\e4][\s].set(\rate, 1);
			});
		}
	);
	py.postln;
	// y-coordinate: low pass filter cutoff frequency
	if (py < h[\e4][\thresholdYlow], {
		h[\e4][\s].set(\lpCutoff, py.linexp(80, h[\e4][\thresholdYlow], 200, 10000));
		h[\e4][\s].set(\rq, py.lincurve(80, h[\e4][\thresholdYlow], 1, 0.1, -4));
	}, {
		if (py > h[\e4][\thresholdYhigh], {
			h[\e4][\s].set(\hpCutoff, py.linlin(h[\e4][\thresholdYhigh],400,20,2000));
			h[\e4][\s].set(\rq, py.lincurve(h[\e4][\thresholdYhigh],400, 1, 0.1, -2));
		}, {
			h[\e4][\s].set(\rq, 1);
			h[\e4][\s].set(\lpCutoff, 10000);
			h[\e4][\s].set(\hpCutoff, 20);
		}
		)
	});
};