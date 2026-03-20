import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'
import { Mic, Brain, Map, Bell, CheckCircle2 } from 'lucide-react'

const STEPS = [
  {
    num: '01',
    icon: Mic,
    title: 'Field worker speaks survey in Hindi',
    desc: 'Speech-to-Text',
    color: '#1A56DB',
  },
  {
    num: '02',
    icon: Brain,
    title: 'Gemini structures the data',
    desc: 'Need record created',
    color: '#5B21B6',
  },
  {
    num: '03',
    icon: Map,
    title: 'AI scores urgency',
    desc: 'Heatmap turns red',
    color: '#EF4444',
  },
  {
    num: '04',
    icon: Bell,
    title: 'Match engine finds top 3 volunteers',
    desc: 'Push notification sent',
    color: '#0F766E',
  },
  {
    num: '05',
    icon: CheckCircle2,
    title: 'Volunteer arrives',
    desc: 'Geofence check-in · Impact Token earned',
    color: '#D97706',
  },
]

export default function HowItWorks() {
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section id="how-it-works" ref={ref} className="py-28 px-4" style={{ background: '#0F172A' }}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-20"
        >
          <h2 className="font-heading font-bold text-4xl sm:text-5xl text-text-primary mb-4">
            From spoken word to{' '}
            <span className="gradient-text">solved problem</span>
            {' '}in seconds
          </h2>
        </motion.div>

        <div className="relative">
          <div className="hidden lg:block absolute top-10 left-0 right-0 h-px" style={{ background: 'rgba(255,255,255,0.06)', zIndex: 0 }}>
            <motion.div
              className="h-full origin-left"
              style={{ background: 'linear-gradient(to right, #1A56DB, #5B21B6, #EF4444, #0F766E, #D97706)' }}
              initial={{ scaleX: 0 }}
              animate={isInView ? { scaleX: 1 } : {}}
              transition={{ duration: 1.5, delay: 0.5, ease: 'easeOut' }}
            />
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-5 gap-8 lg:gap-4 relative z-10">
            {STEPS.map((step, i) => (
              <motion.div
                key={step.num}
                initial={{ y: 40, opacity: 0 }}
                animate={isInView ? { y: 0, opacity: 1 } : {}}
                transition={{ duration: 0.6, delay: 0.3 + i * 0.2 }}
                className="flex lg:flex-col items-start lg:items-center gap-5 lg:gap-4 lg:text-center"
              >
                <motion.div
                  className="relative flex-shrink-0 w-20 h-20 rounded-full flex items-center justify-center"
                  style={{
                    background: `radial-gradient(circle, ${step.color}20 0%, transparent 70%)`,
                    border: `2px solid ${step.color}50`,
                    boxShadow: `0 0 20px ${step.color}20`,
                  }}
                  animate={isInView ? { boxShadow: [`0 0 20px ${step.color}20`, `0 0 40px ${step.color}40`, `0 0 20px ${step.color}20`] } : {}}
                  transition={{ duration: 2, repeat: Infinity, delay: i * 0.4 }}
                >
                  <step.icon size={24} style={{ color: step.color }} />
                  <span
                    className="absolute -top-2 -right-2 w-6 h-6 rounded-full flex items-center justify-center text-[10px] font-bold font-mono text-white"
                    style={{ background: step.color }}
                  >
                    {step.num}
                  </span>
                </motion.div>

                <div>
                  <h3 className="font-heading font-semibold text-sm text-text-primary mb-1 leading-snug">
                    {step.title}
                  </h3>
                  <p className="text-text-muted text-xs">{step.desc}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
