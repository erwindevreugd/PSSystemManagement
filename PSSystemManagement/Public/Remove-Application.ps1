<#
.Synopsis
   Removes applications installed on the local computer or on a remote computer.
.DESCRIPTION
   The Remove-Application cmdlet removes applications installed on a local or remote computer.
.EXAMPLE
.INPUTS
.OUTPUTS
   
.NOTES
#>
function Remove-Application 
{
    [CmdletBinding()]
    param
    (
		# Id of the application to remove.
		# Use the Get-Application cmdlet to get the id of the installed application.
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true)]
        [string]$ID,

		# Removes the application installed on the specified computer. 
		# The default is the local computer (localhost).
        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName = 'localhost',

		# The credentials used to connect to the computer.
        [Parameter(
            Mandatory=$false)]
        [PSCredential]$Credential
    )

    process {
        
        $query = "SELECT * FROM Win32_Product WHERE __CLASS='Win32_Product'"

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
            $application = Get-WmiObject @parameters

            Write-Verbose -Message $("[{0}] Uninstalling '{1}'" -f $computer, $application.Name)

            try {
                $application.Uninstall()

                Write-Verbose -Message $("[{0}] Uninstalled '{1}'" -f $computer, $application.Name)
            } catch {
                Write-Warning -Message $("[{0}] Failed to uninstall '{1}'" -f $computer, $application.Name)
                throw $_
            }
        }
    }
}