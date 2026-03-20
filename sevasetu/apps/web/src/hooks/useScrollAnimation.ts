import { useRef } from 'react'
import { useInView } from 'framer-motion'

export function useScrollAnimation() {
  const ref = useRef<HTMLDivElement>(null)
  const isInView = useInView(ref, { once: true, margin: '-100px' })
  return { ref, isInView }
}
