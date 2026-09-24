[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int] $N = 0
)

Set-StrictMode -Version Latest

function Get-Fibonacci {
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

if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    "Fibonacci($N) = $value"
}
