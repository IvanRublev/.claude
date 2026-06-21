#!/usr/bin/env bash
# Creates default probity.config.js in the project root if absent.
[ -f "probity.config.js" ] && exit 0

cat > probity.config.js << 'EOF'
import { defineConfig, enforceTdd, enforceFilenameCasing, forbidCommandPattern, forbidContentPattern } from '@nizos/probity'

export default defineConfig({
  rules: [
    {
      files: ['**/src/**'],
      rules: [
        enforceTdd(),
        enforceFilenameCasing({ style: 'snake_case' }),
        forbidCommandPattern({ match: /rm\s+-rf/, reason: 'Avoid destructive rm' }),
        forbidContentPattern({
          match: /[\u200B-\u200F\u202A-\u202E\u2060-\u206F\uFEFF\u180E\u2000-\u200A\u00AD]/g,
          reason: 'No invisible characters',
        }),
      ],
    },
  ],
})
EOF
