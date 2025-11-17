'use client'

import { useEffect } from 'react'
import { initToolbar } from '@21st-extension/toolbar'

export function DevToolbar() {
  useEffect(() => {
    // Only initialize in development mode
    if (process.env.NODE_ENV === 'development') {
      const stagewiseConfig = {
        plugins: [],
      }

      // Initialize the toolbar
      initToolbar(stagewiseConfig)

      console.log('🛠️ Development toolbar initialized')
    }
  }, [])

  // This component doesn't render anything visible
  return null
}
