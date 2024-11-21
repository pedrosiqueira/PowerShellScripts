# URLs dos arquivos a serem baixados 
$filesToDownload = @{
    "launch.json" = "https://raw.githubusercontent.com/pedrosiqueira/dw4/refs/heads/main/.vscode/launch.json"
    "tasks.json"  = "https://raw.githubusercontent.com/pedrosiqueira/dw4/refs/heads/main/.vscode/tasks.json"
}

# Caminho base da pasta "Desktop\dw4\.vscode" de cada usuário
$basePath = "C:\Users"

# Percorre cada usuário em C:\Users\
Get-ChildItem -Path $basePath -Directory | ForEach-Object {
    $userName = $_.Name
    $userBasePath = "$($_.FullName)\Desktop\dw4"
    $vscodePath = Join-Path -Path $userBasePath -ChildPath ".vscode"
    $launchFilePath = Join-Path -Path $vscodePath -ChildPath "launch.json"
    $tasksFilePath = Join-Path -Path $vscodePath -ChildPath "tasks.json"
    $nodeModulesPath = "$($_.FullName)\Desktop\dw4\node_modules"
    $nodeModulesPath = "\\?\" + $nodeModulesPath # https://stackoverflow.com/a/25781964

    # Verifica se a pasta dw4 existe
    if (-not (Test-Path -Path $userBasePath)) {
        # Write-Output "Pasta dw4 não existe para o usuário $userName."
        return
    }

    # Garante que a pasta .vscode existe
    if (-not (Test-Path -Path $vscodePath)) {
        try {
            New-Item -ItemType Directory -Path $vscodePath -Force | Out-Null
            Write-Output "Pasta .vscode criada para o usuário $userName."
        }
        catch {
            Write-Output "Falha ao criar a pasta .vscode para o usuário ${userName}: $($_.Exception.Message)"
            return
        }
    }

    # Baixa o arquivo launch.json
    $launchUrl = $filesToDownload["launch.json"]
    try {
        Invoke-WebRequest -Uri $launchUrl -OutFile $launchFilePath -ErrorAction Stop
        Write-Output "Arquivo launch.json atualizado para o usuário $userName."
    }
    catch {
        Write-Output "Falha ao atualizar launch.json para o usuário ${userName}: $($_.Exception.Message)"
    }

    # Baixa o arquivo tasks.json
    $tasksUrl = $filesToDownload["tasks.json"]
    try {
        Invoke-WebRequest -Uri $tasksUrl -OutFile $tasksFilePath -ErrorAction Stop
        Write-Output "Arquivo tasks.json criado e baixado para o usuário $userName."
    }
    catch {
        Write-Output "Falha ao criar e baixar tasks.json para o usuário ${userName}: $($_.Exception.Message)"
    }

    # Verifica e exclui a pasta node_modules
    if (Test-Path -Path $nodeModulesPath) {
        try {
            Remove-Item -Path $nodeModulesPath -Recurse -Force
            Write-Output "Pasta node_modules excluída para o usuário $userName."
        }
        catch {
            Write-Output "Falha ao excluir node_modules para o usuário ${userName}: $($_.Exception.Message)"
        }
    }
    else {
        Write-Output "Pasta node_modules não encontrada para o usuário $userName."
    }
}
