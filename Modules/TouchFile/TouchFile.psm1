
function Touch-File {
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$file
    )
    if (Test-Path $file){
        (Get-Item $file).LastWriteTime = (Get-Date)
    } else {
        New-Item $file -ItemType File | Out-Null
    }
}
