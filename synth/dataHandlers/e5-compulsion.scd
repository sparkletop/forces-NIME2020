~newHandler.value(\e5);

h[\e5][\start] = {
	h[\e5][\right][\data].value(Dictionary.newFrom([
		\translationLength, 0,
		\palmPosY, 100,
		\palmPosX, 0,
	]))
};

h[\e5][\stop] = {
	Pdef(\e5).stop;
};

h[\e5][\distribution] = Env.new([
	[1,0,0],
	[0,1,0],
	[0,0,1]
], 0.5!2);

h[\e5][\right][\exit] = {
	var data = ~data[\right].copy;
	data[\translationLength] = 0;
	Task.new({
		0.1.wait;
		h[\e5][\right][\data].value(data);
	}).play;
};

h[\e5][\right][\data] = { |data|
	var translationDist = h[\e5][\distribution].at(data[\translationLength].linlin(5,15,0,1)).normalizeSum;
	Pdef(\e5,
		Pbind(
			\instrument, \fm,
			\db, -20,
			\dur, 0.1,
			\scale, Scale.minorPentatonic,
			\degree, Pwrand([
				0,
				Pxrand([0,3,5]),
				Pxrand([0,1,3,5,9]),
			], translationDist,	inf).clump(2),
			\modVib, Pwrand([1.1,1.4,1.8], translationDist, inf),
			\freqRand, Pwrand([1.001,1.01,1.08], translationDist, inf),
			\octave, Pwrand(
				[2,3,4],
				h[\e5][\distribution].at(data[\palmPosY].linlin(100,400,0,1)).normalizeSum,
				inf
			),
			\index, data[\palmPosX].lincurve(-250,-25,50,3,-2),
			\cRatio, data[\palmPosY].abs.lincurve(100,400,2,20,3).round(1),
			\mRatio, Pkey(\cRatio) * data[\palmPosX].lincurve(25,250,2,10,3).round(0.5),
			\out, ~bus[\reverb],
			\group, ~group[\synth]
		)
	).play.quant_(0);
};

