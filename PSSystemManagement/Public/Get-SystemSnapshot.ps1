function Get-SystemSnapshot {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(
            Mandatory=$false
        )]
        [string]$ComputerName = "localhost",

        [Parameter(
            Mandatory=$false
        )]
        [PSCredential]$Credential,

        # Parameter help description
        [Parameter(
            Mandatory=$true
        )]
        [string]
        $Path
    )
    
    process {

        $parameters = @{
            ComputerName=$ComputerName;
        }

        if($Credential) {
            $parameters.Add('Credential',$Credential)
        }

        $date = [System.DateTime]::UtcNow.ToString("yyyyMMdd\THHmmss")

        Write-Verbose -Message "Starting system snapshot on '$($ComputerName)'"
        Write-Verbose -Message "Path format '${Path}\${ComputerName}_${Date}_[category].csv'"

        if(-not (Test-Path -PathType Container -Path $Path)) {
            Write-Verbose -Message "Creating folder '$Path'"
            New-Item -ItemType Directory -Path $Path | Out-Null
        }

        $system = Get-WmiObject @parameters -Class Win32_ComputerSystem | Export-Csv -Path "${Path}\${ComputerName}_${Date}_system.csv"
        $bios = Get-WmiObject @parameters -Class Win32_Bios | Export-Csv -Path "${Path}\${ComputerName}_${Date}_bios.csv"
        $processor = Get-WmiObject @parameters -Class Win32_Processor | Export-Csv -Path "${Path}\${ComputerName}_${Date}_processor.csv"
        $memory = Get-WmiObject @parameters -Class Win32_PhysicalMemory | Export-Csv -Path "${Path}\${ComputerName}_${Date}_memory.csv"
        $disk = Get-WmiObject @parameters -Class Win32_LogicalDisk | Export-Csv -Path "${Path}\${ComputerName}_${Date}_disk.csv"
        $networkConfiguration = Get-WmiObject @parameters -Class win32_NetworkAdapterConfiguration | Export-Csv -Path "${Path}\${ComputerName}_${Date}_network.csv"
        $services = Get-WmiObject @parameters -Class Win32_Service | Export-Csv -Path "${Path}\${ComputerName}_${Date}_service.csv"
        $processes = Get-WmiObject @parameters -Class Win32_Process | Export-Csv -Path "${Path}\${ComputerName}_${Date}_process.csv"
        $eventLog = Get-WmiObject @parameters -Class Win32_NTEventLogFile | Export-Csv -Path "${Path}\${ComputerName}_${Date}_logfile.csv"
        #$eventLog = Get-WmiObject @parameters -Class Win32_NTEventLogFile -Filter "LogfileName='Application' or LogfileName='System'"
    }
}