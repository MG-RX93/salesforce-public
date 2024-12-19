Keep a single `main` branch while separating the `develop`, `hotfix`, and `release` branches by project & achieve an organized and effective branching strategy.

### Adjusted Branching Strategy

1. **Single Main Branch:**
   - There will be a single `main` branch that serves as the integration point for all projects.

2. **Project-Specific Development Branches:**
   - Each project will have its own `develop` branch:
     - `develop-case-severities`
     - `develop-web-to-case`
     - `develop-mule_p1_emails`
     - `develop-pb_migration`
     - `develop-salesforce_files`

3. **Feature Branches:**
   - Feature branches will stem from the respective project-specific `develop` branch:
     - `feature/case-severities/add-new-feature`
     - `feature/web-to-case/bugfix-123`
     - `feature/mule_p1_emails/integration-enhancement`
     - `feature/pb_migration/migrate-data`
     - `feature/salesforce_files/optimize-storage`

4. **Release Branches:**
   - Release branches will stem from the respective project-specific `develop` branch:
     - `release/case-severities/v1.0.0`
     - `release/web-to-case/v1.1.0`
     - `release/mule_p1_emails/v1.0.1`
     - `release/pb_migration/v1.0.0`
     - `release/salesforce_files/v1.0.0`

5. **Hotfix Branches:**
   - Hotfix branches will stem from the single `main` branch and be project-specific:
     - `hotfix/case-severities/fix-critical-bug`
     - `hotfix/web-to-case/security-patch`
     - `hotfix/mule_p1_emails/urgent-fix`
     - `hotfix/pb_migration/fix-migration-issue`
     - `hotfix/salesforce_files/fix-storage-bug`

### Example Git Workflow

1. **Single Main Branch:**
   - `main`: The integration point for all projects.

2. **Creating Development Branches:**
   ```bash
   git checkout -b develop-case-severities main
   git checkout -b develop-web-to-case main
   git checkout -b develop-mule_p1_emails main
   git checkout -b develop-pb_migration main
   git checkout -b develop-salesforce_files main
   ```

3. **Creating a Feature Branch:**
   ```bash
   git checkout -b feature/case-severities/add-new-feature develop-case-severities
   # Work on the feature...
   git add .
   git commit -m "Add new feature to case severities"
   git push origin feature/case-severities/add-new-feature
   ```

4. **Merging a Feature into Development:**
   ```bash
   git checkout develop-case-severities
   git merge feature/case-severities/add-new-feature
   git push origin develop-case-severities
   ```

5. **Creating a Release Branch:**
   ```bash
   git checkout -b release/case-severities/v1.0.0 develop-case-severities
   # Finalize release preparations...
   git add .
   git commit -m "Prepare v1.0.0 release for case severities"
   git push origin release/case-severities/v1.0.0
   ```

6. **Merging a Release into Main:**
   ```bash
   git checkout main
   git merge release/case-severities/v1.0.0
   git push origin main
   ```

7. **Tagging a Release:**
   ```bash
   git tag v1.0.0-case-severities
   git push origin v1.0.0-case-severities
   ```

8. **Creating a Hotfix Branch:**
   ```bash
   git checkout -b hotfix/case-severities/fix-critical-bug main
   # Work on the hotfix...
   git add .
   git commit -m "Fix critical bug in case severities"
   git push origin hotfix/case-severities/fix-critical-bug
   ```

9. **Merging a Hotfix into Main and Development:**
   ```bash
   git checkout main
   git merge hotfix/case-severities/fix-critical-bug
   git push origin main
   
   git checkout develop-case-severities
   git merge hotfix/case-severities/fix-critical-bug
   git push origin develop-case-severities
   ```

### Summary
- **Single Main Branch:** Use a single `main` branch for the integration of all projects.
- **Project-Specific Branches:** Create `develop`, `release`, and `hotfix` branches specific to each project.
- **Clear Naming Conventions:** Ensure branches are clearly named to indicate their purpose and associated project.

This strategy maintains a clean and organized approach, allowing for efficient development and version control while keeping a single integration point through the `main` branch.


### Diagram:
---
 ```mermaid
gitGraph
   commit id: "1. Initial Commit" tag: "main"
   branch develop-case-severities
   checkout develop-case-severities
   commit id: "2. Develop Case Severities"
   branch feature/case-severities/add-new-feature
   checkout feature/case-severities/add-new-feature
   commit id: "3. Add new feature to case severities"
   checkout develop-case-severities
   merge feature/case-severities/add-new-feature
   commit id: "4. Merge new feature"
   branch release/case-severities/v1.0.0
   checkout release/case-severities/v1.0.0
   commit id: "5. Prepare v1.0.0 release"
   checkout main
   merge release/case-severities/v1.0.0
   commit id: "6. Release v1.0.0"
   branch hotfix/case-severities/fix-critical-bug
   checkout hotfix/case-severities/fix-critical-bug
   commit id: "a. Fix critical bug"
   checkout main
   merge hotfix/case-severities/fix-critical-bug
   commit id: "b. Merge hotfix into main"
   checkout develop-case-severities
   merge hotfix/case-severities/fix-critical-bug
   commit id: "c. Merge hotfix into develop"
 ```