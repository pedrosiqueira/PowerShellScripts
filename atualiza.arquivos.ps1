# URLs dos arquivos a serem baixados 
$filesToDownload = @{
    "launch.json" = "https://raw.githubusercontent.com/pedrosiqueira/dw4/refs/heads/main/.vscode/launch.json"
    "tasks.json" = "https://raw.githubusercontent.com/pedrosiqueira/dw4/refs/heads/main/.vscode/tasks.json"
}

# Caminho base da pasta "Desktop\dw4\.vscode" de cada usuário
$basePath = "C:\Users"

# Percorre cada usuário em C:\Users\
Get-ChildItem -Path $basePath | ForEach-Object {
    $userName = $_.Name
    $userBasePath = "$($_.FullName)\Desktop\dw4\.vscode"
    $nodeModulesPath = "$($_.FullName)\Desktop\dw4\node_modules"

    # Verifica se o arquivo launch.json existe
    $launchFilePath = Join-Path -Path $userBasePath -ChildPath "launch.json"
    
    if (Test-Path $launchFilePath) {
        # Se launch.json existe, tenta baixar e atualizar ambos os arquivos (launch.json e tasks.json)
        
        # Baixa e substitui o arquivo launch.json
        $launchUrl = $filesToDownload["launch.json"]
        try {
            Invoke-WebRequest -Uri $launchUrl -OutFile $launchFilePath -ErrorAction Stop
            Write-Output "Arquivo launch.json atualizado para o usuário $userName"
        }
        catch {
            Write-Output "Falha ao atualizar launch.json para o usuário ${userName}: $($_.Exception.Message)"
        }

        # Verifica se tasks.json já existe, caso contrário, cria e baixa
        $tasksFilePath = Join-Path -Path $userBasePath -ChildPath "tasks.json"
        if (-not (Test-Path $tasksFilePath)) {
            $tasksUrl = $filesToDownload["tasks.json"]
            try {
                Invoke-WebRequest -Uri $tasksUrl -OutFile $tasksFilePath -ErrorAction Stop
                Write-Output "Arquivo tasks.json criado e baixado para o usuário $userName"
            }
            catch {
                Write-Output "Falha ao criar e baixar tasks.json para o usuário ${userName}: $($_.Exception.Message)"
            }
        } else {
            Write-Output "Arquivo tasks.json já existe para o usuário $userName"
        }
    } else {
        # Write-Output "Arquivo launch.json não encontrado para o usuário $userName. Não será baixado tasks.json."
    }

    # Verifica e exclui a pasta node_modules
    if (Test-Path $nodeModulesPath) {
        try {
            Remove-Item -Path $nodeModulesPath -Recurse -Force
            Write-Output "Pasta node_modules excluída para o usuário $userName"
        }
        catch {
            Write-Output "Falha ao excluir node_modules para o usuário ${userName}: $($_.Exception.Message)"
        }
    } else {
        # Write-Output "Pasta node_modules não encontrada para o usuário $userName"
    }
}
