function Start-RDP {
    [CmdletBinding()]
    param (

        [Parameter(
            Position=0,
            Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(
            Mandatory=$false)]
            [ValidateRange(1,65535)]
        [int]$Port = 3389,

        [Parameter(
            Mandatory=$false)]
        [switch]$Admin,

        [Parameter(
            Mandatory=$false)]
        [switch]$MultiMonitor,

        [Parameter(
            Mandatory=$false)]
        [switch]$Public,

        [Parameter(
            Mandatory=$false)]
        [switch]$FullScreen,

        [Parameter(
            Mandatory=$false)]
        [int]$SessionId = $null
    )
    
    process {
        Set-StrictMode -Version "Latest"

        $args = New-Object -TypeName System.Collections.ArrayList
        $mstsc = (Join-Path $env:WinDir system32\mstsc.exe -Resolve)

        if(-not $mstsc) {
            throw "mstsc not found"
        }

        [void]$args.Add("/v:$ComputerName" + $(if($Port -ne 3389) { ":$Port" }))

        if($Admin) {
            [void]$args.Add("/admin")
        }

        if($Admin) {
            [void]$args.Add("/multimon")
        }

        if($Public) {
            [void]$args.Add("/public")
        }

        if($FullScreen) {
            [void]$args.Add("/f")
        }

        if($SessionId) {
            [void]$args.Add("/shadow:$SessionId")
        }

        Start-Process $mstsc -ArgumentList ($args)
    }
}