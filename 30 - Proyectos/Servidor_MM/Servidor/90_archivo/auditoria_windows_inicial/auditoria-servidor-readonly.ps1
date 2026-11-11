#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [string]$OutputPath = "$PSScriptRoot\auditoria-servidor.json"
)

$ErrorActionPreference = 'SilentlyContinue'

function Get-Safe {
    param([scriptblock]$Script)
    try { & $Script } catch { $null }
}

$os = Get-Safe { Get-CimInstance Win32_OperatingSystem }
$cs = Get-Safe { Get-CimInstance Win32_ComputerSystem }
$bios = Get-Safe { Get-CimInstance Win32_BIOS }
$tpm = Get-Safe { Get-Tpm }
$secureBoot = Get-Safe { Confirm-SecureBootUEFI }
$adminGroup = Get-Safe { Get-LocalGroup | Where-Object SID -eq 'S-1-5-32-544' | Select-Object -First 1 }
$ipConfiguration = @(Get-Safe {
    Get-NetIPConfiguration | Where-Object IPv4Address | ForEach-Object {
        $profile = Get-NetConnectionProfile -InterfaceIndex $_.InterfaceIndex -ErrorAction SilentlyContinue
        [pscustomobject]@{
            InterfaceAlias = $_.InterfaceAlias
            NetworkCategory = $profile.NetworkCategory
            IPv4Address = ($_.IPv4Address.IPAddress -join ',')
            PrefixLength = ($_.IPv4Address.PrefixLength -join ',')
            IPv4DefaultGateway = ($_.IPv4DefaultGateway.NextHop -join ',')
            DNSServer = ($_.DNSServer.ServerAddresses -join ',')
        }
    }
})

$result = [ordered]@{
    CollectedAt = (Get-Date).ToString('o')
    Host = [ordered]@{
        ComputerName = $env:COMPUTERNAME
        User = ($env:USERDOMAIN + '\\' + $env:USERNAME)
        Manufacturer = $cs.Manufacturer
        Model = $cs.Model
        TotalMemoryGB = $(if ($cs.TotalPhysicalMemory) { [math]::Round($cs.TotalPhysicalMemory / 1GB, 1) })
        Domain = $cs.Domain
        PartOfDomain = $cs.PartOfDomain
        HypervisorPresent = $cs.HypervisorPresent
        BiosFirmwareType = (Get-Safe { (Get-ComputerInfo).BiosFirmwareType })
        BiosVersion = $bios.SMBIOSBIOSVersion
        TpmPresent = $tpm.TpmPresent
        TpmReady = $tpm.TpmReady
        SecureBootEnabled = $secureBoot
    }
    OperatingSystem = [ordered]@{
        Caption = $os.Caption
        Version = $os.Version
        Build = $os.BuildNumber
        InstallDate = $os.InstallDate
        LastBoot = $os.LastBootUpTime
    }
    Processor = @(Get-Safe { Get-CimInstance Win32_Processor | Select-Object -First 1 Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed })
    Volumes = @(Get-Safe { Get-Volume | Where-Object DriveLetter | Select-Object DriveLetter,FileSystemLabel,FileSystem,HealthStatus,@{n='SizeGB';e={[math]::Round($_.Size/1GB,1)}},@{n='FreeGB';e={[math]::Round($_.SizeRemaining/1GB,1)}} })
    PhysicalDisks = @(Get-Safe { Get-PhysicalDisk | Select-Object FriendlyName,MediaType,HealthStatus,OperationalStatus,@{n='SizeGB';e={[math]::Round($_.Size/1GB,1)}},BusType })
    Network = [ordered]@{
        Adapters = @(Get-Safe { Get-NetAdapter | Select-Object Name,InterfaceDescription,Status,LinkSpeed,MacAddress })
        IPConfiguration = $ipConfiguration
        Routes = @(Get-Safe { Get-NetRoute -AddressFamily IPv4 | Where-Object RouteMetric -ne $null | Select-Object ifIndex,DestinationPrefix,NextHop,RouteMetric,InterfaceAlias })
    }
    Firewall = @(Get-Safe { Get-NetFirewallProfile | Select-Object Name,Enabled,DefaultInboundAction,DefaultOutboundAction })
    Defender = Get-Safe { Get-MpComputerStatus | Select-Object AMServiceEnabled,AntivirusEnabled,AntispywareEnabled,RealTimeProtectionEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,NISEnabled,IsTamperProtected,QuickScanAge,FullScanAge }
    BitLocker = @(Get-Safe { Get-BitLockerVolume | Select-Object MountPoint,VolumeType,VolumeStatus,ProtectionStatus,EncryptionMethod,KeyProtector })
    Accounts = [ordered]@{
        LocalUsers = @(Get-Safe { Get-LocalUser | Select-Object Name,Enabled,LastLogon,PasswordRequired,UserMayChangePassword })
        LocalAdministrators = @(Get-Safe { if ($adminGroup) { Get-LocalGroupMember -Group $adminGroup.Name | Select-Object Name,ObjectClass,PrincipalSource } })
    }
    Services = @(Get-Safe { Get-Service | Where-Object Status -eq Running | Select-Object Name,DisplayName,Status,StartType })
    ScheduledTasks = @(Get-Safe { Get-ScheduledTask | Where-Object State -eq Running | Select-Object TaskName,TaskPath,State })
    ListeningTCP = @(Get-Safe {
        Get-NetTCPConnection -State Listen | ForEach-Object {
            $p = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
            [pscustomobject]@{ LocalAddress=$_.LocalAddress; LocalPort=$_.LocalPort; ProcessId=$_.OwningProcess; ProcessName=$p.ProcessName }
        } | Sort-Object LocalPort
    })
    SMB = [ordered]@{
        Shares = @(Get-Safe { Get-SmbShare | Select-Object Name,Path,Description,EncryptData,FolderEnumerationMode })
        ServerConfiguration = Get-Safe { Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol,EnableSMB2Protocol,RequireSecuritySignature,EnableSecuritySignature,EncryptData }
    }
    HotFixes = @(Get-Safe { Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 20 HotFixID,InstalledOn,Description })
    OptionalFeatures = @(Get-Safe { Get-WindowsOptionalFeature -Online | Where-Object State -eq Enabled | Select-Object FeatureName,State })
}

$json = $result | ConvertTo-Json -Depth 7
$json | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Output "Informe creado en: $OutputPath"
