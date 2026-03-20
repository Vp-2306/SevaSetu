import { lazy, Suspense } from 'react'
import Navbar from './components/Navbar'
import Hero from './components/Hero'
import StatsBar from './components/StatsBar'

const ProblemSection = lazy(() => import('./components/ProblemSection'))
const SolutionSection = lazy(() => import('./components/SolutionSection'))
const FeaturesGrid = lazy(() => import('./components/FeaturesGrid'))
const HowItWorks = lazy(() => import('./components/HowItWorks'))
const TechStack = lazy(() => import('./components/TechStack'))
const TeamSection = lazy(() => import('./components/TeamSection'))
const Footer = lazy(() => import('./components/Footer'))

function SectionLoader() {
  return (
    <div className="flex items-center justify-center py-24">
      <div className="w-8 h-8 rounded-full border-2 border-primary border-t-transparent animate-spin" />
    </div>
  )
}

export default function App() {
  return (
    <div className="min-h-screen bg-background text-text-primary overflow-x-hidden">
      <Navbar />
      <main>
        <Hero />
        <StatsBar />
        <Suspense fallback={<SectionLoader />}>
          <ProblemSection />
          <SolutionSection />
          <FeaturesGrid />
          <HowItWorks />
          <TechStack />
          <TeamSection />
        </Suspense>
      </main>
      <Suspense fallback={<SectionLoader />}>
        <Footer />
      </Suspense>
    </div>
  )
}
