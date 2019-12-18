~newHandler.value(\example1);

h[\example1][\g] = nil;

h[\example1][\start] = {
	h[\example1][\g].set(\gate, 0);
	h[\example1][\g] = Synth(\cloud,[
		\buf, ~buffers[0],
		\out, ~group[\fx],
		\group, ~group[\synth],
		\trigFreq, 150,
		\dur, 0.15,
		\range, 0.0005
	]);
};

h[\example1][\stop] = {
	h[\example1][\g].set(\gate, 0);
};

h[\example1][\right][\enter] = {
	h[\example1][\g].set(\pointerFreqScale, 0);
};

h[\example1][\right][\exit] = {
	h[\example1][\g].set(\pointerFreqScale, 1);
};

h[\example1][\left][\data] = {|data|
	var pinch = data[\pinchStrength].linlin(0,1,1,0);
	h[\example1][\g].set(\cutoff, pinch.linexp(0,1,200,10000));
};

h[\example1][\left][\exit] = {
	h[\example1][\g].set(\cutoff, 10000);
};
