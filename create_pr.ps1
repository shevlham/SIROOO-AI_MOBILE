git status
git checkout -b feature/ui-ux-enhancements
git add .
git commit -m "feat: enhance UI/UX, fix schedule CRUD, personalize chat"
git push -u origin feature/ui-ux-enhancements
gh pr create --title "feat: UI/UX Enhancements & Schedule CRUD Fixes" --body "Automated PR."
