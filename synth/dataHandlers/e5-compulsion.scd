~newHandler.value(\e5);

[\left, \right].do{ |side|
	h[\e5][side][\data] = { |data|
		if (data[\translationLength] > 4, {
			Synth.new(\tri, [
				\rel, 1,
				\atk, 2,
				\freq, data[\palmPosY].linexp(100,400,100,10000).round(100),
				\pan, data[\palmPosX].linlin(-150,150,-1,1),
				\amp, data[\translationLength].linexp(3,15, 0.001, 0.1)
				// volume and lp-filter on Z-axis?
			]);
		});
	};
};
