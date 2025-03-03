
function Get-FFmpegAudioHash {
    param(
        [string]$Path = (Get-Location).Path,
        [switch]$Recurse = $false,
        [switch]$Raw = $false
    )
    $obj = Get-ChildItem -LiteralPath $Path -File -Recurse:$Recurse | ForEach-Object {
        [PSCustomObject]@{
            Hash     = ffmpeg -i "$($_.FullName)" -map 0:a -f hash -
            Name     = $_.Name
            FullName = $_.FullName
        }
    }
    function get-maxUIchars ([string]$text){
        # evita pasar de linea al mostrar caracteres full-width (ej. japoneses)
        $maxUIwidth = [math]::Max(20, (Get-Host).UI.RawUI.BufferSize.Width - 73) # 64 hash + 8 ffmpeg + 1 extra
        $length = 0
        $sb = [System.Text.StringBuilder]::new()
        for ($i = 0; $i -lt $text.Length; $i++) {
            if ($text[$i] -match '[\x20-\x7F]'){
                $length = $length + 1
            } else {
                $length = $length + 2
            }
            if ($length -le $maxUIwidth){
                [void]$sb.Append($text[$i])
            } else {
                break
            }
        }
        $sb.ToString()
    }
    $obj | Sort-Object Hash | Group-Object Hash | ForEach-Object {
        if ($_.Count -ge 2){
            $i++; if ($i % 2){ $color = 'Yellow' } else { $color = 'Cyan' }
            $_.Group | ForEach-Object {
                Write-Host ('{0} {1}' -f ($_.Hash), (get-maxUIchars $($_.Name))) -ForegroundColor $color
            }
        } else {
            Write-Host ('{0} {1}' -f ($_.Group.Hash), (get-maxUIchars $($_.Group.Name)))
        }
    }
    if ($Raw){
        $obj # output to be captured
    }
}
