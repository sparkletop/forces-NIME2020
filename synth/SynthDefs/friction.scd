SynthDef(\rez, {
	arg endGate = 1, gate = 0,
	atk = 0.5, rel = 0.5,
	amp = 0.5, pan = 0, out = 0,
	freqs (#[209, 215, 242, 332, 741, 742, 809, 854, 891, 935, 940, 1365, 1400, 1544, 1669, 1695]),
	amps (#[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]),
	rings (#[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
),
	cutoff = 2000;
	var env, sig, source;
	Env.asr(atk, releaseTime: rel + 10).kr(2, endGate);
	env = Env.asr(atk, 1, rel, [-4,\sin]).kr(0, gate);
	source = PinkNoise.ar * LFNoise0.kr(10) * 0.01 * env;
	source = LPF.ar(source, cutoff);
	sig = DynKlank.ar(`[freqs, amps, rings], source);
	sig = Pan2.ar(sig, pan, amp);
	sig = Limiter.ar(sig);
	Out.ar(out, sig);
}, [0,0]++(0.2!9)).add;
