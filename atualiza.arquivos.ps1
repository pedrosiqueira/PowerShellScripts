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

    # Baixa e substitui os arquivos especificados
    foreach ($file in $filesToDownload.Keys) {
        $filePath = Join-Path -Path $userBasePath -ChildPath $file
        $url = $filesToDownload[$file]
        
        # Verifica se o arquivo existe
        if (Test-Path $filePath) {
            try {
                Invoke-WebRequest -Uri $url -OutFile $filePath -ErrorAction Stop
                Write-Output "Arquivo $file atualizado para o usuário $userName"
            }
            catch {
                Write-Output "Falha ao atualizar $file para o usuário ${userName}: $($_.Exception.Message)"
            }
        } else {
            Write-Output "Arquivo $file não encontrado para o usuário $userName"
        }
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
        Write-Output "Pasta node_modules não encontrada para o usuário $userName"
    }
}
