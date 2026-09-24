## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`

The resolved acceptance environment is the committed command `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The existing workflow `.github/workflows/shepherd-task-math-tool.yml` pins Pester 5.7.1 and invokes that runner; do not replace or bypass either contract.

The resolved observable contract is that direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`, while functions return their numeric value with no incidental output. Inputs are non-negative integers. The production and test files must be the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.

Research established no separate spike implementation to copy. The controlling findings are the plan's resolved contracts above: keep calculation pure, keep direct-execution formatting at the CLI boundary, use the repository-owned Pester runner, and test CLI behavior in an isolated child `pwsh` process rather than relying only on dot-sourced behavior.

## Branch and execution order

Use `experiment/shepherd-control` as the PR base branch. This is serial task 1 of 2. Tasks are assigned, completed, and merged in plan order. Do not start until this issue is assigned to the coding agent; task 2 starts only after this task is merged.

## Implement

Create repository-root `math-tool.ps1` with:

- A script parameter named `N` that accepts non-negative integers.
- A pure `Get-Fibonacci` function that returns the numeric Fibonacci value and emits no incidental output.
- Direct-execution behavior that calls the function and writes exactly one stdout line formatted as `Fibonacci(N) = value`.
- Dot-source-safe behavior so loading the script for unit tests does not print the CLI result line.

Use the conventional sequence required by the plan: `N=0` returns `0`, `N=1` returns `1`, and later values are derived from the preceding two values.

Create repository-root `math-tool.Tests.ps1` with Pester coverage that:

- Dot-sources `math-tool.ps1` and directly tests `Get-Fibonacci`.
- Covers `N=0`, `N=1`, and at least one small representative value greater than 1 with an exact expected numeric result.
- Launches an isolated child `pwsh` process for direct CLI tests rather than simulating direct execution in the unit-test process.
- Verifies exact stdout for the same edge and representative inputs, including that each invocation produces one result line and no incidental output.

Keep the implementation deterministic and compatible with the repository's pinned Pester 5.7.1 environment.

## Completion gates

- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero.
- The pinned pull-request workflow passes without changing its Pester version or bypassing the repository-owned runner.
- Unit assertions discriminate numeric return values from formatted CLI strings.
- Isolated CLI assertions compare complete stdout against exact strings such as `Fibonacci(0) = 0`, `Fibonacci(1) = 1`, and the selected representative case.
- Dot-sourcing `math-tool.ps1` produces no result line, while direct execution produces exactly one.
- Only `math-tool.ps1` and `math-tool.Tests.ps1` are changed for this task.

## Out of scope

- Do not implement factorial or operation dispatch; those belong to serial task 2.
- Do not modify the workflow, the repository-owned test runner, the pinned Pester version, the plan, or campaign metadata.
- Do not copy or adapt throwaway spike code or introduce unrelated tooling, dependencies, or refactors.
