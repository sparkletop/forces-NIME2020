k = \example2;
~newHandler.value(k);

h[k][\left][\exit] = h[k][\right][\exit] = {
	(~data[\numHands] < 2).if({
		h[k][\reset].value;
	});
};

h[k][\stop] = {
	Pbindef(k).stop;
	h[k][\reset].value;
};

h[k][\start] = {
	Pbindef(k).play(quant: 0)
};

h[k][\reset] = {
	~data[\distance] = 500;
	h[k][\left][\data].value(true);
};

h[k][\left][\data] = { |force = false|
	((~data[\numHands] == 2) || force).if({
		var distance = ~data[\distance].linlin(140, 500, 0, 1);
		var steps = (distance * 5).round(1);
		\resetting.postln;
		Pbindef(k,
			\pan, Pbrown(distance.neg, distance, 0.3),
			\legato, distance.lincurve(0,1,1, 10, 4),
			\cutoff, Pexprand(600, 10000),
			\mtranspose, steps.round(1),
			\rq, Pexprand(
				distance.linlin(0,1,0.3,0.7),
				distance.linlin(0,1,0.5,1)),
			\cutoff, Pexprand(
				distance.linlin(0,1,600,2000),
				distance.linlin(0,1,1000,10000)
			)
		);
		Pdefn(\degrees,Pxrand((steps.neg..steps*2+2), inf));
		Pdefn(\durWeights, [
			distance.lincurve(0, 1,   1, 0, 2),
			distance.linlin(0, 1,   0.2, 1),
			distance.lincurve(0, 1,   0, 1.5, 2)
		].normalizeSum);
		TempoClock.default.tempo_(distance.lincurve(0, 1, 150/60, 90/60, -1));
		~fx[\reverb].set(
			\roomSize, distance.linlin(0,1,0.2,0.8),
			\reverb, distance.linlin(0,1,0.2,0.5)
		);
	});
};

Pbindef(k,
	\instrument, \tri,
	\root, 0,
	\scale, Scale.minorPentatonic,
	\octave, 4,
	\degree, Pclump(
			Pwrand(
				[1,  2,  3],
				[80, 30, 10].normalizeSum,
				inf),
			Pdefn(\degrees,Pxrand((0..7), inf))
		).stutter(Plprand(1, 3)),
	\dur, Pwrand(
		[1/16, 1/8, Rest(1/16)],
		Pdefn(\durWeights, [0, 1, 1.5].normalizeSum),
		inf) * 4,
	\db, Pgauss(-25, 3),
	\out, ~bus[\reverb]
);

h[k][\reset].value;
