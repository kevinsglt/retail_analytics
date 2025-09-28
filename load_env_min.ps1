# load_env_min.ps1
param([switch]$UseLocalProfilesYml, [string]$EnvFile = ".env")

if (-not (Test-Path $EnvFile)) { throw "Fichier $EnvFile introuvable." }

Get-Content $EnvFile | ForEach-Object {
  $line = $_.Trim()
  if (-not $line) { return }
  if ($line.StartsWith('#')) { return }
  $eq = $line.IndexOf('=')
  if ($eq -lt 1) { return }

  $k = $line.Substring(0, $eq).Trim()
  $v = $line.Substring($eq + 1).Trim()

  # Retire des guillemets éventuels autour de la valeur
  if (($v.StartsWith('"') -and $v.EndsWith('"')) -or
      ($v.StartsWith("'") -and $v.EndsWith("'"))) {
    $v = $v.Substring(1, $v.Length - 2)
  }

  [Environment]::SetEnvironmentVariable($k, $v, 'Process')
}

if ($UseLocalProfilesYml) {
  [Environment]::SetEnvironmentVariable("DBT_PROFILES_DIR", (Get-Location).Path, 'Process')
}

Write-Host "Env charge. DBT_HOST=$($env:DBT_HOST)"
