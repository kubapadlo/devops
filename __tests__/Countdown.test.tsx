// __tests__/Countdown.test.tsx
import { render, screen } from '@testing-library/react';
import Countdown from '@/components/Countdown';

describe('Countdown Component', () => {
  it('renders the correct target date title', () => {
    render(<Countdown />);
    const title = screen.getByText(/June 19, 2026/i);
    expect(title).toBeInTheDocument();
  });

  it('renders the timer labels', () => {
    render(<Countdown />);
    expect(screen.getByText('Days')).toBeInTheDocument();
    expect(screen.getByText('Hours')).toBeInTheDocument();
    expect(screen.getByText('Min')).toBeInTheDocument();
    expect(screen.getByText('Sec')).toBeInTheDocument();
  });

  it('has a timer role for accessibility', () => {
    render(<Countdown />);
    const timer = screen.getByRole('timer');
    expect(timer).toBeInTheDocument();
  });
});