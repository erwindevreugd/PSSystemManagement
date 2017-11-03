<#
.Synopsis
   Gets the applications installed on the local computer or on a remote computer.
.DESCRIPTION
   The Get-Application cmdlet gets the applications installed on a local or remote computer.
    
    Without parameters, Get-Application gets all of the applications installed on the local computer. 
	You can also specify a application by name, part of the name or application id.
.EXAMPLE
.INPUTS
   None.
.OUTPUTS
   
.NOTES
#>
function Get-Application 
{
    [CmdletBinding()]
    param
    (
		# Either the full name or part of the application name.
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true)]
        [string]$Name,

		# The id of the application.
        [Parameter(
            Position=1, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true)]
        [string]$ID,

		# The installation state of the application.
        [Parameter(
            Mandatory=$false)]
        [InstallState]$InstallState,

		# Gets the applications installed on the specified computers. 
		# The default is the local computer (localhost).
        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName = 'localhost',

		# The credentials used to connect to the computers.
        [Parameter(
            Mandatory=$false)]
        [PSCredential]$Credential
    )

    process {
        
        $query = "SELECT * FROM Win32_Product WHERE __CLASS='Win32_Product'"

        if($InstallState) {
            $query += " AND InstallState='$($InstallState -as [int])'"
        }

        if($Name) {
            $query += " AND Name LIKE '%$Name%'"
        }

        if($ID) {
            $query += " AND IdentifyingNumber='$ID'"
        }

        $parameters = @{
            ComputerName=$ComputerName;
            Query=$query;
        }

        if($Credential) {
            $parameters.Add('Credential',$Credential)
        }

        foreach($computer in $ComputerName) {
            if((Test-Connection -ComputerName $computer -Count 1 -Quiet) -eq $false) {
                Write-Warning -Message "[$computer] Did not respond to ping request"
            }
        }

        Write-Verbose -Message $($query)

        Get-WmiObject @parameters | 
        Select-Object -Property @{L='ID';E={ $_.IdentifyingNumber} },Name,Version,@{L='ComputerName';E={ $_.__SERVER} } | 
        Sort-Object -Property Name
    }
}