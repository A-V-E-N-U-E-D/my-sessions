(
s.waitForBoot {
    SynthDef(\highFDrone, { |out=0, amp=0.1, gate=1, freq=698.456|
        var env, sig, beat, pulse;

        beat = 60 / 67;
        env = EnvGen.kr(Env.asr(0.01, 1, 8), gate, doneAction: 2);
		pulse = SinOsc.kr(1 / (beat * 32), -pi/2).range(0, 1).pow(4).range(0.25, 1);

        sig = Mix.fill(6, {
            SinOsc.ar(
                freq * Rand(0.99, 3.5) * LFNoise2.kr(0.05).range(0.995, 1.005),
                Rand(0, 2pi), 0.03
            )
        });

        sig = sig + Blip.ar(freq, 18, 0.025);
        sig = HPF.ar((sig * 4).tanh, 300);
        sig = RLPF.ar(sig, freq * pulse.range(2, 8), 0.15);
        sig = sig * pulse;
        sig = Pan2.ar(sig, SinOsc.kr(1 / (beat * 8)).range(-0.8, 0.8));
        sig = sig + JPverb.ar(sig, t60: 16, damp: 0.1, size: 4) * 0.75;

        Out.ar(out, Limiter.ar(sig, 0.9) * env * amp);
    }).add;

    s.sync;
};
~play = Synth(\highFDrone);
s.record;
)