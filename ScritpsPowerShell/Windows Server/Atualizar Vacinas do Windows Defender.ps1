## Atualizar Vacinas do Windows Defender
## Autor: Paulo Costa
# Define o nome do servidor

$servidor: env:computername

$ServerName = Read-Host "Digite o nome do servidor"
if ((Invoke-Command -ComputerName $ServerName -ScriptBlock {Get-MpPreference}).DisableRealtimeMonitoring -eq $false) {
    $UpdateStatus = (Invoke-Command -ComputerName $ServerName -ScriptBlock {Get-MpComputerStatus}).SignatureUpdateStatus
    if ($UpdateStatus -eq "UpToDate") {
        Write-Host "As definições de vírus do Windows Defender já estão atualizadas no servidor: $servidor"
    }
    elseif ($UpdateStatus -eq "InProgress") {
        Write-Host "A atualização das definições de vírus do Windows Defender já está em andamento no servidor: $servidor"
    }
    else {
        Write-Host "Atualizando as definições de vírus do Windows Defender... no servidor: $servidor"
        Invoke-Command -ComputerName $ServerName -ScriptBlock {Update-MpSignature}
        Write-Host "As definições de vírus do Windows Defender foram atualizadas com sucesso no servidor: $servidor"
    }
}
else {
    Write-Host "O Windows Defender está desabilitado no servidor: $servidor"
}
