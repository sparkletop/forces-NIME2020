~newHandler.value(\e3);

h[\e3][\thresholdX] = 70;
h[\e3][\thresholdYlow] = 180;
h[\e3][\thresholdYhigh] = 300;

h[\e3][\start] = {
	h[\e3][\s] = Synth(\sampler, [
		\out, ~bus[\reverb],
		\buf, ~buffers[4],
		\randScale, 5
	], ~group[\synth])
};

h[\e3][\stop] = {
	h[\e3][\s].set(\gate, 0);
};

h[\e3][\right][\exit] = {
	h[\e3][\s].set(\rate, 1);
	h[\e3][\s].set(\rand, 0);
	h[\e3][\s].set(\rq, 1);
	h[\e3][\s].set(\lpCutoff, 12000);
	h[\e3][\s].set(\hpCutoff, 20);
};

h[\e3][\right][\data] = { |data|
	var px = data[\palmPosX], py = data[\palmPosY];

	// x-coordinate: playback rate
	if (px < h[\e3][\thresholdX].neg,
		{
			h[\e3][\s].set(
				\rate, px.linlin(-250, h[\e3][\thresholdX].neg, 0.5, 1),
				\rand, px.lincurve(-250, h[\e3][\thresholdX].neg, 1, 0, -6.5),
			);
		}, {
			if (px > h[\e3][\thresholdX],
				{
					h[\e3][\s].set(
						\rate, px.linlin(h[\e3][\thresholdX], 250, 1, 2),
						\rand, px.lincurve(h[\e3][\thresholdX], 250, 0, 1, 6.5),
					);
				},
				{
					h[\e3][\s].set(
						\rate, 1,
						\rand, 0
					);
			});
		}
	);

	// y-coordinate: filter cutoff frequencies and reciprocal quality
	if (py < h[\e3][\thresholdYlow], {
		h[\e3][\s].set(\lpCutoff, py.linexp(80, h[\e3][\thresholdYlow], 200, 12000));
		h[\e3][\s].set(\rq, py.lincurve(80, h[\e3][\thresholdYlow], 1, 0.1, -4));
	}, {
		if (py > h[\e3][\thresholdYhigh], {
			h[\e3][\s].set(\hpCutoff, py.linlin(h[\e3][\thresholdYhigh],400,20,3000));
			h[\e3][\s].set(\rq, py.lincurve(h[\e3][\thresholdYhigh],400, 1, 0.1, -2));
		}, {
			h[\e3][\s].set(\rq, 1);
			h[\e3][\s].set(\lpCutoff, 12000);
			h[\e3][\s].set(\hpCutoff, 20);
		}
		)
	});
};
