(
SynthDef("sine", {
	arg freq = 440, amp = 0.2, parFreq=0, pan2Freq=0,
	vibratoFreq=3, vibratoDepth=0, actave=1, reverb=0, ice=0;
	var sig, out=0, chain, in, z, y, oct;
	sig = SinOsc.ar(actave*freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50))), 0, amp);
	// tremoro
	sig = if(
		parFreq>0.1,
		sig*LFPar.ar(parFreq),
		if(
			LFPar.ar(parFreq)>0,
			sig*(LFPar.ar(parFreq) + (1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
			sig*(LFPar.ar(parFreq) + (-1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
		)
	);
	// panning
	sig = if(
		pan2Freq>0.1,
		Pan2.ar(sig, LFPar.ar(pan2Freq)),
		Pan2.ar(sig, LFPar.ar(pan2Freq)*pan2Freq*10)
	);
	// reverb
	z = DelayN.ar(sig, 0.048);
	y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, 1, 15) }));
	32.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
	oct = 1.0 * LeakDC.ar( abs(y) );
	y = SelectX.ar(ice, [y, ice * oct, DC.ar(0)]);
	sig = sig + (0.2*y*reverb);
    Out.ar(out, sig);
}, [0.3, 2, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 1]).add;
)

// livecoding
(
// cs
x = Synth("sine", [\freq, 570.609/4, \amp, 0, \parFreq, 1, \pan2Freq, 1, \vibratoDepth, 0.3, \vibratoFreq, 3, \actave, 1, \reverb, 0.6]);
// ef
y = Synth("sine", [\freq, 640.487/4, \amp, 0, \parFreq, 0, \pan2Freq, 1, \vibratoDepth, 0.3, \vibratoFreq, 3, \actave, 1, \reverb, 0.4]);
z = Synth("sine", [\freq, 659.255/8, \amp, 0, \parFreq, 0, \pan2Freq, 1, \vibratoDepth, 0.3, \vibratoFreq, 3, \actave, 1, \reverb, 0.9]);
)
(
x.set(\amp, 0.12);
y.set(\amp, 0.08);
z.set(\amp, 0.1);
)
(
x.set(\amp, 0);
y.set(\amp, 0);
z.set(\amp, 0);
)
(
x.free;
y.free;
z.free;
)
x.set(\reverb, 0.9);
x.set(\ice, 0.1);
(
x.set(\parFreq, 100);
x.set(\pan2Freq, 100);
)
x.set(\pan2Freq, 164.814/8);
x.set(\freq, 570.609);
x.set(\vibratoDepth, 0.4);
x.set(\vibratoFreq, 1);

y.set(\pan2Freq, 7);
y.set(\pan2Freq, 640.487/16);

z.set(\reverb, 0.9);
z.set(\ice, 0.7);
z.set(\vibratoDepth, 0.9);
z.set(\vibratoFreq, 3);
z.set(\pan2Freq, 164.814);
(
z.set(\parFreq, 50);
z.set(\pan2Freq, 50);
)

z.set(\pan2Freq, 164.814/16);
z.set(\freq, 570.609); // CS
z.set(\freq, 659.255/2); // E4
z.set(\freq, 659.255); // E5
z.set(\freq, 493.883); // B4
z.set(\freq, 493.883*2); // B5
z.set(\freq, 830.609/2); // G#4
z.set(\freq, 830.609); // G#5
z.set(\freq, 220); // A3
z.set(\freq, 440); // A4
z.set(\freq, 880); // A5
z.set(\freq, 987.767); // B5
z.set(\freq, 1318.510); // E6


