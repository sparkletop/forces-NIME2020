~newHandler.value(\e1);



h[\e1][\start] = {
	h[\e1][\g] = nil;
	h[\e1][\g].set(\gate, 0);
	h[\e1][\g] = Synth(\cloud,[
		\buf, ~buffers[0],
		\out, ~bus[\reverb],
		\group, ~group[\synth],
		\trigFreq, 150,
		\dur, 0.15,
		\range, 0.005
	]);
};

h[\e1][\stop] = {
	h[\e1][\g].set(\gate, 0);
};

h[\e1][\right][\enter] = {
	h[\e1][\g].set(\pointerFreqScale, 0);
	h[\e1][\g].set(\range, 0.2);
};

h[\e1][\right][\exit] = {
	h[\e1][\g].set(\pointerFreqScale, 1);
	h[\e1][\g].set(\range, 0.01);
};

h[\e1][\left][\data] = {|data|
	var pinch = data[\pinchStrength].linlin(0,1,1,0);
	h[\e1][\g].set(\cutoff, pinch.linexp(0,1,200,10000));
};

h[\e1][\left][\exit] = {
	h[\e1][\g].set(\cutoff, 10000);
};
