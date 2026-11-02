# Third-Party Notices

Code Agent Harness complements the [skills.sh](https://skills.sh/) ecosystem; it does not replace it. The repository [LICENSE](LICENSE) covers only the original work of this project. Third-party content keeps its own authorship and license.

## Installed on demand, not redistributed

These skills are expected by some harness skills but are **no longer tracked in the current tree of this repository**. They are listed in [`third-party/skills.txt`](third-party/skills.txt), ignored by `.gitignore`, and installed from their upstream with `./scripts/install-skills.sh`.

| Skill | Upstream | License |
|---|---|---|
| `vercel-react-best-practices` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | MIT |
| `vite` | [antfu/skills](https://github.com/antfu/skills) | Per upstream |
| `find-skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Per upstream |
| `tdd` | [mattpocock/skills](https://github.com/mattpocock/skills) | Unconfirmed |
| `ant-design` | `TBD` (upstream not identified yet) | Unverified |

Claude Code plugins in [`plugins/claude-plugins.txt`](plugins/claude-plugins.txt) (for example `claude-seo`) are installed from their own marketplaces and are not redistributed either.

## Redistributed with modifications

This skill started from an upstream skill and was adapted to this harness. Their upstream credit and license are kept here.

| Skill | Upstream | License | Local changes |
|---|---|---|---|
| `git-commit` | [github/awesome-copilot](https://github.com/github/awesome-copilot) | MIT (per upstream frontmatter) | Branch guards, no AI/tool co-author trailers, harness workflow wording |

Do not run `npx skills add` for `git-commit`: the upstream version would overwrite the adapted skill in `skills/`.

## Name collisions

Skills in `skills/` that share a name with a published skills.sh skill can be overwritten by `npx skills add`. The project's own UI polish skill and agent were renamed from `frontend-design` to `ui-polish` to avoid colliding with `anthropics/skills`.
