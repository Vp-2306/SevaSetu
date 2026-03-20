import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'
import { useCountUp } from '../hooks/useCountUp'

const STATS = [
  { end: 20, suffix: '+', label: 'Google APIs', sublabel: 'integrated' },
  { end: 5, suffix: '', label: 'User types', sublabel: 'supported' },
  { end: 15, suffix: '', label: 'AI features', sublabel: 'unique to SevaSetu' },
  { end: 4, suffix: '', label: 'ML models', sublabel: 'custom trained' },
]

function StatItem({ end, suffix, label, sublabel, isInView }: { end: number; suffix: string; label: string; sublabel: string; isInView: boolean }) {
  const count = useCountUp(end, 2000, isInView)
  return (
    <div className="flex flex-col items-center gap-2 px-8 py-6">
      <span className="font-heading font-black text-5xl sm:text-6xl gradient-text tabular-nums">
        {count}{suffix}
      </span>
      <span className="font-heading font-semibold text-text-primary text-base">{label}</span>
      <span className="text-text-muted text-xs uppercase tracking-wider">{sublabel}</span>
    </div>
  )
}

export default function StatsBar() {
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section ref={ref} className="py-0" style={{ background: '#0F172A' }}>
      <motion.div
        initial={{ opacity: 0 }}
        animate={isInView ? { opacity: 1 } : {}}
        transition={{ duration: 0.6 }}
        className="relative"
        style={{
          borderTop: '1px solid',
          borderBottom: '1px solid',
          borderImageSource: 'linear-gradient(to right, transparent, #1A56DB, #5B21B6, transparent)',
          borderImageSlice: 1,
        }}
      >
        <div className="max-w-7xl mx-auto grid grid-cols-2 lg:grid-cols-4 divide-x divide-y lg:divide-y-0 divide-white/[0.06]">
          {STATS.map((stat, i) => (
            <motion.div
              key={stat.label}
              initial={{ y: 20, opacity: 0 }}
              animate={isInView ? { y: 0, opacity: 1 } : {}}
              transition={{ duration: 0.6, delay: i * 0.15 }}
            >
              <StatItem {...stat} isInView={isInView} />
            </motion.div>
          ))}
        </div>
      </motion.div>
    </section>
  )
}
