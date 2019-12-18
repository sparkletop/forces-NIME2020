SynthDef.new(\sampler, {
	arg gate = 1, buf, amp = 0.8, rate = 1, out = 0,
	atk = 1, rel = 2, lpCutoff = 10000, hpCutoff = 20, rq = 1;
	var sig, env;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate);
	sig = PlayBuf.ar(1,	buf, BufRateScale.kr(buf) * rate, loop: 1)!2;
	sig = RLPF.ar(sig, lpCutoff.clip(20, 20000), rq);
	sig = RHPF.ar(sig, hpCutoff.clip(20, 20000), rq);
	Out.ar(out, sig * env * amp);
}, (0!2)++(5!8)).add;