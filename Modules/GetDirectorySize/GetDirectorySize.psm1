
function Get-DirectorySize {
    param(
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$dir = (Get-Location).Path
    )

    $psobj1 = [System.Collections.Generic.List[object]]::new()
    # -LiteralPath para que acepte nombres con [] y otros caracteres especiales
    Get-ChildItem -LiteralPath $dir -Directory | ForEach-Object {
        $psobj1.Add([PSCustomObject]@{
                Name = $_.name
                Size = [int64]((Get-ChildItem -LiteralPath $_.FullName -Recurse | Measure-Object -Property length -Sum -EA Ignore).Sum)
            })
    }
    $psobj1.Add([PSCustomObject]@{
            Name = '*** FILES ***' # '*' no se puede usar en nombres de carpetas
            Size = [int64]((Get-ChildItem -LiteralPath $dir -File | Measure-Object -Property length -Sum -EA Ignore).Sum)
        })

    $psobj1 | Sort-Object -Property Size -Descending | ForEach-Object {
        [PSCustomObject]@{
            Size         = $_.Size
            Name         = $_.Name
            ReadableSize = switch ($_.Size){
                { $_ -gt 1TB } {
                    [string]::Format('{0:0.00} TB', $_ / 1TB); break
                }
                { $_ -gt 1GB } {
                    [string]::Format('{0:0.00} GB', $_ / 1GB); break
                }
                { $_ -gt 1MB } {
                    [string]::Format('{0:0.00} MB', $_ / 1MB); break
                }
                { $_ -gt 1KB } {
                    [string]::Format('{0:0.00} KB', $_ / 1KB); break
                }
                default {
                    [string]::Format('{0} B', $_)
                }
            }
        }
    }
}
