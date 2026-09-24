[CmdletBinding()]
param(
    [ValidateRange(0, 10000)]
    [int] $N = 0
)

function Get-Fibonacci {
    <#
    .SYNOPSIS
    Returns the Fibonacci number for a non-negative integer.

    .PARAMETER N
    The non-negative integer position in the Fibonacci sequence, up to 10000.

    .OUTPUTS
    System.Numerics.BigInteger
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, 10000)]
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

# Dot-sourced tests load the function without running the CLI output path.
$isDotSourced = $MyInvocation.InvocationName -eq '.' -or $MyInvocation.Line -match '^\s*\.\s'
if (-not $isDotSourced) {
    $value = Get-Fibonacci -N $N
    "Fibonacci($N) = $value"
}
