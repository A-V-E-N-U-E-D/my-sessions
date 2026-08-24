(
s.waitForBoot {

    ~bpm = 135;
    ~beat = 60 / ~bpm;
    ~bar = ~beat * 3;

    ~root = 45; // A2
	~scale = [0, 2, 3, 5, 7, 9, 10]; // A Dorian

    SynthDef(\spaceyDrone, {
        |out=0, amp=0.3, gate=1|

        var env, deep, haze, stars, air, shine;
        var ion, orbit, tx;
        var sig, breath;

        env = EnvGen.kr(
            Env.asr(10, 1, 20),
            gate,
            doneAction: 2
        );

        breath = SinOsc.kr(
            1 / (~bar * 8),
            Rand(0, 2pi)
        ).range(0.7, 1);

        deep = Mix.fill(8, { |i|
            var deg, freq, drift;

			// A2, E3, A3, D4, E4, A4, E5, A5
			deg = [0, 7, 12, 17, 19, 24, 31, 36][i];
            freq = (~root + deg).midicps;

            drift = LFNoise2.kr(
                Rand(0.006, 0.025)
            ).range(0.997, 1.003);

            SinOsc.ar(
                freq * drift,
                Rand(0, 2pi),
                LFNoise2.kr(
                    Rand(0.01, 0.04)
                ).range(0.01, 0.06)
            );
        });

        deep = LPF.ar(
            deep,
            LFNoise2.kr(0.015).exprange(500, 1600)
        );

        deep = Splay.ar(
            [deep, DelayC.ar(deep, 0.3, 0.083)],
            0.8
        );

        haze = Mix.fill(16, {
            var deg, oct, freq, drift, tone, level;

            deg = Select.kr(
                LFNoise0.kr(
                    Rand(0.005, 0.02)
                ).range(0, 6.99),
                ~scale
            );

            oct = Select.kr(
                LFNoise0.kr(
                    Rand(0.003, 0.012)
                ).range(0, 2.99),
                [0, 12, 24]
            );

            freq = (~root + deg + oct).midicps;

            drift = LFNoise2.kr(
                Rand(0.008, 0.05)
            ).range(0.995, 1.005);

            level = LFNoise2.kr(
                Rand(0.008, 0.04)
            ).range(0, 1).squared;

            tone =
                SinOsc.ar(
                    freq * drift,
                    Rand(0, 2pi)
                )
                + (
                    SinOsc.ar(
                        freq * 2.001,
                        Rand(0, 2pi)
                    ) * 0.1
                );

            tone * level * 0.018;
        });

        haze = Splay.ar(
            Array.fill(8, {
                DelayC.ar(
                    haze,
                    0.5,
                    Rand(0.01, 0.45)
                )
            }),
            1
        );

        stars = Mix.fill(20, {
            var deg, freq, trig;

            deg = ~scale.choose;

            freq = (
                ~root
                + deg
				+ [36, 48, 48, 60].choose
            ).midicps;

            trig = Dust.ar(
                Rand(0.008, 0.05)
            );

            Ringz.ar(
                trig,
                freq * Rand(0.997, 1.003),
                Rand(4, 14),
                Rand(0.006, 0.018)
            );
        });

        stars = Splay.ar(
            Array.fill(7, {
                DelayC.ar(
                    stars,
                    1,
                    Rand(0.05, 0.9)
                )
            }),
            1
        );

        air = BPF.ar(
            PinkNoise.ar(0.06),
            LFNoise2.kr(0.018).exprange(700, 7500),
            LFNoise2.kr(0.025).range(0.08, 0.4)
        );

        air = air * LFNoise2.kr(0.025).range(0.15, 1);

        air = [
            DelayC.ar(
                air,
                1,
                LFNoise2.kr(0.009).range(0.02, 0.7)
            ),
            DelayC.ar(
                air,
                1,
                LFNoise2.kr(0.011).range(0.04, 0.8)
            )
        ];

        shine = Mix.fill(12, {
            var freq;

            freq = ExpRand(2200, 10000);

            SinOsc.ar(
                freq
                * LFNoise2.kr(
                    Rand(0.02, 0.1)
                ).range(0.96, 1.04),
                Rand(0, 2pi),
                LFNoise2.kr(
                    Rand(0.01, 0.05)
                ).range(0, 0.004)
            );
        });

        shine = HPF.ar(shine, 1800);

        shine = Splay.ar(
            Array.fill(5, {
                DelayC.ar(
                    shine,
                    0.8,
                    Rand(0.05, 0.65)
                )
            }),
            1
        );

        ion = BPF.ar(
            BrownNoise.ar(0.18),
            [
                LFNoise2.kr(0.013).exprange(900, 4500),
                LFNoise2.kr(0.017).exprange(1200, 7000)
            ],
            0.08
        );

        ion = FreqShift.ar(
            ion,
            [
                LFNoise2.kr(0.008).range(-70, 70),
                LFNoise2.kr(0.011).range(-110, 110)
            ]
        );

        ion = ion * LFNoise2.kr(0.018).range(0.05, 0.45);

        orbit = Mix.fill(12, {
            var exc, base, ratio, freq;

            exc = Dust.ar(
                Rand(0.004, 0.025)
            );

            base = (
                ~root
                + ~scale.choose
                + [24, 36, 48].choose
            ).midicps;

            ratio = [
                1.0,
                1.414,
                1.618,
                2.03,
                2.414,
                3.17
            ].choose;

            freq = base * ratio;

            Ringz.ar(
                exc,
                freq,
                Rand(5, 20),
                Rand(0.004, 0.015)
            );
        });

        orbit = Splay.ar(
            Array.fill(8, {
                DelayC.ar(
                    orbit,
                    1.5,
                    Rand(0.05, 1.3)
                )
            }),
            1
        );

        tx = Mix.fill(5, { |i|
            var car, mod, freq, sig, vis;

            freq = (
                ~root
                + [24, 29, 31, 33, 38][i]
            ).midicps;

            car = SinOsc.ar(
                freq
                * LFNoise2.kr(
                    Rand(0.005, 0.015)
                ).range(0.997, 1.003)
            );

            mod = SinOsc.kr(
                Rand(0.07, 0.24)
            ).range(0.1, 1);

            vis = LFNoise2.kr(
                Rand(0.006, 0.02)
            ).range(0, 1).pow(4);

            car * mod * vis * 0.015;
        });

        tx = FreqShift.ar(
            tx,
            LFNoise2.kr(0.006).range(-18, 18)
        );

        tx = [
            DelayC.ar(tx, 1.2, 0.137),
            DelayC.ar(tx, 1.2, 0.731)
        ];

        sig =
            (deep * 0.8)
            + haze
            + (stars * 0.5)
            + (air * 0.25)
            + (shine * 0.5)
            + (ion * 0.35)
            + (orbit * 0.65)
            + (tx * 0.55);

        sig = sig * breath;

        sig = RLPF.ar(
            sig,
            LFNoise2.kr(0.008).exprange(3500, 13000),
            LFNoise2.kr(0.011).range(0.35, 0.85)
        );

        sig = sig + (
            JPverb.ar(
                sig,
                t60: 17,
                damp: 0.12,
                size: 5.5,
                earlyDiff: 0.9,
                modDepth: 0.45,
                modFreq: 0.09
            ) * 0.72
        );

        sig = sig + (
            FreeVerb2.ar(
                sig[0],
                sig[1],
                mix: 0.35,
                room: 0.98,
                damp: 0.15
            ) * 0.18
        );

        sig = HPF.ar(sig, 30);
        sig = LeakDC.ar(sig);
        sig = Limiter.ar(sig * amp, 0.9, 0.05);

        Out.ar(out, sig * env);
    }).add;

    s.sync;

    ~space = Synth(
        \spaceyDrone,
        [\amp, 0.5]
    );
};
s.record();
)
