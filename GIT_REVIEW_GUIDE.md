# Git Review Guide

This document provides a comprehensive guide on how to review Git commit messages and deltas (changes) in the OtakuWarrior Store project. It's designed to help you prepare for code reviews with your instructor and understand the project's version control history.

## Project Git Requirements

The project meets the following Git requirements:

- ✅ **32+ Commits**: The repository contains 36 commits, exceeding the minimum requirement of 32.
- ✅ **3+ Branches**: The repository has 3 branches (main, feature/customer-profile, feature/order-status-fixes).
- ✅ **GitHub Remote Repository**: The local repository is linked to a GitHub remote repository.
- ✅ **Feature Branches Merged to Main**: Two feature branches were developed independently and merged into main.
- ✅ **Descriptive Commit Messages**: All commit messages clearly describe the changes made.
- ✅ **Commits Spread Out**: Commits represent different logical changes to the codebase.

## Reviewing Commit Messages

### 1. View Commit History

To see a list of all commits with their messages:

```bash
git log --oneline
```

This command shows a condensed view of the commit history, with each commit on a single line. The output includes:
- The abbreviated commit hash (e.g., 27c6587)
- The commit message

For a more detailed view with full commit messages:

```bash
git log
```

This command shows the complete commit history, including:
- The full commit hash
- Author information
- Date and time
- The complete commit message

### 2. View Commits by Author

To see commits by a specific author:

```bash
git log --author="authorname" --oneline
```

This is useful for identifying your contributions to the project, especially in a team environment.

For a more customized format:

```bash
git log --pretty=format:"%h - %an, %ar : %s" -5
```

This command formats the output to show:
- The abbreviated hash (%h)
- Author name (%an)
- Relative time (%ar)
- Subject line (%s)
- Limited to the last 5 commits (-5)

### 3. View Commits for a Specific File

To see the commit history for a specific file:

```bash
git log --oneline -- path/to/file
```

This command shows all commits that affected the specified file, which is useful for understanding how a particular file evolved over time.

## Reviewing Commit Deltas (Changes)

### 1. View Changes in a Specific Commit

To see a summary of what files were changed in a specific commit:

```bash
git show <commit-hash> --stat
```

This command shows:
- The commit information (hash, author, date, message)
- A summary of files changed, with the number of lines added/removed

To see the actual code changes in a commit:

```bash
git show <commit-hash>
```

This command shows the complete diff of the commit, including:
- All files that were modified
- The exact lines that were added (prefixed with +) or removed (prefixed with -)
- Context lines around the changes

### 2. Compare Changes Between Commits

To see changes between two specific commits:

```bash
git diff <commit1>..<commit2> --stat
```

This command shows a summary of all files changed between the two commits.

For detailed changes:

```bash
git diff <commit1>..<commit2>
```

This shows the complete diff between the two commits, which is useful for understanding how the codebase evolved between two points in time.

### 3. View Changes in a Merge Commit

To see what changes were introduced in a merge commit:

```bash
git show <merge-commit-hash> --stat
```

This shows a summary of all files that were changed as part of the merge.

For a more visual representation of the merge:

```bash
git log --graph --oneline --all -10
```

This command shows a graphical representation of the commit history, including branch and merge points, which helps visualize how features were developed and integrated.

### 4. View File History

To see the history of changes for a specific file:

```bash
git log -p path/to/file
```

This command shows the complete history of changes for the specified file, including the actual diffs for each commit that modified the file.

## Additional Useful Commands for Review

### 1. View Branch History

To see the history of branches and merges:

```bash
git log --graph --oneline --all -10
```

This command shows a graphical representation of the commit history, including:
- Branch points
- Merge points
- Commit messages
- Limited to the last 10 commits

### 2. Compare Branches

To see differences between branches:

```bash
git diff branch1..branch2 --name-only
```

This command lists all files that differ between the two branches, which is useful for understanding the scope of changes in a feature branch.

## Branching Strategy

The project used a feature-based branching strategy:

1. **Main Branch**: The stable, production-ready code
2. **Feature Branches**: 
   - `feature/customer-profile`: Developed customer profile management functionality
   - `feature/order-status-fixes`: Implemented order status tracking and checkout improvements

Each feature branch focused on a specific set of related functionality, allowing for isolated development without affecting the main codebase.

## Commit Strategy

The commit strategy followed these principles:

1. **Small, Focused Commits**: Each commit addresses a specific part of the feature
2. **Descriptive Messages**: Each commit message clearly describes what was changed and why
3. **Logical Grouping**: Related changes are grouped together in a single commit

## Merge Strategy

Feature branches were merged into main using the `--no-ff` flag (no fast-forward):

```bash
git merge feature/branch-name --no-ff -m "Merge message"
```

This approach preserves the branch history and creates a dedicated merge commit, making it easy to see when and how features were integrated.

## Benefits of This Approach

1. **Isolated Feature Development**: Features can be developed independently without affecting the main codebase
2. **Clear History**: The commit history provides a clear record of how each feature was developed
3. **Easy Integration**: The merge commits make it easy to see when features were integrated
4. **Rollback Capability**: If a feature introduces issues, it can be easily identified and rolled back
5. **Collaborative Development**: Multiple developers can work on different features simultaneously

## Conclusion

Understanding how to review Git history is essential for effective code reviews and project management. The commands and strategies outlined in this document provide a comprehensive toolkit for exploring and explaining the project's version control history.