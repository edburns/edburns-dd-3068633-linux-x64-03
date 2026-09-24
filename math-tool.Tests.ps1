BeforeAll {
    $script:MathToolPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $script:MathToolPath
}

Describe 'Get-Fibonacci' {
    It 'returns 0 for N=0' {
        Get-Fibonacci -N 0 | Should -Be 0
    }

    It 'returns 1 for N=1' {
        Get-Fibonacci -N 1 | Should -Be 1
    }

    It 'returns 5 for N=5' {
        Get-Fibonacci -N 5 | Should -Be 5
    }
}

Describe 'math-tool loading' {
    It 'does not write a result line when dot-sourced' {
        $output = @(& pwsh -NoLogo -NoProfile -Command ". '$script:MathToolPath'")

        $LASTEXITCODE | Should -Be 0
        $output | Should -HaveCount 0
    }
}

Describe 'math-tool CLI' {
    It 'writes exactly one result line for N=<N>' -TestCases @(
        @{ N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ N = 1; Expected = 'Fibonacci(1) = 1' }
        @{ N = 5; Expected = 'Fibonacci(5) = 5' }
    ) {
        param(
            [int] $N,
            [string] $Expected
        )

        $output = @(& pwsh -NoLogo -NoProfile -File $script:MathToolPath -N $N)

        $LASTEXITCODE | Should -Be 0
        $output | Should -HaveCount 1
        $output[0] | Should -BeExactly $Expected
    }
}
