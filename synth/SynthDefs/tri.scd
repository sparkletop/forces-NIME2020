SynthDef.new(\tri,{
	arg freq = 220, sustain = 1, atk = 0.01, rel = 1,
	cutoff = 5000, rq = 1, amp = 0.5, out = 0, pan = 0;
	var env, sig;
	env = Env.perc(atk, rel).kr(timeScale: sustain, doneAction: 2);
	sig = RLPF.ar(
		LFTri.ar(freq),
		cutoff.clip(20, 20000),
		rq.clip(0.0, 1.0)
	);
	Out.ar(out, Pan2.ar(sig, pan, env * amp));
}).add;