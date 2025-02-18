
function Sort-AsExplorer {
    <#
.SYNOPSIS
    This function sorts like windows explorer.
    Accepts -Descending switch.
#>
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        $stuff,
        [Parameter()]
        [switch]$Descending
    )
    # Begin, Process & End blocks are required to be able to pipe correctly
    Begin {
        $stuffToSort = [System.Collections.Generic.List[object]]::new()
    }
    Process {
        $stuffToSort.Add($stuff)
    }
    End {
        if (-not($stuffToSort)){
            $stuffToSort = Get-ChildItem -File
        }
        $sortPaddedInt = { [regex]::Replace($PSItem, '\d+', { $args[0].Value.Padleft(20) }) }
        $sorted = $stuffToSort | Sort-Object $sortPaddedInt
        if ($Descending){
            [array]::Reverse($sorted)
        }
        return $sorted
    }
}
