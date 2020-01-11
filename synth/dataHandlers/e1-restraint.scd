~newHandler.value(\e1);

h[\e1][\pos] = 0;
h[\e1][\advancing] = true;
h[\e1][\dur] = 0.3; // 0.3
h[\e1][\pan] = Pgauss(0.0,0.08).asStream;
h[\e1][\step] = 0.04; // 0.04


h[\e1][\start] = {
	TempoClock.default.tempo_(1);
	r = Routine.new({
		loop {
			if (h[\e1][\advancing], {
				h[\e1][\pos] = (h[\e1][\pos] + (h[\e1][\dur] * h[\e1][\step])).wrap(0,1);
			});
			Synth(\grain,[
				\buf, ~buffers[0],
				\pos, h[\e1][\pos],
				\dur, h[\e1][\dur],
				\legato, 3,
				\pan, h[\e1][\pan].next,
				\out, ~bus[\reverb]
			], ~group[\synth]);
			h[\e1][\dur].wait;
		}
	}).play;
};

h[\e1][\stop] = {
	r.stop;
	h[\e1][\pos] = 0;
};

h[\e1][\right][\enter] = {
	h[\e1][\pos] = h[\e1][\pos] - (h[\e1][\dur] * h[\e1][\step]);
	h[\e1][\advancing] = false;
	h[\e1][\pan] = Pgauss(0.0,0.3).asStream;
};

h[\e1][\right][\exit] = {
	h[\e1][\advancing] = true;
	h[\e1][\pan] = Pgauss(0.0,0.15).asStream;
};

h[\e1][\right][\data] = { |data|
	var sign = data[\palmPosX].sign;
	h[\e1][\pan] = Pgauss(
		data[\palmPosX].abs.linlin(50,200,0,0.3) * sign,
		0.3
	).asStream;
	//h[\e1][\pos] = data[\palmPosX].linlin(-250,250,0,1);
};
