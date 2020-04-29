// --- Main init script for forces synthesizer --- //
(
// --- 1. server config
s.options.numOutputBusChannels_(2);
s.options.memSize_(2.pow(20));
s.options.sampleRate_(44100);
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// --- 2. global variables
~out = 0;
~confidence = 0.3;

// ~data holds the most recent global data from the leap controller
~data = IdentityDictionary.newFrom([
	\mode, \off,
	\distance, 100,
	\numHands, 0,
	\translationLength, 0
]);

// h stores rerences to different handlers for incoming controller data
h = IdentityDictionary.new;


// --- 3. function definitions
"utils.scd".loadRelative; // a few utility functions

~makeBusses = {
	~bus = IdentityDictionary.newFrom([
		\distortion, Bus.audio(s, 2),
		\reverb, Bus.audio(s, 2),
		\master, Bus.audio(s, 2)
	]);
};

~makeNodes = {
	s.bind({
		// Groups
		~group = IdentityDictionary.new;
		~group[\synth] = Group.new(s);

		~group[\fx] = Group.new(~group[\synth], \addAfter);

		// FX
		~fx = IdentityDictionary.new;
		~fx[\reverb] = Synth(\reverb, [
			\in, ~bus[\reverb],
			\out, ~bus[\master],
			\reverb, 0.2,
			\roomSize, 0.5
		], ~group[\fx]);
		~master = Synth(\master, [
			\in, ~bus[\master],
			\out, ~out
		], ~group[\fx], \addToTail);
	});
};

~newHandler = { |name|
	h[name] = IdentityDictionary.new;
	h[name][\left] = IdentityDictionary.new;
	h[name][\right] = IdentityDictionary.new;
	h[name][\info] = IdentityDictionary.new;
	h[name][\left][\enter]  = {nil;};
	h[name][\left][\exit]   = {nil;};
	h[name][\right][\enter] = {nil;};
	h[name][\right][\exit]  = {nil;};
	h[name][\left][\data]   = {nil;};
	h[name][\right][\data]  = {nil;};
	h[name][\start]         = {nil;};
	h[name][\stop]          = {nil;};
};

~makeHandlers = Task({
	OSCdef.freeAll;
	1.wait;

	// register wrappers for data handlers
	[\left, \right].do{|side|
		OSCdef(side++\Enter, { |msg|
			var mode = ~data[\mode];
			h[mode][side][\enter].value(msg[1]);
		}, '/'++side++'/enter');
		OSCdef(side++\Exit, { |msg|
			var mode = ~data[\mode];
			h[mode][side][\exit].value(msg[1]);
		}, '/'++side++'/exit');

		OSCdef(side++\Data, {
			arg msg; var data, mode;
			data = msg[1..].asDict;
			~data[side] = msg[1..].asDict;
			mode = ~data[\mode];
			(data[\confidence] > ~confidence).if({
				h[mode][side][\data].value(data);
			});
		}, '/'++side++'/data');
	};

	// register handlers for global data
	OSCdef(\distance, {|msg|
		~data[\distance] = msg[1];
	}, '/data/distance');
	OSCdef(\numHands, {|msg|
		~data[\numHands] = msg[1];
	}, '/data/numHands');
	OSCdef(\mode, { |msg|
		h[~data[\mode]][\stop].value;
		~group[\synth].set(\gate, 0);
		~data[\mode] = msg[1].asSymbol;
		h[msg[1].asSymbol][\start].value;
		"Mode change: ".post; msg[1].postln;
	}, '/mode');

	OSCdef(\off, {
		h[~data[\mode]][\stop].value;
		~data[\mode] = \off;
		~group[\synth].set(\gate, 0);
	}, '/mode/off');

	OSCdef(\reset, {
		Task.new({
			~master.set(\amp, 0);
			0.15.wait;
			s.freeAll;
		}).play;
	}, '/reset');

	~newHandler.value(\off);

	~loadSubDir.value("dataHandlers");

	"Load complete.".postln;
});

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
	OSCdef.freeAll;
	Buffer.freeAll;
	Pdef.removeAll;
	Pbindef.removeAll;
	TempoClock.default.tempo_(1);
};

// --- 4. register functions with ServerBoot/Quit
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

// --- 5. boot server
s.waitForBoot({
	s.bind({
		~loadSubDir.value("SynthDefs");
		s.sync;
		~buffers = ~loadBufDir.value("samples");
		ServerTree.add(~makeNodes);
		ServerTree.add({~makeHandlers.start});
	});
	s.freeAll;
});
)