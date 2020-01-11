SynthDef.new(\grain,{
	arg buf, out=0, dur=0.1, amp=0.5, rate=1, pan=0, pos=0, legato=1;
	var env, sig, phase;
	env = Env.sine(dur).kr(2, timeScale: legato);
	phase = Phasor.ar(0,
		BufRateScale.kr(buf) * rate,
		pos * BufFrames.ir(buf),
		BufFrames.ir(buf)
	);
	sig = BufRd.ar(2, buf, phase) * env;
	Out.ar(out, Balance2.ar(sig[0], sig[1], pan, amp));
}).add;
