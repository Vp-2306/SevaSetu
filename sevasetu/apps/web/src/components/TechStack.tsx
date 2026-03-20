import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'

const TECH_ROWS = [
  {
    label: 'AI / ML',
    color: '#5B21B6',
    bgColor: 'rgba(91,33,182,0.15)',
    borderColor: 'rgba(91,33,182,0.3)',
    items: [
      { name: 'Gemini 3.1 Pro', desc: 'Voice + text coordination', tooltip: 'Powers voice surveys and the Gemini AI coordinator chatbot' },
      { name: 'Vertex AI ADK', desc: 'Agent framework', tooltip: 'Orchestrates multi-step volunteer matching agent pipelines' },
      { name: 'Agent Engine', desc: 'Deploy AI agents', tooltip: 'Deploys and scales our burnout-prediction and need-forecasting agents' },
      { name: 'Vertex AutoML', desc: 'Custom ML models', tooltip: 'Trains volunteer-need compatibility classifier on SevaSetu data' },
    ],
  },
  {
    label: 'Language',
    color: '#0F766E',
    bgColor: 'rgba(15,118,110,0.15)',
    borderColor: 'rgba(15,118,110,0.3)',
    items: [
      { name: 'Speech-to-Text v2', desc: 'Hindi/regional audio', tooltip: 'Transcribes field worker voice surveys in 12 Indian languages' },
      { name: 'Document AI', desc: 'OCR + extraction', tooltip: 'Digitizes paper surveys and government documents automatically' },
      { name: 'Cloud Translation', desc: '50+ languages', tooltip: 'Translates need reports between field workers and coordinators' },
      { name: 'Natural Language API', desc: 'Entity + sentiment', tooltip: 'Extracts urgency level and resource type from free-form text' },
    ],
  },
  {
    label: 'Maps',
    color: '#166534',
    bgColor: 'rgba(22,101,52,0.15)',
    borderColor: 'rgba(22,101,52,0.3)',
    items: [
      { name: 'Maps SDK', desc: 'Interactive heatmaps', tooltip: 'Renders real-time need heatmaps and volunteer position overlays' },
      { name: 'Routes API', desc: 'Optimal pathing', tooltip: 'Calculates fastest routes for volunteers to reach assigned locations' },
      { name: 'Distance Matrix', desc: 'Proximity scoring', tooltip: 'Scores volunteer-need pairs by travel time for smart matching' },
      { name: 'Places API', desc: 'Location enrichment', tooltip: 'Enriches need records with nearby facilities and landmarks' },
    ],
  },
  {
    label: 'Firebase',
    color: '#D97706',
    bgColor: 'rgba(217,119,6,0.15)',
    borderColor: 'rgba(217,119,6,0.3)',
    items: [
      { name: 'Firestore', desc: 'Real-time sync', tooltip: 'Syncs need records and volunteer assignments across all devices' },
      { name: 'Firebase Auth', desc: 'Role-based access', tooltip: 'Authenticates all 5 user types with phone number + OTP in India' },
      { name: 'Firebase FCM', desc: 'Push notifications', tooltip: 'Sends task assignment alerts to volunteers in under 500ms' },
      { name: 'Offline Persistence', desc: 'Works without data', tooltip: 'Allows field workers to submit surveys with no internet connection' },
    ],
  },
  {
    label: 'Cloud',
    color: '#1A56DB',
    bgColor: 'rgba(26,86,219,0.15)',
    borderColor: 'rgba(26,86,219,0.3)',
    items: [
      { name: 'Cloud Run', desc: 'Serverless backend', tooltip: 'Runs the SevaSetu API with auto-scaling to zero cost at night' },
      { name: 'BigQuery', desc: 'Analytics warehouse', tooltip: 'Powers government admin dashboards with ward-level SQL queries' },
      { name: 'Pub/Sub', desc: 'Event streaming', tooltip: 'Streams real-time need events to all subscribers simultaneously' },
      { name: 'Cloud Scheduler', desc: 'Cron jobs', tooltip: 'Triggers weekly burnout assessments and need forecast models' },
    ],
  },
  {
    label: 'Dev Tools',
    color: '#64748B',
    bgColor: 'rgba(100,116,139,0.15)',
    borderColor: 'rgba(100,116,139,0.3)',
    items: [
      { name: 'Looker Studio', desc: 'Data visualization', tooltip: 'Builds beautiful impact dashboards shared with NGO stakeholders' },
      { name: 'Firebase Analytics', desc: 'Usage insights', tooltip: 'Tracks feature adoption and user retention across all 5 user types' },
      { name: 'Gemini Code Assist', desc: 'AI pair programming', tooltip: "Helped build 60% of SevaSetu's backend with AI-assisted coding" },
      { name: 'Firebase Studio', desc: 'Project management', tooltip: 'Central hub for managing Firebase resources across environments' },
    ],
  },
]

export default function TechStack() {
  const ref = useRef<HTMLElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })

  return (
    <section id="tech" ref={ref} className="py-28 px-4 bg-background">
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={isInView ? { y: 0, opacity: 1 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="font-heading font-bold text-4xl sm:text-5xl text-text-primary mb-4">
            Built entirely on{' '}
            <span className="gradient-text">Google's technology stack</span>
          </h2>
        </motion.div>

        <div className="space-y-8">
          {TECH_ROWS.map((row, rowIndex) => (
            <motion.div
              key={row.label}
              initial={{ y: 40, opacity: 0 }}
              animate={isInView ? { y: 0, opacity: 1 } : {}}
              transition={{ duration: 0.6, delay: rowIndex * 0.1 }}
            >
              <div className="flex items-center gap-3 mb-4">
                <span
                  className="text-xs font-semibold uppercase tracking-widest px-3 py-1 rounded-full"
                  style={{ color: row.color, backgroundColor: row.bgColor, border: `1px solid ${row.borderColor}` }}
                >
                  {row.label}
                </span>
                <div className="flex-1 h-px" style={{ background: 'rgba(255,255,255,0.05)' }} />
              </div>

              <div className="flex flex-wrap gap-3">
                {row.items.map((item, i) => (
                  <motion.div
                    key={item.name}
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={isInView ? { opacity: 1, scale: 1 } : {}}
                    transition={{ duration: 0.4, delay: rowIndex * 0.1 + i * 0.08 }}
                    className="group relative"
                    title={item.tooltip}
                  >
                    <div
                      className="flex items-center gap-2.5 px-4 py-2.5 rounded-xl cursor-default transition-all duration-200 hover:-translate-y-1"
                      style={{
                        background: '#1E293B',
                        border: '1px solid rgba(255,255,255,0.07)',
                      }}
                      onMouseEnter={(e) => {
                        e.currentTarget.style.border = `1px solid ${row.borderColor}`
                        e.currentTarget.style.background = row.bgColor
                      }}
                      onMouseLeave={(e) => {
                        e.currentTarget.style.border = '1px solid rgba(255,255,255,0.07)'
                        e.currentTarget.style.background = '#1E293B'
                      }}
                    >
                      <span className="font-heading font-semibold text-sm text-text-primary">{item.name}</span>
                      <span className="text-xs text-text-muted">{item.desc}</span>
                    </div>

                    <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-56 px-3 py-2 rounded-lg text-xs text-text-secondary opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-50"
                      style={{ background: '#1E293B', border: '1px solid rgba(255,255,255,0.1)', boxShadow: '0 8px 24px rgba(0,0,0,0.4)' }}
                    >
                      {item.tooltip}
                    </div>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
