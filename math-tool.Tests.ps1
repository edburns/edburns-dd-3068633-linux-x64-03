BeforeAll {
    $script:MathToolPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    $script:PowerShellPath = (Get-Command pwsh -ErrorAction Stop).Source
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

    It 'returns the exact BigInteger value for N=100' {
        Get-Fibonacci -N 100 | Should -Be ([System.Numerics.BigInteger]::Parse('354224848179261915075'))
    }

    It 'accepts non-negative integers above the old arbitrary limit' {
        Get-Fibonacci -N 10001 | Should -BeOfType ([System.Numerics.BigInteger])
    }

    It 'rejects negative N' {
        { Get-Fibonacci -N -1 } | Should -Throw
    }

}

Describe 'Get-Factorial' {
    It 'returns 1 for N=0' {
        Get-Factorial -N 0 | Should -Be 1
    }

    It 'returns 1 for N=1' {
        Get-Factorial -N 1 | Should -Be 1
    }

    It 'returns 120 for N=5' {
        Get-Factorial -N 5 | Should -Be 120
    }

    It 'returns the exact BigInteger value for N=25' {
        Get-Factorial -N 25 | Should -Be ([System.Numerics.BigInteger]::Parse('15511210043330985984000000'))
        Get-Factorial -N 25 | Should -BeOfType ([System.Numerics.BigInteger])
    }

    It 'rejects negative N' {
        { Get-Factorial -N -1 } | Should -Throw
    }
}

Describe 'math-tool loading' {
    It 'does not write a result line when dot-sourced' {
        $env:MATH_TOOL_TEST_PATH = $script:MathToolPath
        try {
            $global:LASTEXITCODE = $null
            $output = @(& $script:PowerShellPath -NoLogo -NoProfile -Command '. "$env:MATH_TOOL_TEST_PATH"')
        }
        finally {
            Remove-Item Env:\MATH_TOOL_TEST_PATH -ErrorAction SilentlyContinue
        }

        $LASTEXITCODE | Should -Be 0
        $output.Count | Should -Be 0
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

        $global:LASTEXITCODE = $null
        $output = @(& $script:PowerShellPath -NoLogo -NoProfile -File $script:MathToolPath -N $N)

        $LASTEXITCODE | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly $Expected
    }

    It 'writes exactly one result line for -Operation <Operation> -N <N>' -TestCases @(
        @{ Operation = 'fibonacci'; N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ Operation = 'fibonacci'; N = 1; Expected = 'Fibonacci(1) = 1' }
        @{ Operation = 'fibonacci'; N = 5; Expected = 'Fibonacci(5) = 5' }
        @{ Operation = 'factorial'; N = 0; Expected = 'Factorial(0) = 1' }
        @{ Operation = 'factorial'; N = 1; Expected = 'Factorial(1) = 1' }
        @{ Operation = 'factorial'; N = 5; Expected = 'Factorial(5) = 120' }
    ) {
        param(
            [string] $Operation,
            [int] $N,
            [string] $Expected
        )

        $global:LASTEXITCODE = $null
        $output = @(& $script:PowerShellPath -NoLogo -NoProfile -File $script:MathToolPath -N $N -Operation $Operation)

        $LASTEXITCODE | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly $Expected
    }

    It 'produces the same Fibonacci line with and without explicit dispatch' {
        $global:LASTEXITCODE = $null
        $implicit = @(& $script:PowerShellPath -NoLogo -NoProfile -File $script:MathToolPath -N 7)
        $LASTEXITCODE | Should -Be 0

        $global:LASTEXITCODE = $null
        $explicit = @(& $script:PowerShellPath -NoLogo -NoProfile -File $script:MathToolPath -N 7 -Operation fibonacci)
        $LASTEXITCODE | Should -Be 0

        $implicit.Count | Should -Be 1
        $explicit.Count | Should -Be 1
        $explicit[0] | Should -BeExactly $implicit[0]
    }
}
