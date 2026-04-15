// app/page.tsx
import Countdown from '@/components/Countdown';

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center bg-zinc-950 p-24">
      <h1 className="text-6xl font-black text-white mb-12 tracking-tighter italic">YE.</h1>
      <Countdown />
      <p className="mt-12 text-zinc-600 text-sm italic underline decoration-zinc-800">
        Everything Im not made me everything I am
      </p>
    </main>
  );
}