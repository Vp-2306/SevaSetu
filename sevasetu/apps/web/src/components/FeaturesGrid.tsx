import { useRef } from 'react'
import type { ReactElement } from 'react'
import { motion, useInView } from 'framer-motion'
import { Mic, Shield, TrendingUp, Award, Map, Camera } from 'lucide-react'

const FEATURES = [
  {
    id: 'voice',
    span: 'col-span-2',
    title: 'Gemini Voice Coordinator',
    desc: 'Speak your field report in any Indian language. AI structures the data.',
    icon: Mic,
    color: '#1A56DB',
    bgColor: 'rgba(26,86,219,0.1)',
    preview: 'chat',
  },
  {
    id: 'burnout',
    span: 'row-span-2',
    title: 'Burnout Shield',
    desc: 'AI monitors volunteer load and prevents overcommitment.',
    icon: Shield,
    color: '#EF4444',
    bgColor: 'rgba(239,68,68,0.1)',
    preview: 'chart',
  },
  {
    id: 'forecast',
    span: '',
    title: 'Need Forecasting',
    desc: 'Predict resource shortages 7 days in advance.',
    icon: TrendingUp,
    color: '#0F766E',
    bgColor: 'rgba(15,118,110,0.1)',
    preview: 'heatmap',
  },
  {
    id: 'token',
    span: '',
    title: 'Impact Token',
    desc: 'Blockchain-verifiable certificates for volunteer hours.',
    icon: Award,
    color: '#D97706',
    bgColor: 'rgba(217,119,6,0.1)',
    preview: 'badge',
  },
  {
    id: 'coverage',
    span: '',
    title: 'Cross-NGO Coverage',
    desc: 'Eliminate blind spots and duplicate effort across organizations.',
    icon: Map,
    color: '#5B21B6',
    bgColor: 'rgba(91,33,182,0.1)',
    preview: 'zones',
  },
  {
    id: 'ar',
    span: 'col-span-2',
    title: 'AR Volunteer Radar',
    desc: 'Augmented reality layer shows live volunteer positions and task pins.',
    icon: Camera,
    color: '#06B6D4',
    bgColor: 'rgba(6,182,212,0.1)',
    preview: 'ar',
  },
]

function ChatPreview() {
  const msgs = [
    { role: 'user', text: 'Water supply issue in ward 7, families affected...' },
    { role: 'ai', text: 'Understood. Creating need record: 12 families, urgency HIGH. Notifying 3 nearest volunteers.' },
  ]
  return (
    <div className="mt-4 space-y-2">
      {msgs.map((m, i) => (
        <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
          <div
            className="max-w-[80%] rounded-xl px-3 py-2 text-xs"
            style={{
              background: m.role === 'ai' ? 'rgba(26,86,219,0.2)' : 'rgba(255,255,255,0.07)',
              border: '1px solid rgba(255,255,255,0.08)',
            }}
          >
            {m.role === 'ai' && (
              <span className="text-primary text-[10px] font-semibold block mb-1">Gemini AI</span>
            )}
            <span className="text-text-secondary">{m.text}</span>
          </div>
        </div>
      ))}
      <div className="flex justify-start">
        <div className="px-3 py-2 rounded-xl text-xs" style={{ background: 'rgba(26,86,219,0.1)', border: '1px solid rgba(26,86,219,0.2)' }}>
          <span className="flex gap-1">
            {[0, 1, 2].map(i => (
              <motion.span
                key={i}
                className="w-1.5 h-1.5 rounded-full bg-primary inline-block"
                animate={{ y: [0, -4, 0] }}
                transition={{ duration: 0.6, repeat: Infinity, delay: i * 0.15 }}
              />
            ))}
          </span>
        </div>
      </div>
    </div>
  )
}

function ChartPreview() {
  const points = [20, 35, 28, 45, 60, 55, 70, 58, 80, 65]
  const max = 100
  const w = 200
  const h = 80
  const pts = points.map((p, i) => `${(i / (points.length - 1)) * w},${h - (p / max) * h}`).join(' ')
  return (
    <div className="mt-4">
      <svg viewBox={`0 0 ${w} ${h}`} className="w-full" style={{ height: '70px' }}>
        <polyline
          points={pts}
          fill="none"
          stroke="#EF4444"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        <line x1="0" y1={h * 0.3} x2={w} y2={h * 0.3} stroke="#EF444480" strokeWidth="1" strokeDasharray="4,4" />
        <text x="4" y={h * 0.3 - 3} fill="#EF4444" fontSize="8" fontFamily="monospace">THRESHOLD</text>
      </svg>
    </div>
  )
}

function HeatmapPreview() {
  const palette = ['#EF4444', '#EF4444', '#F59E0B', '#0F766E', '#0F766E', '#EF4444', '#F59E0B', '#0F766E',
    '#F59E0B', '#EF4444', '#0F766E', '#0F766E', '#EF4444', '#F59E0B', '#0F766E', '#EF4444']
  return (
    <div className="mt-4 grid grid-cols-4 gap-1">
      {palette.map((c, i) => (
        <div key={i} className="h-6 rounded" style={{ backgroundColor: c, opacity: 0.8 }} />
      ))}
    </div>
  )
}

function BadgePreview() {
  return (
    <div className="mt-4 flex justify-center">
      <motion.div
        className="relative w-16 h-16 rounded-full flex items-center justify-center"
        style={{ background: 'conic-gradient(from 0deg, #D97706, #F59E0B, #FCD34D, #D97706)', padding: '2px' }}
        animate={{ rotate: 360 }}
        transition={{ duration: 8, repeat: Infinity, ease: 'linear' }}
      >
        <div className="w-full h-full rounded-full bg-surface-elevated flex items-center justify-center">
          <Award size={22} style={{ color: '#D97706' }} />
        </div>
      </motion.div>
    </div>
  )
}

function ZonesPreview() {
  return (
    <div className="mt-4 relative h-20 flex items-center justify-center">
      <div className="absolute w-20 h-20 rounded-full border-2 opacity-60" style={{ borderColor: '#1A56DB', background: 'rgba(26,86,219,0.15)', left: '30%' }} />
      <div className="absolute w-20 h-20 rounded-full border-2 opacity-60" style={{ borderColor: '#5B21B6', background: 'rgba(91,33,182,0.15)', left: '45%' }} />
      <span className="absolute text-[10px] text-text-muted font-mono" style={{ left: '35%', top: '50%', transform: 'translateY(-50%)' }}>overlap</span>
    </div>
  )
}

function ARPreview() {
  const pins = [
    { x: '20%', y: '30%', label: 'V1', delay: 0 },
    { x: '55%', y: '60%', label: 'V2', delay: 0.3 },
    { x: '75%', y: '25%', label: 'V3', delay: 0.6 },
  ]
  return (
    <div className="mt-4 relative h-20 rounded-xl overflow-hidden" style={{ background: 'rgba(6,182,212,0.05)', border: '1px dashed rgba(6,182,212,0.3)' }}>
      <div className="absolute inset-0 flex items-center justify-center">
        <div className="w-12 h-12 border-2 rounded-sm opacity-40" style={{ borderColor: '#06B6D4' }} />
        <div className="absolute w-2 h-2 border-t-2 border-l-2 top-2 left-2 opacity-60" style={{ borderColor: '#06B6D4' }} />
        <div className="absolute w-2 h-2 border-t-2 border-r-2 top-2 right-2 opacity-60" style={{ borderColor: '#06B6D4' }} />
        <div className="absolute w-2 h-2 border-b-2 border-l-2 bottom-2 left-2 opacity-60" style={{ borderColor: '#06B6D4' }} />
        <div className="absolute w-2 h-2 border-b-2 border-r-2 bottom-2 right-2 opacity-60" style={{ borderColor: '#06B6D4' }} />
      </div>
      {pins.map((pin) => (
        <motion.div
          key={pin.label}
          className="absolute"
          style={{ left: pin.x, top: pin.y }}
          animate={{ y: [0, -3, 0] }}
          transition={{ duration: 2, repeat: Infinity, delay: pin.delay }}
        >
          <div className="w-6 h-6 rounded-full flex items-center justify-center text-[9px] font-bold text-white" style={{ background: '#06B6D4' }}>
            {pin.label}
          </div>
        </motion.div>
      ))}
    </div>
  )
}

const PREVIEW_MAP: Record<string, () => ReactElement> = {
  chat: ChatPreview,
  chart: ChartPreview,
  heatmap: HeatmapPreview,
  badge: BadgePreview,
  zones: ZonesPreview,
  ar: ARPreview,
}

export default function FeaturesGrid() {
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section id="features" ref={ref} className="py-28 px-4 bg-background">
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="font-heading font-bold text-4xl sm:text-5xl text-text-primary mb-4">
            Features that have{' '}
            <span className="gradient-text">never been built before</span>
          </h2>
          <p className="text-text-secondary text-lg">For any NGO platform. Anywhere in the world.</p>
        </motion.div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 auto-rows-auto">
          {FEATURES.map((feat, i) => {
            const Preview = PREVIEW_MAP[feat.preview]
            return (
              <motion.div
                key={feat.id}
                initial={{ y: 40, opacity: 0 }}
                animate={isInView ? { y: 0, opacity: 1 } : {}}
                transition={{ duration: 0.6, delay: i * 0.1 }}
                className={`group rounded-2xl p-5 transition-all duration-300 hover:-translate-y-2 cursor-default ${
                  feat.span === 'col-span-2' ? 'sm:col-span-2' : ''
                } ${feat.span === 'row-span-2' ? 'sm:row-span-2' : ''}`}
                style={{
                  background: '#0F172A',
                  border: '1px solid rgba(255,255,255,0.07)',
                  boxShadow: '0 0 0 0 transparent',
                }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.border = `1px solid ${feat.color}50`
                  e.currentTarget.style.boxShadow = `0 8px 32px ${feat.color}20`
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.border = '1px solid rgba(255,255,255,0.07)'
                  e.currentTarget.style.boxShadow = '0 0 0 0 transparent'
                }}
              >
                <div
                  className="w-10 h-10 rounded-xl flex items-center justify-center mb-4"
                  style={{ backgroundColor: feat.bgColor, border: `1px solid ${feat.color}30` }}
                >
                  <feat.icon size={18} style={{ color: feat.color }} />
                </div>
                <h3 className="font-heading font-semibold text-lg text-text-primary mb-1.5">
                  {feat.title}
                </h3>
                <p className="text-text-secondary text-sm leading-relaxed">{feat.desc}</p>
                {Preview && <Preview />}
              </motion.div>
            )
          })}
        </div>
      </div>
    </section>
  )
}
