# Install husky 
npm i -D husky pretty-quick

# Add the following to package.json
"husky": {
  "hooks": {
    "pre-commit": "pretty-quick --staged"
  }
}

# Add the following to your .prettierrc config
"apexInsertFinalNewline": false


# Add the following to you precommit hook.
npx prettier — write 'src/**/*.{trigger,cls}'