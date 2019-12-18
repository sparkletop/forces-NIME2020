~newHandler.value(\e2);

h[\e2][\left][\exit] = h[\e2][\right][\exit] = {
	(~data[\numHands] < 2).if({
		h[\e2][\left][\data].value;
	});
};

h[\e2][\stop] = {
	Pbindef(\e2).stop;
	~fx[\reverb].set(\roomSize, 0.5);
};

h[\e2][\start] = {
	h[\e2][\left][\data].value;
	Pbindef(\e2).play(quant: 0)
};

h[\e2][\left][\data] = {
	var distance, steps;
	(~data[\numHands] != 2).if({~data[\distance] = 450;});
	distance = ~data[\distance].linlin(140, 450, 0, 1);
	steps = (distance * 5).round(1);

	Pbindef(\e2,
		\pan, Pwhite(distance.neg, distance),
		\legato, distance.lincurve(0,1,1, 2, 4),
		\cutoff, Pexprand(600, 10000),
		\mtranspose, steps.round(1),
		\rq, Pexprand(
			distance.linlin(0,1,0.3,0.7),
			distance.linlin(0,1,0.5,1)),
		\cutoff, Pexprand(
			distance.linlin(0,1,600,2000),
			distance.linlin(0,1,1000,10000)
		),
		\atk, distance.linexp(0,1,0.01,0.1),
		\degree, Pxrand((steps.neg..steps*2+5), inf),
		\scale, Pwrand(
			[Scale.minorPentatonic, Scale.phrygian],
			[distance, distance.linlin(0,0.25,1,0)].normalizeSum,
			inf
		)
	);
	Pdefn(\durWeights, [
		distance.lincurve(0, 1,   1,   0, 2),
		distance.linlin(  0, 1,   0.5, 1),
		distance.lincurve(0, 1,   0,  0.5, 2),
		distance.lincurve(0, 1,   0,   1.5, 2)
	].normalizeSum);
	TempoClock.default.tempo_(distance.lincurve(0, 1, 200/60, 100/60, -5));
	~fx[\reverb].set(
		\roomSize, distance.linlin(0,1,0.2,0.5)
	);
};

Pbindef(\e2,
	\instrument, \tri,
	\root, 0,
	\scale, Scale.minorPentatonic,
	\octave, 4,
	\dur, Pwrand(
		[1/16, 1/8, Rest(1/16), Rest(1/8)],
		Pdefn(\durWeights, [0, 1, 1, 3].normalizeSum),
		inf) * 4,
	\db, Pgauss(-15, 2),
	\out, ~bus[\reverb],
	\group, ~group[\synth]
);
