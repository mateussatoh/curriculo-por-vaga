# Gera o PDF de um curriculo .tex no Windows (o PDF fica ao lado do .tex).
# Uso: .\build.ps1 vagas\<empresa-cargo>\cv.br.tex
#      (ou build.cmd vagas\<empresa-cargo>\cv.br.tex, que dispensa liberar scripts)
param([Parameter(Mandatory = $true)][string]$Arquivo)
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $Arquivo)) { Write-Host "arquivo nao encontrado: $Arquivo"; exit 1 }
if (-not (Get-Command pdflatex -ErrorAction SilentlyContinue)) {
    Write-Host "pdflatex nao encontrado. Instale o MiKTeX:"
    Write-Host "  winget install MiKTeX.MiKTeX"
    Write-Host "Depois feche e abra o terminal de novo. Veja o README (secao Windows)."
    exit 1
}

$src  = (Resolve-Path $Arquivo).Path
$dir  = Split-Path $src -Parent
$name = [IO.Path]::GetFileNameWithoutExtension($src)
$aux  = Join-Path $dir '.aux-build'
New-Item -ItemType Directory -Force -Path $aux | Out-Null

# Deixa o preamble.tex visivel a partir de qualquer pasta de vaga.
$env:TEXINPUTS = (Join-Path $PSScriptRoot 'base') + ";$dir;" + $env:TEXINPUTS

# lastpage precisa de duas passadas para o "Pagina X de Y".
foreach ($pass in 1, 2) {
    & pdflatex -interaction=nonstopmode -halt-on-error -output-directory "$aux" "$src" | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "pdflatex falhou (passada $pass). Final do log:"
        Get-Content (Join-Path $aux "$name.log") -Tail 30
        Write-Host ""
        Write-Host "Se o erro fala de pacote faltando (.sty not found), rode uma vez:"
        Write-Host "  initexmf --set-config-value=[MPM]AutoInstall=1"
        exit 1
    }
}

$pdf = Join-Path $dir "$name.pdf"
Move-Item -Force (Join-Path $aux "$name.pdf") $pdf
$m = Select-String -Path (Join-Path $aux "$name.log") -Pattern '\((\d+) pages?,' | Select-Object -Last 1
$pages = if ($m) { " ($($m.Matches[0].Groups[1].Value) pagina(s))" } else { '' }
Write-Host "pronto: $pdf$pages"
