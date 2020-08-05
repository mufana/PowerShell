function Get-ExceptionType {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Exception]
        $Exception
    )

    $ex = $Exception.GetType().FullName
    Write-Output "Exception of type: '$ex'"
}
