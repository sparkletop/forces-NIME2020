~newHandler.value(\e4);

h[\e4][\loFreq] = 55;
h[\e4][\hiFreq] = 1760;

[\left, \right].do{ |side|
	h[\e4][side][\enter] = {
		h[\e4][side][\s] = Synth(\laggy, [
			\out, ~bus[\reverb],
			\freq, h[\e4][\loFreq]
		], ~group[\synth]);
	};
	h[\e4][side][\exit] = {
		h[\e4][side][\s].set(
			\gate, 0,
			\freq, h[\e4][\loFreq] / 2
		);
	};

	h[\e4][side][\data] = { |data|
		h[\e4][side][\s].set(
			\freq, data[\palmPosY].linexp(100,500,h[\e4][\loFreq],h[\e4][\hiFreq]),
			\pan, data[\palmPosX].linlin(-150, 150, -1, 1)
		);
	};
};

h[\e4][\stop] = {
	~group[\synth].set(
		\gate, 0,
		\freq, h[\e4][\loFreq] / 2
	);
	h[\e4][\t].stop;
};

h[\e4][\start] = {
	h[\e4][\t] = Task({
		{
			if (~data[\numHands] == 0,{
				~group[\synth].set(
					\gate, 0,
					\freq, h[\e4][\loFreq] / 2
				);
			});
			0.5.wait;
		}.loop
	});
	h[\e4][\t].start;
};
