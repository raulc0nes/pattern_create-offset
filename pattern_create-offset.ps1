[CmdletBinding()]
param(
    [ValidateSet("c", "s")]
    [string]$Mode,
    [int]$Length,
    [string]$SearchValue
)

# Mostrar ayuda si no se pasan argumentos
if (-not $Mode) {
    Write-Host "`nUso: .\pattern_create-offset.ps1 -Mode <c|s> -Length <longitud> [-SearchValue <cadena>]" -ForegroundColor Cyan
    Write-Host "`n  c -> Crea el patron de la longitud especificada."
    Write-Host "  s -> Busca una cadena de 4 caracteres en el patron."
    Write-Host "`nEjemplos:"
    Write-Host "  .\pattern_create-offset.ps1 -Mode c -Length 687492"
    Write-Host "  .\pattern_create-offset.ps1 -Mode s -SearchValue Aa0B`n"
    exit
}

# Generar caracteres desde hexadecimal
$set1 = @(0x61..0x7A | ForEach-Object { [char]$_ })  # a-z
$set2 = @(0x41..0x5A | ForEach-Object { [char]$_ })  # A-Z
$set3 = @(0x30..0x39 | ForEach-Object { [char]$_ })  # 0-9

# Calcular combinaciones unicas
$maxPatterns = $set1.Count * $set2.Count * $set3.Count * $set2.Count  # 175,760 combinaciones unicas
$maxLength = ($maxPatterns * 4) - 1  # 687492 caracteres

if ($Mode -eq "c") {
    if ($Length -le 0 -or $Length -gt $maxLength) {
        Write-Host "`nError: La longitud debe estar entre 1 y $maxLength caracteres reales." -ForegroundColor Red
        exit
    }

    # Generar patron sin repeticiones en tiempo real
    $pattern = New-Object System.Text.StringBuilder
    $counter = 0

    while ($pattern.Length -lt $Length) {
        $c1 = $set1[ ($counter / ($set2.Count * $set3.Count * $set2.Count)) % $set1.Count ]
        $c2 = $set2[ ($counter / ($set3.Count * $set2.Count)) % $set2.Count ]
        $c3 = $set3[ ($counter / $set2.Count) % $set3.Count ]
        $c4 = $set2[ $counter % $set2.Count ]

        [void]$pattern.Append("$c1$c2$c3$c4")
        $counter++

        # Si llegamos al maximo de combinaciones unicas, romper el bucle
        if ($counter -ge $maxPatterns) { break }
    }

    # Asegurar que la longitud final sea la esperada sin linea en blanco
    if ($pattern.Length -gt $Length) {
        $pattern = $pattern.ToString().Substring(0, $Length)
    } else {
        $pattern = $pattern.ToString()
    }

    # Eliminar posible salto de linea al final
    $pattern = $pattern.TrimEnd()

    # Guardar como UTF-8 y convertir a ANSI con cmd.exe
    $OutputFile = "$PWD\pattern.txt"
    $TempFile = "$OutputFile.tmp"

    try {
        $pattern | Out-File -FilePath $TempFile -Encoding UTF8 -NoNewline
        cmd /c "type `"$TempFile`" > `"$OutputFile`" && del `"$TempFile`""

        # Verificar que el archivo se haya escrito correctamente
        if (-not (Test-Path $OutputFile) -or (Get-Item $OutputFile).Length -eq 0) {
            throw "El archivo no se genero correctamente."
        }

        Write-Host "`nPatron generado y guardado en $OutputFile" -ForegroundColor Green
    }
    catch {
        Write-Host "`nError al guardar en $OutputFile, intentando en C:\Users\Public\pattern.txt" -ForegroundColor Yellow
        $TempFile = "C:\Users\Public\pattern.txt.tmp"
        $FinalFile = "C:\Users\Public\pattern.txt"
        
        $pattern | Out-File -FilePath $TempFile -Encoding UTF8 -NoNewline
        cmd /c "type `"$TempFile`" > `"$FinalFile`" && del `"$TempFile`""

        Write-Host "`nPatron guardado en C:\Users\Public\pattern.txt" -ForegroundColor Green
    }
    exit
}

# Busqueda en el patron generado
if ($Mode -eq "s") {
    if (-not $SearchValue -or $SearchValue.Length -ne 4) {
        Write-Host "`nError: Debes ingresar una secuencia de exactamente 4 caracteres." -ForegroundColor Red
        exit
    }

    $PatternFile = "$PWD\pattern.txt"

    if (-not (Test-Path $PatternFile)) {
        Write-Host "`nError: No se encontro el archivo pattern.txt. Genera el patron primero." -ForegroundColor Red
        exit
    }

    # Leer el archivo en ANSI puro
    $pattern = Get-Content -Path $PatternFile -Raw -Encoding Default
    $position = $pattern.IndexOf($SearchValue)

    if ($position -eq -1) {
        Write-Host "`nLa secuencia '$SearchValue' no fue encontrada en el patron." -ForegroundColor Yellow
    } else {
        Write-Host "`nLa secuencia '$SearchValue' se encuentra en la posicion: $position" -ForegroundColor Green
    }
}

