[CmdletBinding()]
param(
    [int] $N = 0
)

$script:MaximumFibonacciN = 10000

function Get-Fibonacci {
    <#
    .SYNOPSIS
    Returns the Fibonacci number for a non-negative integer.

    .PARAMETER N
    The non-negative integer position in the Fibonacci sequence, up to the configured maximum.

    .OUTPUTS
    System.Numerics.BigInteger
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({
            if ($_ -lt 0 -or $_ -gt $script:MaximumFibonacciN) {
                throw "N must be between 0 and $script:MaximumFibonacciN."
            }
            $true
        })]
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
