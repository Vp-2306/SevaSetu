export const COLORS = {
  primary: '#1A56DB',
  secondary: '#5B21B6',
  accent: '#0F766E',
  success: '#166534',
  warning: '#92400E',
  background: '#0A0F1E',
  surface: '#0F172A',
  surfaceElevated: '#1E293B',
  border: 'rgba(255,255,255,0.08)',
  textPrimary: '#F8FAFC',
  textSecondary: '#94A3B8',
  textMuted: '#475569',
} as const

export const ANIMATION = {
  entrance: {
    initial: { y: 40, opacity: 0 },
    animate: { y: 0, opacity: 1 },
    transition: { duration: 0.6 },
  },
  viewport: { once: true, margin: '-100px' },
} as const
