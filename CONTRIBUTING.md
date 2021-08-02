# How To Contribute

## Pull Requests

1. [Fork our repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo) to your own account.

2. Create a new branch for your work. Try to choose a specific branch name. If you are working on something related to an existing issue, please use the format `DOCS-<ISSUE>` for the branch name.

3. When you have completed your work, push your branch to your fork and create a new Pull Request. 

4. As part of ongoing reviews, just do normal commits with *no* rebase between commits. This keeps the commit tree clean.

5. If your pull is approved, we will request that you squash your work into one commit (`git rebase -i HEAD~n` where `n` is the number of commits in the branch).

6. Once your approved pull is down to one squashed commit, do a `git pull --rebase` and resolve any remaining merge conflicts

7. Push back up to your branch. you might need to `git push -f` after squash + rebase

8. We will merge when we are able. 

We appreciate your contributions, and ask for your patience during reviews. 

## Issues

When creating a new issue, please consider the following:

- Search to see if your issue already exists. We will close duplicate or closely related issues as such. 

- Provide links to the page or pages in question. If you ran into issues during a tutorial, tell us more about your deployment environment and specific error messages you saw. 

- Keep it simple - the larger or more complex a request, the less likely it can be addressed in the short-term. We reserve the right to close feature requests if we cannot action them in a reasonable time frame. 

## Not a Support Channel

If you need support for your MinIO deployment, please check out our 
[community Slack Channel](https://slack.min.io/). 

We provide help with documentation-related issues on a best effort basis. Users who require help on a strict time frame can join the [MinIO Subscription Network (SUBNET)](https://min.io/pricing).


# Contributors License Agreement

This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/legalcode). All contributions to this work must be made under the same license.

# Contributor Covenant Code of Conduct

## Our Pledge

In the interest of fostering an open and welcoming environment, we as
contributors and maintainers pledge to make participation in our project and
our community a harassment-free experience for everyone, regardless of age, body
size, disability, ethnicity, sex characteristics, gender identity and expression,
level of experience, education, socio-economic status, nationality, personal
appearance, race, religion, or sexual identity and orientation.

## Our Standards

Examples of behavior that contributes to creating a positive environment
include:

* Using welcoming and inclusive language
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

* The use of sexualized language or imagery and unwelcome sexual attention or
  advances
* Trolling, insulting/derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or electronic
  address, without explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

## Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable
behavior and are expected to take appropriate and fair corrective action in
response to any instances of unacceptable behavior.

Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct, or to ban temporarily or
permanently any contributor for other behaviors that they deem inappropriate,
threatening, offensive, or harmful.

## Scope

This Code of Conduct applies within all project spaces, and it also applies when
an individual is representing the project or its community in public spaces.
Examples of representing a project or community include using an official
project e-mail address, posting via an official social media account, or acting
as an appointed representative at an online or offline event. Representation of
a project may be further defined and clarified by project maintainers.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported by contacting the project team at docs@min.io. All
complaints will be reviewed and investigated and will result in a response that
is deemed necessary and appropriate to the circumstances. The project team is
obligated to maintain confidentiality with regard to the reporter of an incident.
Further details of specific enforcement policies may be posted separately.

Project maintainers who do not follow or enforce the Code of Conduct in good
faith may face temporary or permanent repercussions as determined by other
members of the project's leadership.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage], version 1.4,
available at https://www.contributor-covenant.org/version/1/4/code-of-conduct.html

[homepage]: https://www.contributor-covenant.org

For answers to common questions about this code of conduct, see
https://www.contributor-covenant.org/faq

