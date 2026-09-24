## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `1-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`
- `### 2. Add factorial and operation dispatch`

The resolved acceptance environment is the committed command `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The existing workflow `.github/workflows/shepherd-task-math-tool.yml` pins Pester 5.7.1 and invokes that runner; do not replace or bypass either contract.

The resolved observable contract is that direct CLI execution writes exactly one result line to stdout: either `Fibonacci(N) = value` or `Factorial(N) = value`. Functions return numeric values with no incidental output. Inputs are non-negative integers. Continue using the repository-root files `math-tool.ps1` and `math-tool.Tests.ps1`.

Research established no separate spike implementation to copy. The controlling findings are that factorial and Fibonacci must remain pure calculations, formatting belongs at the direct-execution boundary, operation dispatch must preserve the already-merged Fibonacci interface and output, and the combined suite must continue through the repository-owned pinned-Pester runner.

## Branch and execution order

Use `experiment/shepherd-control` as the PR base branch. This is serial task 2 of 2 and depends on task 1 being merged into that branch. Tasks are assigned, completed, and merged in plan order. Do not start until this issue is assigned to the coding agent and task 1 is present on the base branch.

## Implement

Extend the existing repository-root `math-tool.ps1`:

- Add a pure `Get-Factorial` function that returns a numeric value and emits no incidental output.
- Add an `Operation` script parameter that dispatches between `fibonacci` and `factorial` while retaining the existing `N` parameter.
- Preserve task 1's Fibonacci calculation, dot-sourcing behavior, and exact direct-CLI output.
- Preserve the existing Fibonacci invocation when no operation is supplied; adding dispatch must not break callers established by task 1.
- For factorial direct execution, write exactly one stdout line formatted as `Factorial(N) = value`.
- Define factorial edge behavior correctly: `0! = 1` and `1! = 1`; later values multiply the positive integers through `N`.

Extend `math-tool.Tests.ps1` using the existing production-facing test structure. The plan intentionally leaves the exact test organization open, but the resulting suite must:

- Directly test the numeric return values of `Get-Factorial` for 0, 1, and at least one small representative value greater than 1.
- Exercise factorial operation dispatch in isolated child `pwsh` processes and compare complete stdout to the exact `Factorial(N) = value` contract.
- Retain the task 1 Fibonacci unit and isolated CLI tests as regression coverage.
- Exercise explicit Fibonacci dispatch as well as the existing no-operation Fibonacci invocation so dispatch cannot silently break either path.

Keep the implementation objective, small, deterministic, and compatible with Pester 5.7.1.

## Completion gates

- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite.
- The pinned pull-request workflow passes without changing its Pester version or bypassing the repository-owned runner.
- Factorial unit tests prove exact numeric results for 0, 1, and the selected representative value.
- Isolated CLI tests prove exact one-line stdout for factorial edge and representative inputs.
- Existing Fibonacci unit and CLI cases still pass unchanged; explicit Fibonacci dispatch produces the same formatted result as the preserved invocation without `Operation`.
- Dot-sourcing the script emits no result line for either function, and neither pure function emits formatted text.
- Changes remain limited to `math-tool.ps1` and `math-tool.Tests.ps1`.

## Out of scope

- Do not replace the task 1 implementation or weaken/delete its regression tests merely to add dispatch.
- Do not add operations beyond `fibonacci` and `factorial`, additional user interfaces, unrelated validation policy, or new dependencies.
- Do not modify the workflow, the repository-owned test runner, the pinned Pester version, the plan, or campaign metadata.
- Do not copy or adapt throwaway spike code or introduce unrelated refactors.
