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

(
SynthDef("sunsetForest", {
	arg amp = 1;
	var a, out=0;
	a=PinkNoise.ar(1!2);
	50.do{
		a=BBandStop.ar(a,LFNoise1.kr(0.01.rand).range(10,2500),Rand(0.9,1))
	};
	a=LPF.ar(a,1e5);
	a=HPF.ar(a,150);
	Out.ar(out, amp * a/2);
}, [10]).add
)
)

s = Synth("sunsetForest", [\amp, 0]);
s.set(\amp, 1.7);
s.set(\amp, 0);
s.free;

// livecoding
(
// cs
x = Synth("sine", [\freq, 570.609/4, \amp, 0, \parFreq, 1, \pan2Freq, 1, \vibratoDepth, 0.3, \vibratoFreq, 3, \actave, 1, \reverb, 0.6]);
// ef
y = Synth("sine", [\freq, 640.487/4, \amp, 0, \parFreq, 0, \pan2Freq, 1, \vibratoDepth, 0.3, \vibratoFreq, 3, \actave, 1, \reverb, 0.4]);
z = Synth("sine", [\freq, 659.255/8, \amp, 0, \parFreq, 0, \pan2Freq, 1, \vibratoDepth, 0.3, \vibratoFreq, 3, \actave, 1, \reverb, 0.9]);
)
(
x.set(\amp, 0.1);
y.set(\amp, 0.06);
z.set(\amp, 0.08);
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
