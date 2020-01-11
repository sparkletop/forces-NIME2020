SynthDef.new(\reverb, {
	arg out = 0, in, reverb = 0.2,
	roomSize = 0.7, damp = 0.5;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb2.ar(sig[0], sig[1], reverb, roomSize, damp);
	Out.ar(out, sig);
}, 0.1!5).add;

SynthDef.new(\master, {
	arg amp = 1, out = 0, in;
	var sig;
	sig = In.ar(in, 2) * amp;
	sig = Limiter.ar(sig);
	Out.ar(out, sig);
}, [0.1]).add;
