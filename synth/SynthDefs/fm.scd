SynthDef(\fm,{
	arg freq=500, mRatio=1, cRatio=1, index=1, freqRand=1.001, freqCRate=10,
	atk=2, rel=2, pan=0, out=0, amp=0.2, gate=1, modVib=1.1, modVibFreq=2;
	var car, mod, env, modLfo;
	freq = LFNoise0.kr(freqCRate).range(freq/freqRand,freq*freqRand);
	env = Env.asr(atk, 1, rel, 0).kr(2, gate);
	modLfo = LFTri.ar(modVibFreq).range(modVib.reciprocal,modVib);
	mod = SinOsc.ar(freq * mRatio, mul: freq * mRatio * index * modLfo);
	car = SinOsc.ar(freq * cRatio + mod) * env;
	Out.ar(out, Pan2.ar(car, pan, amp));
}, [0.2] ++ (0.1!16)).add;
