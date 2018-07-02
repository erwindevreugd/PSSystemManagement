function Test-AdminPrivilege {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        Set-StrictMode -Version 'Latest'
    }
    
    process {
        $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()

        Write-Debug -Message "Checking if current user '$($identity.Name)' has administrative privileges."

        foreach($group in $identity.Groups)
        {
            if ($group.IsValidTargetType([System.Security.Principal.SecurityIdentifier]))
            {
                # $groupSid = $group.Translate([System.Security.Principal.SecurityIdentifier])
                $groupSid = $group
                if($groupSid.IsWellKnown([System.Security.Principal.WellKnownSidType]::AccountAdministratorSid) `
                    -or $groupSid.IsWellKnown([System.Security.Principal.WellKnownSidType]::BuiltinAdministratorsSid))
                {
                    return $true
                }
            }
        }
    
        return $false
    }
    
    end {
    }
}