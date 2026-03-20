import { useState, useRef } from 'react'
import { motion, useInView } from 'framer-motion'
import { ChevronLeft, ChevronRight, Mic, LayoutDashboard, Sparkles, HandHeart, BarChart3 } from 'lucide-react'

const USER_TYPES = [
  {
    id: 'field',
    name: 'Field Worker',
    badge: 'Teal',
    color: '#0F766E',
    bgColor: 'rgba(15,118,110,0.15)',
    borderColor: 'rgba(15,118,110,0.4)',
    icon: Mic,
    tagline: 'Reports needs by voice',
    bullets: [
      'Speaks surveys in Hindi — AI transcribes instantly',
      'Works fully offline with sync on connectivity',
      'Gets AI-generated task checklists each morning',
    ],
  },
  {
    id: 'ngo',
    name: 'NGO Coordinator',
    badge: 'Blue',
    color: '#1A56DB',
    bgColor: 'rgba(26,86,219,0.15)',
    borderColor: 'rgba(26,86,219,0.4)',
    icon: LayoutDashboard,
    tagline: 'Manages zones + AI dashboard',
    bullets: [
      'Real-time heatmap of unmet community needs',
      'Cross-NGO resource sharing to eliminate overlap',
      'Gemini-generated weekly impact reports',
    ],
  },
  {
    id: 'volunteer',
    name: 'Volunteer',
    badge: 'Purple',
    color: '#5B21B6',
    bgColor: 'rgba(91,33,182,0.15)',
    borderColor: 'rgba(91,33,182,0.4)',
    icon: Sparkles,
    tagline: 'Gets AI-matched tasks',
    bullets: [
      'Personality + skill match algorithm assigns tasks',
      'Earns Impact Tokens redeemable for certificates',
      'Burnout Shield limits weekly assignment load',
    ],
  },
  {
    id: 'community',
    name: 'Community Member',
    badge: 'Green',
    color: '#166534',
    bgColor: 'rgba(22,101,52,0.15)',
    borderColor: 'rgba(22,101,52,0.4)',
    icon: HandHeart,
    tagline: '3-button help request',
    bullets: [
      'Request help in 3 taps — no forms, no apps',
      'Real-time SMS updates on volunteer ETA',
      'Anonymous mode for sensitive situations',
    ],
  },
  {
    id: 'gov',
    name: 'Gov Admin',
    badge: 'Amber',
    color: '#D97706',
    bgColor: 'rgba(217,119,6,0.15)',
    borderColor: 'rgba(217,119,6,0.4)',
    icon: BarChart3,
    tagline: 'City-wide analytics',
    bullets: [
      'BigQuery dashboards with ward-level granularity',
      'Predictive shortage alerts 7 days in advance',
      'Exportable PDF reports for policy decisions',
    ],
  },
]

type UserType = typeof USER_TYPES[0]

function AnimatedContent({ isActive, user }: { isActive: boolean; user: UserType }) {
  if (!isActive) return null
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <span
        className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold mb-3"
        style={{ color: user.color, backgroundColor: user.bgColor }}
      >
        {user.badge}
      </span>
      <h3 className="font-heading font-bold text-xl text-text-primary mb-1">{user.name}</h3>
      <p className="text-text-secondary text-sm mb-4">{user.tagline}</p>
      <ul className="space-y-2">
        {user.bullets.map((b, i) => (
          <li key={i} className="flex items-start gap-2 text-sm text-text-secondary">
            <span className="mt-1.5 w-1.5 h-1.5 rounded-full flex-shrink-0" style={{ backgroundColor: user.color }} />
            {b}
          </li>
        ))}
      </ul>
    </motion.div>
  )
}

export default function SolutionSection() {
  const [active, setActive] = useState(0)
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  const prev = () => setActive((a) => (a - 1 + USER_TYPES.length) % USER_TYPES.length)
  const next = () => setActive((a) => (a + 1) % USER_TYPES.length)

  return (
    <section id="solution" ref={ref} className="py-28 px-4" style={{ background: '#0F172A' }}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="font-heading font-bold text-4xl sm:text-5xl text-text-primary mb-4">
            One platform.{' '}
            <span className="gradient-text">Five users.</span>
            {' '}Infinite impact.
          </h2>
        </motion.div>

        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="flex gap-4 overflow-hidden pb-4"
        >
          {USER_TYPES.map((user, i) => {
            const isActive = active === i
            const Icon = user.icon
            return (
              <motion.div
                key={user.id}
                onClick={() => setActive(i)}
                animate={{
                  flex: isActive ? 3 : 1,
                  opacity: isActive ? 1 : 0.6,
                }}
                transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] as const }}
                className="relative rounded-2xl p-5 cursor-pointer overflow-hidden min-w-0 flex-shrink-0"
                style={{
                  background: isActive ? `linear-gradient(135deg, #1E293B 0%, ${user.bgColor} 100%)` : '#1E293B',
                  border: `1px solid ${isActive ? user.borderColor : 'rgba(255,255,255,0.06)'}`,
                }}
                role="button"
                aria-label={`View ${user.name} user type`}
                tabIndex={0}
                onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') setActive(i) }}
              >
                <div
                  className="w-10 h-10 rounded-xl flex items-center justify-center mb-4 flex-shrink-0"
                  style={{ backgroundColor: user.bgColor, border: `1px solid ${user.borderColor}` }}
                >
                  <Icon size={18} style={{ color: user.color }} />
                </div>

                <AnimatedContent isActive={isActive} user={user} />
              </motion.div>
            )
          })}
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={isInView ? { opacity: 1 } : {}}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="flex items-center justify-center gap-4 mt-8"
        >
          <button
            onClick={prev}
            aria-label="Previous user type"
            className="p-2.5 rounded-xl border border-white/10 text-text-secondary hover:text-text-primary hover:bg-white/5 transition-all"
          >
            <ChevronLeft size={20} />
          </button>
          <div className="flex gap-2">
            {USER_TYPES.map((_, i) => (
              <button
                key={i}
                onClick={() => setActive(i)}
                aria-label={`Go to user type ${i + 1}`}
                className="h-1.5 rounded-full transition-all duration-300"
                style={{
                  width: active === i ? '24px' : '8px',
                  backgroundColor: active === i ? '#1A56DB' : 'rgba(255,255,255,0.2)',
                }}
              />
            ))}
          </div>
          <button
            onClick={next}
            aria-label="Next user type"
            className="p-2.5 rounded-xl border border-white/10 text-text-secondary hover:text-text-primary hover:bg-white/5 transition-all"
          >
            <ChevronRight size={20} />
          </button>
        </motion.div>
      </div>
    </section>
  )
}
