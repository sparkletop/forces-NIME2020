SynthDef.new(\cloud,{
	arg buf, trigFreq = 50, dur = 0.2, rate = 1,
	spread = 0, range = 0, pointerFreqScale = 1,
	atk = 0.2, rel = 1, gate = 1, amp = 0.8,
	rq = 1, cutoff = 10000, out = 0;
	var env, sig, trig, pos, pan, vol, pointerFreq;
	trig = Dust.ar(trigFreq);
	pointerFreq = BufDur.kr(buf).reciprocal * pointerFreqScale;
	pos = LFSaw.kr(pointerFreq, 1).range(0, 1);
	pos = Wrap.kr(pos + LFNoise0.kr(trigFreq, range));
	pan = LFNoise0.kr(trigFreq).range(spread.neg, spread);
	vol = LinLin.kr(dur * trigFreq * 0.1, 0, 1, 1, 1.35).reciprocal;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction: 2);
	sig = GrainBuf.ar(2, trig, dur, buf, rate, pos, pan: pan);
	sig = RLPF.ar(sig, cutoff.lag2(1), rq);
	sig = Limiter.ar(sig * env) * amp;
	Out.ar(out, sig);
}).add;