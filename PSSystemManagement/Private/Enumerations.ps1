Add-Type -TypeDefinition @"
public enum InstallState : int
{
    BadConfiguration = -6,
    InvalidArgument = -2,
    UnknownPackage = -1,
    Advertised = 1,
    Absent = 2,
    Installed = 5
}
"@