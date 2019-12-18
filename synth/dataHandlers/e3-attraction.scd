~newHandler.value(\e3);

h[\e3][\loFreq] = 55;
h[\e3][\hiFreq] = 1760;

[\left, \right].do{ |side|
	h[\e3][side][\enter] = {
		h[\e3][side][\s] = Synth(\laggy, [
			\out, ~bus[\reverb],
			\freq, h[\e3][\loFreq]
		], ~group[\synth]);
	};
	h[\e3][side][\exit] = {
		h[\e3][side][\s].set(
			\gate, 0,
			\freq, h[\e3][\loFreq] / 4
		);
	};

	h[\e3][side][\data] = { |data|
		h[\e3][side][\s].set(
			\freq, data[\palmPosY].linexp(100,500,h[\e3][\loFreq],h[\e3][\hiFreq]),
			\pan, data[\palmPosX].linlin(-200, 200, -1, 1)
		);
	};
};

h[\e3][\stop] = {
	~group[\synth].set(\gate, 0)
};

SynthDef(\laggy, {
	arg gate = 1, freq = 440, amp = 0.7, pan = 0, lag = 10, out = 0;
	var sig, env;
	env = EnvGen.ar(Env.asr(lag, 1, lag), gate, doneAction: 2);
	sig = SinOsc.ar(freq) * env;
	sig = Pan2.ar(sig, pan.clip(-1,1), amp);
	Out.ar(out, sig);
}, [0] ++ (10!6)).add;
