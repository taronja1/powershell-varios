
function Set-CPUPriority {
    # RealTime y Idle no, muy peligrosos sin saber el proceso de antemano
    [System.Diagnostics.ProcessPriorityClass]$priority = ('High', 'AboveNormal', 'Normal', 'BelowNormal') | Out-GridView -OutputMode Single
    # si tiene nombre de ventana en UI, o más de 10s de uso de CPU, o más de 100MB de RAM (no mide igual que task manager)
    $process = Get-Process | Where-Object{ $_.MainWindowTitle -or $_.CPU -gt 10 -or $_.WorkingSet64 -gt 100MB } | Select-Object Id, ProcessName, MainWindowTitle, CPU, WorkingSet64, PriorityClass | Out-GridView -OutputMode Multiple
    $process | ForEach-Object {
        Write-Host ('{0} ({1}): {2} -> {3}' -f @($_.ProcessName, $_.Id, $_.PriorityClass, $priority))
        (Get-Process -Id $_.Id).PriorityClass = $priority
    }
}
