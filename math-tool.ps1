[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int] $N = 0
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

    Set-StrictMode -Version Latest

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
if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    "Fibonacci($N) = $value"
}
