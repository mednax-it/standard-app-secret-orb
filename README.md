# Orb Template


[![CircleCI Build Status](https://circleci.com/gh/mednax-it/standard-app-secret-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/mednax-it/standard-app-secret-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/mednax/standard-app-secret-orb.svg)](https://circleci.com/developer/orbs/orb/mednax/standard-app-secret-orb) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/mednax-it/standard-app-secret-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)



This project is intended to wrap [standard-app-secret-generation](https://github.com/mednax-it/standard-app-secret-generation) in a orb to simplify use.  The orb is intended to only do a git checkout, terraform init, and terraform apply.  

Please see `src/examples/example.yml` for how to use the orb.

You must be a Pediatrix team member for this to work since it relies on an image that is only available to Pediatrix team members.

---

## Resources

[CircleCI Orb Registry Page](https://circleci.com/developer/orbs/orb/mednax/standard-app-secret-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/mednax-it/standard-app-secret-orb/issues) to and [pull requests](https://github.com/mednax-it/standard-app-secret-orb/pulls) against this repository!

### How to Publish An Update
1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info mednax/standard-app-secret-orb | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/mednax-it/standard-app-secret-orb/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.
