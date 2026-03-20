import { Github, ExternalLink, Heart } from 'lucide-react'

const LINKS = {
  'Project': [
    { label: 'Features', href: '#features' },
    { label: 'How it Works', href: '#how-it-works' },
    { label: 'Tech Stack', href: '#tech' },
    { label: 'Team', href: '#team' },
  ],
  'Technology': [
    { label: 'Google Gemini', href: 'https://deepmind.google/technologies/gemini/', external: true },
    { label: 'Firebase', href: 'https://firebase.google.com', external: true },
    { label: 'Google Maps Platform', href: 'https://mapsplatform.google.com', external: true },
    { label: 'Vertex AI', href: 'https://cloud.google.com/vertex-ai', external: true },
  ],
  'Contact': [
    { label: 'GitHub Repository', href: 'https://github.com', external: true },
    { label: 'Report an Issue', href: 'https://github.com', external: true },
    { label: 'Email the Team', href: 'mailto:team@sevasetu.in', external: true },
  ],
}

export default function Footer() {
  return (
    <footer className="border-t py-16 px-4" style={{ borderColor: 'rgba(255,255,255,0.08)', background: '#0A0F1E' }}>
      <div className="max-w-7xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-12 mb-12">
          <div className="lg:col-span-1">
            <div className="flex items-center gap-2.5 mb-4">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-primary to-secondary flex items-center justify-center font-heading font-bold text-white text-sm">
                S
              </div>
              <span className="font-heading font-semibold text-text-primary text-lg">SevaSetu</span>
            </div>
            <p className="text-text-secondary text-sm leading-relaxed mb-5">
              Built for Bharat. Powered by Google AI.
            </p>
            <a
              href="https://github.com"
              target="_blank"
              rel="noopener noreferrer"
              aria-label="View SevaSetu on GitHub"
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl border border-white/10 text-text-secondary hover:text-text-primary hover:bg-white/5 transition-all text-sm font-medium w-fit"
            >
              <Github size={16} />
              View on GitHub
            </a>
          </div>

          {Object.entries(LINKS).map(([category, links]) => (
            <div key={category}>
              <h4 className="font-heading font-semibold text-text-primary text-sm uppercase tracking-widest mb-5">
                {category}
              </h4>
              <ul className="space-y-3">
                {links.map((link) => (
                  <li key={link.label}>
                    <a
                      href={link.href}
                      target={'external' in link && link.external ? '_blank' : undefined}
                      rel={'external' in link && link.external ? 'noopener noreferrer' : undefined}
                      className="flex items-center gap-1.5 text-text-secondary hover:text-text-primary text-sm transition-colors"
                    >
                      {link.label}
                      {'external' in link && link.external && <ExternalLink size={11} className="opacity-50" />}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="h-px mb-8" style={{ background: 'rgba(255,255,255,0.06)' }} />

        <div className="flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2 text-text-muted text-xs">
            <span>© 2026 SevaSetu</span>
            <span>·</span>
            <span>Hack2Skill Google Solution Challenge 2026</span>
          </div>
          <div className="flex items-center gap-1.5 text-text-muted text-xs">
            <span>Made with</span>
            <Heart size={12} className="text-red-500" />
            <span>for Bharat</span>
          </div>
        </div>
      </div>
    </footer>
  )
}
