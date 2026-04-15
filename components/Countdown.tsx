// components/Countdown.tsx
"use client";
import { useState, useEffect } from 'react';

const TARGET_DATE = new Date('2026-06-19T00:00:00').getTime();

export default function Countdown() {
  const [timeLeft, setTimeLeft] = useState({
    days: 0, hours: 0, minutes: 0, seconds: 0
  });

  useEffect(() => {
    const timer = setInterval(() => {
      const now = new Date().getTime();
      const distance = TARGET_DATE - now;

      if (distance < 0) {
        clearInterval(timer);
      } else {
        setTimeLeft({
          days: Math.floor(distance / (1000 * 60 * 60 * 24)),
          hours: Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
          minutes: Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)),
          seconds: Math.floor((distance % (1000 * 60)) / 1000),
        });
      }
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  return (
    <div className="flex flex-col items-center justify-center p-10 bg-black text-white rounded-xl border border-zinc-800">
      <h2 className="text-2xl mb-6 font-bold tracking-tighter uppercase">Bully Tour / June 19, 2026</h2>
      <div className="flex gap-8 text-center" role="timer">
        <div>
          <p className="text-5xl font-black">{timeLeft.days}</p>
          <p className="text-xs uppercase text-zinc-500">Days</p>
        </div>
        <div>
          <p className="text-5xl font-black">{timeLeft.hours}</p>
          <p className="text-xs uppercase text-zinc-500">Hours</p>
        </div>
        <div>
          <p className="text-5xl font-black">{timeLeft.minutes}</p>
          <p className="text-xs uppercase text-zinc-500">Min</p>
        </div>
        <div>
          <p className="text-5xl font-black">{timeLeft.seconds}</p>
          <p className="text-xs uppercase text-zinc-500">Sec</p>
        </div>
      </div>
    </div>
  );
}