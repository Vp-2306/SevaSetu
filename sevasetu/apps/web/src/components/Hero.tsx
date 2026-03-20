import { useEffect, useRef, useState } from 'react'
import { motion } from 'framer-motion'
import { Play, FileText, ChevronDown, Zap, Users, Brain } from 'lucide-react'
import { useCountUp } from '../hooks/useCountUp'

const HEADLINE_LINE1 = 'The bridge between'
const HEADLINE_LINE2 = ['need', 'and', 'service.']

const STATS = [
  { icon: Zap, label: 'Google APIs', end: 20, suffix: '+', color: 'from-primary to-blue-400' },
  { icon: Users, label: 'User types', end: 5, suffix: '', color: 'from-secondary to-purple-400' },
  { icon: Brain, label: 'AI Features', end: 15, suffix: '', color: 'from-accent to-teal-400' },
]

function StatPill({ icon: Icon, label, end, suffix, color }: { icon: typeof Zap; label: string; end: number; suffix: string; color: string }) {
  const count = useCountUp(end, 2000, true)
  return (
    <div className="flex items-center gap-2.5 px-4 py-2.5 rounded-full glass border border-white/10">
      <div className={`w-7 h-7 rounded-full bg-gradient-to-br ${color} flex items-center justify-center flex-shrink-0`}>
        <Icon size={14} className="text-white" />
      </div>
      <span className="font-heading font-bold text-text-primary text-sm">
        {count}{suffix}
      </span>
      <span className="text-text-muted text-xs">{label}</span>
    </div>
  )
}

export default function Hero() {
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 })
  const heroRef = useRef<HTMLElement>(null)

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (!heroRef.current) return
      const rect = heroRef.current.getBoundingClientRect()
      setMousePos({
        x: (e.clientX - rect.left) / rect.width - 0.5,
        y: (e.clientY - rect.top) / rect.height - 0.5,
      })
    }
    const el = heroRef.current
    el?.addEventListener('mousemove', handleMouseMove)
    return () => el?.removeEventListener('mousemove', handleMouseMove)
  }, [])

  const wordVariants = {
    hidden: { y: 40, opacity: 0 },
    visible: (i: number) => ({
      y: 0,
      opacity: 1,
      transition: { duration: 0.6, delay: i * 0.1, ease: [0.22, 1, 0.36, 1] as const },
    }),
  }

  return (
    <section
      ref={heroRef}
      className="relative min-h-screen flex flex-col items-center justify-center overflow-hidden bg-background px-4"
      style={{ paddingTop: '80px' }}
    >
      <div
        className="absolute pointer-events-none"
        style={{
          left: '10%',
          top: '20%',
          width: '600px',
          height: '600px',
          background: 'radial-gradient(circle, rgba(26,86,219,0.18) 0%, transparent 70%)',
          transform: `translate(${mousePos.x * 30}px, ${mousePos.y * 30}px)`,
          transition: 'transform 0.1s ease-out',
        }}
      />
      <div
        className="absolute pointer-events-none"
        style={{
          right: '5%',
          top: '30%',
          width: '500px',
          height: '500px',
          background: 'radial-gradient(circle, rgba(91,33,182,0.15) 0%, transparent 70%)',
          transform: `translate(${mousePos.x * -20}px, ${mousePos.y * -20}px)`,
          transition: 'transform 0.1s ease-out',
        }}
      />

      <motion.div
        className="absolute w-64 h-64 rounded-full pointer-events-none"
        style={{ background: 'rgba(26,86,219,0.08)', filter: 'blur(60px)', top: '15%', left: '5%' }}
        animate={{ y: [0, -20, 0], scale: [1, 1.05, 1] }}
        transition={{ duration: 6, repeat: Infinity, ease: 'easeInOut' }}
      />
      <motion.div
        className="absolute w-48 h-48 rounded-full pointer-events-none"
        style={{ background: 'rgba(91,33,182,0.1)', filter: 'blur(50px)', bottom: '20%', right: '8%' }}
        animate={{ y: [0, 20, 0], scale: [1, 1.08, 1] }}
        transition={{ duration: 7, repeat: Infinity, ease: 'easeInOut', delay: 1 }}
      />

      <div className="relative z-10 max-w-5xl mx-auto text-center flex flex-col items-center gap-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="flex items-center gap-2.5 px-4 py-2 rounded-full gradient-border bg-surface"
        >
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75" />
            <span className="relative inline-flex rounded-full h-2 w-2 bg-primary" />
          </span>
          <span className="text-text-secondary text-xs font-medium tracking-wide">
            Google Solution Challenge 2026 · Smart Resource Allocation
          </span>
        </motion.div>

        <div className="font-heading font-bold leading-tight select-none">
          <div className="text-5xl sm:text-6xl lg:text-7xl text-text-primary overflow-hidden pb-2">
            {HEADLINE_LINE1.split(' ').map((word, i) => (
              <motion.span
                key={word}
                custom={i}
                variants={wordVariants}
                initial="hidden"
                animate="visible"
                className="inline-block mr-4"
              >
                {word}
              </motion.span>
            ))}
          </div>
          <div className="text-5xl sm:text-6xl lg:text-7xl overflow-hidden pb-2">
            {HEADLINE_LINE2.map((word, i) => (
              <motion.span
                key={word}
                custom={i + 3}
                variants={wordVariants}
                initial="hidden"
                animate="visible"
                className={`inline-block mr-4 ${i < 2 ? 'gradient-text' : 'text-text-primary'}`}
              >
                {word}
              </motion.span>
            ))}
          </div>
        </div>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.7 }}
          className="text-text-secondary text-lg sm:text-xl max-w-2xl leading-relaxed"
        >
          SevaSetu uses{' '}
          <span className="text-text-primary font-medium">Gemini AI</span>
          {' '}to match volunteers to community needs in real-time across India.{' '}
          <span className="text-text-primary font-medium">Built for Bharat.</span>
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.9 }}
          className="flex flex-col sm:flex-row gap-4"
        >
          <a
            href="#how-it-works"
            aria-label="See SevaSetu in action"
            className="flex items-center justify-center gap-2.5 px-7 py-3.5 rounded-xl bg-gradient-to-r from-primary to-secondary text-white font-semibold text-base hover:opacity-90 transition-all duration-200 glow-blue"
          >
            <Play size={18} fill="white" />
            See it in action
          </a>
          <a
            href="#features"
            aria-label="Read the SevaSetu proposal"
            className="flex items-center justify-center gap-2.5 px-7 py-3.5 rounded-xl glass border border-white/10 text-text-primary font-semibold text-base hover:bg-white/5 transition-all duration-200"
          >
            <FileText size={18} />
            Read the proposal
          </a>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 1.1 }}
          className="flex flex-wrap justify-center gap-3"
        >
          {STATS.map((stat) => (
            <StatPill key={stat.label} {...stat} />
          ))}
        </motion.div>
      </div>

      <motion.a
        href="#problem"
        aria-label="Scroll to next section"
        className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-1 text-text-muted hover:text-text-secondary transition-colors"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.5 }}
      >
        <span className="text-xs tracking-widest uppercase font-medium">Scroll</span>
        <motion.div
          animate={{ y: [0, 8, 0] }}
          transition={{ duration: 1.5, repeat: Infinity }}
        >
          <ChevronDown size={20} />
        </motion.div>
      </motion.a>
    </section>
  )
}
