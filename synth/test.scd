/*
This document is made for development and debugging purposes, providing rudimentary support for simulating incoming leap motion data for testing synthesizer engine response.

This testing interface is unstable.
Use Ctrl/Cmd+. to reset.
*/

~testmode = \e5;
h[~testmode][\start].value;
h[~testmode][\stop].value;

(
~data[\distance] = 500;
~data[\numHands] = 2;

~testdata = Dictionary.newFrom([
	\palmPosX, 100,
	\palmPosY, 200,
	\palmPosZ, 0,
	\translationX, 0,
	\translationY, 5,
	\translationZ, 0,
	\translationLength, 5,
	\pinchStrength, 0,
]);

//h[~testmode][\left][\data].value(~testdata);
h[~testmode][\right][\data].value(~testdata);
)

h[~testmode][\left][\enter].value;
h[~testmode][\left][\exit].value;

h[~testmode][\right][\enter].value;
h[~testmode][\right][\exit].value;
