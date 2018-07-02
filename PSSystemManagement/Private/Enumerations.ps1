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


public enum DriveType : int
{
    Unknown = 0,
    NoRootDirectory = 1,
    RemovableDisk = 2,
    LogicalDisk = 3,
    NetworkDrive = 4,
    CompactDisk = 5,
    RAMDisk = 6
}
"@