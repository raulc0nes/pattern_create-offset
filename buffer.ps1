param (
    [int]$longitud,
    [string]$letra
)

if ($longitud -le 0) {
    Write-Host "El primer argumento debe ser un numero mayor que 0."
    exit 1
}

if ($letra.Length -ne 1) {
    Write-Host "El segundo argumento debe ser una sola letra."
    exit 1
}

$stringGenerado = $letra * $longitud
Write-Output $stringGenerado

