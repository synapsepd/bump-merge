
# Copy the merge driver scripts into ProgramData
$dest = $Env:ProgramData + "\Synapse\bump-merge"
New-Item -ItemType Directory -Force -Path $dest
$sourcedir = Split-Path -Path $MyInvocation.MyCommand.Path
$sourcepath = $sourcedir + "\bump_merge.sh"
Copy-Item -Force $sourcepath -Destination "$dest"
$sourcepath = $sourcedir + "\bump_merge_lfs.sh"
Copy-Item -Force $sourcepath -Destination "$dest"

# Add the merge driver location to the system path
$oldpath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).path
if ( $oldpath.ToLower().Split(";") -notcontains $dest.ToLower() ) { 
    if ( $oldpath.Substring($oldpath.Length-1) -ne ";") {
        $oldpath = "$oldpath;"
        }
    $newpath = "$oldpath$dest;"
    #Write-Host $newpath     
    Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $newpath
    }

# Set the global .gitconfig for the bump-merge drivers
git config --global merge.bump.name "Bump local copy to local_version folder, keep server copy"
git config --global merge.bump.driver "bump_merge.sh %O %A %B"
    
git config --global merge.bump-lfs.name "Bump local copy to local_version folder, keep server copy (LFS)"
git config --global merge.bump-lfs.driver "bump_merge_lfs.sh %O %A %B"

# The section below was lifted from:
# https://mnaoumov.wordpress.com/2012/07/24/powershell-add-directory-to-environment-path-variable/
# This section sends the WM_SETTINGCHANGE message to all windows to avoid requiring a restart
# for the new path to take effect

$ApplyImmediately = $true
if ($ApplyImmediately)
{
    if (-not ("Win32.NativeMethods" -as [Type]))
    {
        # import sendmessagetimeout from win32
        Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
    }

    $HWND_BROADCAST = [IntPtr] 0xffff;
    $WM_SETTINGCHANGE = 0x1a;
    $result = [UIntPtr]::Zero

    # notify all windows of environment block change
    [Win32.Nativemethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, "Environment", 2, 5000, [ref] $result);
}
