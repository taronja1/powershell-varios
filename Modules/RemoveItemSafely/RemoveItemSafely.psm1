
function Remove-ItemSafely {
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [ValidatePattern('^[A-Z]:\\')]
        [string]$FullName
    )
    Begin {
        Add-Type -AssemblyName Microsoft.VisualBasic
    }
    Process {
        if (Test-Path -LiteralPath $FullName -PathType Leaf){
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($FullName, 'AllDialogs', 'SendToRecycleBin')
        } elseif (Test-Path -LiteralPath $FullName -PathType Container){
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($FullName, 'AllDialogs', 'SendToRecycleBin')
        } else {
            Write-Error "File not found: $FullName"
        }
    }
    #End {} # not necessary here
    # "AllDialogs" te avisa si al borrar no se manda a la papelera
}
