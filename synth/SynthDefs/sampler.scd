SynthDef.new(\sampler, {
	arg gate = 1, buf, amp = 0.8, rate = 1, out = 0,
	atk = 1, rel = 2, lpCutoff = 12000, hpCutoff = 20, rq = 1, rand = 0, randScale = 3;
	var sig, env, noise;
	noise = LFNoise0.kr(10).range(1-(rand*randScale), 1+(rand*randScale));
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction: 2);
	sig = PlayBuf.ar(1,	buf, BufRateScale.kr(buf) * rate * noise, loop: 1)!2;
	sig = RLPF.ar(sig, lpCutoff, rq);
	sig = RHPF.ar(sig, hpCutoff, rq);
	Out.ar(out, sig * env * amp);
}, (0!2)++(2!10)).add;