import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'
import { FileX, Network, UserMinus } from 'lucide-react'

const PROBLEMS = [
  {
    num: '01',
    icon: FileX,
    title: 'Data stuck on paper',
    desc: 'Field workers fill paper surveys. Data arrives 3 weeks late.',
    accent: '#EF4444',
    borderColor: 'rgba(239,68,68,0.3)',
    bgGlow: 'rgba(239,68,68,0.05)',
  },
  {
    num: '02',
    icon: Network,
    title: "NGOs don't talk to each other",
    desc: 'Duplicate effort, some areas get triple coverage, others get zero.',
    accent: '#A855F7',
    borderColor: 'rgba(168,85,247,0.3)',
    bgGlow: 'rgba(168,85,247,0.05)',
  },
  {
    num: '03',
    icon: UserMinus,
    title: 'Volunteers burn out and leave',
    desc: 'Random task assignment, no recognition, no career benefit.',
    accent: '#F59E0B',
    borderColor: 'rgba(245,158,11,0.3)',
    bgGlow: 'rgba(245,158,11,0.05)',
  },
]

export default function ProblemSection() {
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section id="problem" ref={ref} className="py-28 px-4 bg-background">
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="font-heading font-bold text-4xl sm:text-5xl text-text-primary mb-4">
            Three problems{' '}
            <span className="gradient-text">killing NGO impact</span>
          </h2>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {PROBLEMS.map((p, i) => (
            <motion.div
              key={p.num}
              initial={{ y: 40, opacity: 0 }}
              animate={isInView ? { y: 0, opacity: 1 } : {}}
              transition={{ duration: 0.6, delay: i * 0.15 }}
              className="relative group cursor-default"
            >
              <span
                className="absolute -top-6 left-4 font-heading font-black text-8xl select-none pointer-events-none z-0"
                style={{ color: 'rgba(255,255,255,0.03)' }}
              >
                {p.num}
              </span>

              <div
                className="relative z-10 rounded-2xl p-6 transition-all duration-300 group-hover:-translate-y-2"
                style={{
                  background: `linear-gradient(135deg, #0F172A 0%, ${p.bgGlow} 100%)`,
                  border: `1px solid ${p.borderColor}`,
                }}
              >
                <div
                  className="w-12 h-12 rounded-xl flex items-center justify-center mb-5"
                  style={{ backgroundColor: `${p.accent}15`, border: `1px solid ${p.accent}30` }}
                >
                  <p.icon size={22} style={{ color: p.accent }} />
                </div>

                <span
                  className="inline-block px-2 py-0.5 rounded text-xs font-mono font-semibold mb-3"
                  style={{ color: p.accent, backgroundColor: `${p.accent}15` }}
                >
                  {p.num}
                </span>

                <h3 className="font-heading font-semibold text-xl text-text-primary mb-3">
                  {p.title}
                </h3>
                <p className="text-text-secondary text-sm leading-relaxed">
                  {p.desc}
                </p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
