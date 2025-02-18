
function Get-Hz {
    param(
        [switch]$Verbose
    )
    $devices = Get-CimInstance Win32_VideoController | ForEach-Object {
        [PSCustomObject]@{
            DeviceID             = $_.DeviceID
            Name                 = $_.Name
            Availability         = switch ($_.Availability){
                { $_ -eq '3' } { '3 - RUNNING'; break }
                { $_ -eq '8' } { '8 - OFFLINE'; break }
                default { "$_ - IDK check docs" }
            }
            HorizontalResolution = $_.CurrentHorizontalResolution
            VerticalResolution   = $_.CurrentVerticalResolution
            RefreshRate          = $_.CurrentRefreshRate
        }
    }
    if ($Verbose){
        $devices
    } else {
        $devices | Where-Object { $_.Availability -eq '3 - RUNNING' } | ForEach-Object {
            '{0}x{1} @ {2}Hz' -f $_.HorizontalResolution, $_.VerticalResolution, $_.RefreshRate
        }
    }
}
