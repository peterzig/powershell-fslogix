$stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

<# Downloads + Recycle Bin #>
$temp = New-Object PSObject -Property @{
    first_path = "C:\Users\"
    second_path = $env:USERNAME
    third_path = "\AppData\Local\Temp"
}

$downloads = New-Object PSObject -Property @{
    first_path = "*path_to_Downloads*
    second_path = $env:USERNAME
    third_path = "\Downloads"
}

$localappdata = New-Object PSObject -Property @{
    first_path = $env:LocalAppData
}

$appdata = New-Object PSObject -Property @{
    first_path = $env:AppData
}

$fileList = New-Object -TypeName "System.Collections.ArrayList"

function Convert-Size {
        [OutputType([System.Double])]
        Param(
            [ValidateSet("b", "B", "KB", "KiB", "MB", "MiB", "GB", "GiB", "TB", "TiB", "PB", "PiB", "EB", "EiB", "ZB", "ZiB", "YB", "YiB")]
            [Parameter(Mandatory = $true)]
            [System.String] $From,

            [ValidateSet("b", "B", "KB", "KiB", "MB", "MiB", "GB", "GiB", "TB", "TiB", "PB", "PiB", "EB", "EiB", "ZB", "ZiB", "YB", "YiB")]
            [Parameter(Mandatory = $true)]
            [System.String] $To,

            [Parameter(Mandatory = $true)]
            [System.Double] $Value,

            [System.Int32] $Precision = 2
        )
        # Convert the supplied value to Bytes
        switch -casesensitive ($From) {
            "b" { $value = $value / 8 }
            "B" { $value = $Value }
            "KB" { $value = $Value * 1000 }
            "KiB" { $value = $value * 1024 }
            "MB" { $value = $Value * 1000000 }
            "MiB" { $value = $value * 1048576 }
            "GB" { $value = $Value * 1000000000 }
            "GiB" { $value = $value * 1073741824 }
            "TB" { $value = $Value * 1000000000000 }
            "TiB" { $value = $value * 1099511627776 }
            "PB" { $value = $value * 1000000000000000 }
            "PiB" { $value = $value * 1125899906842624 }
            "EB" { $value = $value * 1000000000000000000 }
            "EiB" { $value = $value * 1152921504606850000 }
            "ZB" { $value = $value * 1000000000000000000000 }
            "ZiB" { $value = $value * 1180591620717410000000 }
            "YB" { $value = $value * 1000000000000000000000000 }
            "YiB" { $value = $value * 1208925819614630000000000 }
        }
        # Convert the number of Bytes to the desired output
        switch -casesensitive ($To) {
            "b" { $value = $value * 8 }
            "B" { return $value }
            "KB" { $Value = $Value / 1000 }
            "KiB" { $value = $value / 1024 }
            "MB" { $Value = $Value / 1000000 }
            "MiB" { $Value = $Value / 1048576 }
            "GB" { $Value = $Value / 1000000000 }
            "GiB" { $Value = $Value / 1073741824 }
            "TB" { $Value = $Value / 1000000000000 }
            "TiB" { $Value = $Value / 1099511627776 }
            "PB" { $Value = $Value / 1000000000000000 }
            "PiB" { $Value = $Value / 1125899906842624 }
            "EB" { $Value = $Value / 1000000000000000000 }
            "EiB" { $Value = $Value / 1152921504606850000 }
            "ZB" { $value = $value / 1000000000000000000000 }
            "ZiB" { $value = $value / 1180591620717410000000 }
            "YB" { $value = $value / 1000000000000000000000000 }
            "YiB" { $value = $value / 1208925819614630000000000 }
        }
        [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
    }


<# directories from local appdata #>

$array_appdata_local = @("\Microsoft\Windows\CrashReports" , "\Microsoft\MSOIdentityCRL\Tracing"
                "\CrashDumps","\Package Cache",
                "\D3DSCache","\Microsoft\Windows\WebCache.old",
                "\Apps",
                "\Microsoft\Windows\Explorer\IconCacheToDelete",
                "\Microsoft\Windows\Explorer\ThumbCacheToDelete",
                "\Microsoft\Windows\Explorer\*.db",
                "\Windows\Notifications\wpnidm",
                "\Microsoft\Windows\PPBCompatCache",
                "\Microsoft\Windows\PPBCompatUaCache",
                "\Microsoft\Windows\PRICache",
                "\Microsoft\Windows\Explorer\ExplorerStartupLog.etl",
                "\Microsoft\Windows\INetCache\IE",
                "\Microsoft\Windows\INetCache\Low",
                "\Microsoft\Windows\AppCache",
                "\Microsoft\Windows\WebCache",
                "\Microsoft\Windows\PRICache",
                "\Microsoft\Windows\Explorer\ExplorerStartupLog.etl",
                "\Microsoft\Windows\INetCache\IE",
                "\Microsoft\Windows\INetCache\Low",
                "\Microsoft\Windows\AppCache",
                "\Microsoft\Windows\WebCache",
                "\Microsoft\Windows\History",
                "\Microsoft\CLR_v4.0_32",
                "\Microsoft\CLR_v4.0",
                "\Microsoft\GameDVR",
                "\Microsoft\GraphicsCache",
                "\Microsoft\TokenBroker\Cache",
                "\Downloaded Installations"
                "\assembly",
                "\CEF",
                "\Deployment",
                "\SCOM\LOGS",
                "\Microsoft\Internet Explorer\*.log",
                "\Microsoft\Internet Explorer\CacheStorage",
                "\Microsoft\Office365\Powershell",
                "\Microsoft\AzureAD\Powershell",
                "\Mozilla\Firefox\Profiles\*\cache",
                "\Mozilla\Firefox\Profiles\*\cache2",
                "\Mozilla\Firefox\Profiles\*\OfflineCache",
                "\Mozilla\Firefox\Profiles\*\jumpListCache",
                "\Mozilla\Firefox\Profiles\*\startupCache",
                "\Mozilla\Firefox\Profiles\*\thumbnails",
                "\Microsoft\Terminal Server Client\Cache",
                "\Microsoft\Media Player\Transcoded Files Cache",
                "\Microsoft\Teams\packages",
                "\Packages\MSTeams_*\LocalCache\Microsoft\MSTeams\EBWebView\WV2Profile_tfw\Service Worker\CacheStorage",
                "\Microsoft\Teams\previous",
                "\Microsoft\Office\16.0\Lync\Tracing",
                "\Microsoft\Office\16.0\Wef\webview2",
                "\Microsoft OneDrive\Update\OneDriveSetup.exe",
                "\Microsoft\OneDrive\logs",
                "\Packages\Microsoft.MicrosoftEdge_*\AC\MicrosoftEdge\Cache",
                "\Packages\Microsoft.MicrosoftEdge_*\AC\*\MicrosoftEdge\Cache",
                "\Packages\Microsoft.MicrosoftEdge_*\AC\Temp",
                "\Microsoft\EdgeUpdate\Download",
                "\Microsoft\EdgeUpdate\Install",
                "\Edge Dev\User Data\*\Cache",
                "\Edge Dev\User Data\*\Local Storage",
                "\Edge Dev\User Data\*\GPUCache",
                "\Edge\User Data\*\Cache",
                "\Edge\User Data\*\Local Storage",
                "\Edge\User Data\*\GPUCache",
                "\Microsoft\Edge\User Data\*\Service Worker",
                "Edge Beta\User Data\*\Cache",
                "\Edge Beta\User Data\*\Local Storage",
                "\Edge Beta\User Data\*\GPUCache",
                "Edge SxS\User Data\*\Cache",
                "\Edge SxS\User Data\*\Local Storage",
                "\Edge SxS\User Data\*\GPUCache",
                "\Edge\User Data\Default\Code Cache\js\*",
                "\Microsoft\Edge\User Data\Default\Cache\Cache_Data",
                "\Packages\Microsoft.BingNews_*\AC\Microsoft\CryptnetUrlCache",
                "\Google\Chrome\User Data\*.tmp",
                "\Google\Chrome\User Data\*\Cache",
                "\Google\Chrome\User Data\*\Service Worker\CacheStorage",
                "\Google\Chrome\User Data\*\Service Worker\Database",
                "\Google\Chrome\User Data\ShaderCache\GPUCache",
                "\Google\Chrome\User Data\*\Local Storage",
                "\Google\Chrome\User Data\*\Media Cache",
                "\Google\Chrome\User Data\*\Service Worker\ScriptCache",
                "\Google\Sotware Reporter Tool\*.log",
                "\Google\Sotware Reporter Tool\reports\*.dmp",
                "\Google\Chrome\Application\*\Installer",
                "Google\Chrome\User Data\Default\Extensions",
                "\ZoomVDI\plugin\webview2_x64\*\Locales\*.pak",
                "\WebEx\addin\WebView2_x64",
                "\Adobe\ARM"
                )

$array_appdata = @("\Microsoft\Windows\Cookies",
                    "\Microsoft\Windows\DNTException",
                    "\Microsoft\Windows\IECompatCache",
                    "\Microsoft\Windows\IECompatUACache",
                    "\Microsoft\Windows\IEDownloadHistory",
                    "\Microsoft\Windows\IETldCache",
                    "\Microsoft\Installer",
                    "\Microsoft\Windows\Recent\*.lnk",
                    "\Microsoft\Windows\Network Shortcuts",
                    "\Microsoft\Windows\Printer Shortcuts",
                    "\LocalLow\Microsoft\Windows\AppCache",
                    "\Mozilla\Firefox\Crash Reports",
                    "\Teams\logs",
                    "\Microsoft Teams\logs",
                    "\Microsoft\Teams\Application Cache",
                    "\Microsoft\Teams\Cache",
                    "\Microsoft\Teams\GPUCache",
                    "\Microsoft\Teams\media-stack",
                    "\Microsoft\Teams\Service Worker",
                    "\Microsoft\Teams\meeting-addin\Cache",
                    "\Microsoft\Teams\DownloadedUpdate",
                    "\Microsoft Teams\blob_storage",
                    "\Microsoft Teams\databases",
                    "\Microsoft Teams\indexeddb",
                    "\Microsoft Teams\Local Storage",
                    "\Microsoft Teams\tmp",
                    "\Microsoft\Word\*.asd",
                    "\Microsoft\Word\*.wbk",
                    "\Microsoft\Word\*.wbk",
                    "\Microsoft\Word\*.tmp",
                    "\Adobe\SLData",
                    "\Adobe\Common\Media Cache Files",
                    "\Roaming\XnViewMP",
                    "\Roaming\Microsoft\PowerPoint"
                    "\Roaming\Nextcloud\Nextcloud-3.11.0-x64.msi"
                    )

$array_other = @("","")
$excluded = @("desktop.ini")
$result = $temp.first_path + $temp.second_path + $temp.third_path
$result2 = $temp.first_path + $temp.second_path + $temp.third_path
<#$result2 = $downloads.first_path + $downloads.second_path + $downloads.third_path #>

Write-Host "Deleting directories..."
Write-Host $result
Write-Host $result2
$paths = $result, $result2
foreach ($filePath in $paths){
    if(Test-Path $filePath){
        Write-Host "Deleting $filePath"
        Get-ChildItem -Path $filePath -ErrorAction SilentlyContinue -exclude $excluded | Remove-Item -Recurse -Confirm:$false -Force -ErrorAction "SilentlyContinue"
        } else {
            Write-Host "Path do not exist"
        }
}

For ($i=0; $i -le $($array_appdata_local.length); $i++){
    $element = $array_appdata_local[$i]
    $result3 = $localappdata.first_path + $element
    $files1 = Get-ChildItem -Path $result3 -ErrorAction SilentlyContinue
    $fileList.Add($files1)
    if(Test-Path -Path $result3){
    Write-Host "Deleting $result3"
    Get-ChildItem -Path $result3 -ErrorAction SilentlyContinue | Remove-Item  -Recurse -Confirm:$false -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "No path found."
    }
}

For ($i=0; $i -le $($array_appdata.length); $i++){
    $element2 = $array_appdata[$i]
    $result4 = $appdata.first_path + $element2
    $files2 = Get-ChildItem -Path $result4 -ErrorAction SilentlyContinue
    $fileList.Add($files2)
    if(Test-Path -Path $result4){
    Write-Host "Deleting $result4"
    Get-ChildItem -Path $result4 -ErrorAction SilentlyContinue | Remove-Item -Recurse --Confirm:$false -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "No path found."
    }
}

    # Output total size of files deleted
    if ($fileList.FullName.Count -gt 0) {

        Remove-Variable -Name "fileSize" -ErrorAction "SilentlyContinue"
        foreach ($item in $fileList) {
            foreach ($file in $item) {
                $fileSize += $file.Length
                $fileCount += 1
            }
        }
        Remove-Variable -Name "sizeMiB" -ErrorAction "SilentlyContinue"
        $sizeMiB = Convert-Size -From "B" -To "MiB" -Value $fileSize

        # Write deleted file list out to the log file
        if ($WhatIfPreference -eq $True) { $WhatIfPreference = $False }
        Write-Host -Message " File list start:"
        Write-Host -Message ($fileList.FullName -join "`n")
        Write-Host -Message " File list end."
    }
    else {
        $sizeMiB = 0
    }


    Write-Host "Total file size deleted $sizeMiB MiB."

    # Return the size of the deleted files in MiB to the pipeline
    $PSObject = [PSCustomObject] @{
        Files   = $fileCount
        Deleted = "$sizeMiB MiB"
    }
    Write-Output -InputObject $PSObject

    $stopWatch.Stop()
    Write-Host "Script took $($stopWatch.Elapsed.TotalMilliseconds) ms to complete."
    Write-Host "Time to complete $($stopWatch.Elapsed.TotalMilliseconds) ms."
