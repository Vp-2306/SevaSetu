import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'
import { Folder } from 'lucide-react'

const TEAM = [
  {
    name: 'Aarav Mehta',
    role: 'Flutter Frontend Lead',
    initials: 'AM',
    folder: '/apps/mobile',
    desc: 'Crafted the offline-first Flutter app powering all 5 user types. Expert in Dart and Firebase.',
    gradient: 'from-primary to-blue-400',
    color: '#1A56DB',
  },
  {
    name: 'Priya Sharma',
    role: 'Backend + Firebase',
    initials: 'PS',
    folder: '/apps/backend',
    desc: 'Built Cloud Run microservices, Firestore schemas, and the real-time pub/sub pipeline.',
    gradient: 'from-secondary to-purple-400',
    color: '#5B21B6',
  },
  {
    name: 'Rohan Iyer',
    role: 'ML + AI Engineer',
    initials: 'RI',
    folder: '/ml',
    desc: 'Designed the Gemini agent pipeline, volunteer matching model, and burnout prediction system.',
    gradient: 'from-accent to-teal-400',
    color: '#0F766E',
  },
  {
    name: 'Sneha Patel',
    role: 'Maps + DevOps',
    initials: 'SP',
    folder: '/infra',
    desc: 'Integrated the full Google Maps stack and manages Cloud Run deployments and CI/CD pipelines.',
    gradient: 'from-yellow-500 to-orange-400',
    color: '#D97706',
  },
]

export default function TeamSection() {
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section id="team" ref={ref} className="py-28 px-4" style={{ background: '#0F172A' }}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="font-heading font-bold text-4xl sm:text-5xl text-text-primary mb-4">
            The team{' '}
            <span className="gradient-text">building SevaSetu</span>
          </h2>
        </motion.div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {TEAM.map((member, i) => (
            <motion.div
              key={member.name}
              initial={{ y: 40, opacity: 0 }}
              animate={isInView ? { y: 0, opacity: 1 } : {}}
              transition={{ duration: 0.6, delay: i * 0.15 }}
              className="group relative rounded-2xl p-6 transition-all duration-300 hover:-translate-y-1"
              style={{
                background: '#1E293B',
                border: '1px solid rgba(255,255,255,0.07)',
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.border = `1px solid ${member.color}40`
                e.currentTarget.style.boxShadow = `0 8px 32px ${member.color}15`
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.border = '1px solid rgba(255,255,255,0.07)'
                e.currentTarget.style.boxShadow = 'none'
              }}
            >
              <div className={`w-16 h-16 rounded-full bg-gradient-to-br ${member.gradient} flex items-center justify-center mb-4 font-heading font-bold text-xl text-white shadow-lg`}>
                {member.initials}
              </div>

              <h3 className="font-heading font-semibold text-lg text-text-primary mb-0.5">{member.name}</h3>
              <p className="text-text-secondary text-sm mb-3">{member.role}</p>

              <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-md mb-4 w-fit"
                style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid rgba(255,255,255,0.08)' }}
              >
                <Folder size={12} className="text-text-muted" />
                <code className="text-xs font-mono text-text-muted">{member.folder}</code>
              </div>

              <p className="text-text-secondary text-sm leading-relaxed">{member.desc}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
