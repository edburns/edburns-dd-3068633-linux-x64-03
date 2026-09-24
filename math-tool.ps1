[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int] $N = 0,

    [ValidateSet('fibonacci', 'factorial')]
    [string] $Operation = 'fibonacci'
)

function Get-Fibonacci {
    <#
    .SYNOPSIS
    Returns the Fibonacci number for a non-negative integer.

    .PARAMETER N
    The non-negative integer position in the Fibonacci sequence.

    .OUTPUTS
    System.Numerics.BigInteger
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $N
    )

    if ($N -lt 2) {
        return [System.Numerics.BigInteger] $N
    }

    [System.Numerics.BigInteger] $previous = 0
    [System.Numerics.BigInteger] $current = 1

    for ($i = 2; $i -le $N; $i++) {
        [System.Numerics.BigInteger] $next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $current
}

function Get-Factorial {
    <#
    .SYNOPSIS
    Returns the factorial of a non-negative integer.

    .PARAMETER N
    The non-negative integer to take the factorial of.

    .OUTPUTS
    System.Numerics.BigInteger
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $N
    )

    [System.Numerics.BigInteger] $product = 1

    for ($i = 2; $i -le $N; $i++) {
        $product = $product * $i
    }

    return $product
}

# Dot-sourced tests load the function without running the CLI output path.
$isDotSourced = $MyInvocation.InvocationName -eq '.'
if (-not $isDotSourced) {
    switch ($Operation) {
        'factorial' {
            $value = Get-Factorial -N $N
            "Factorial($N) = $value"
        }
        'fibonacci' {
            $value = Get-Fibonacci -N $N
            "Fibonacci($N) = $value"
        }
        default {
            # Unreachable while ValidateSet guards $Operation; guards future additions.
            throw "Unsupported operation '$Operation'."
        }
    }
}
