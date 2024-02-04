function ConvertTo-TextYN {
    <#
    .SYNOPSIS
    Used by As Built Report to convert true or false automatically to Yes or No.
    .DESCRIPTION

    .NOTES
        Version:        0.3.0
        Author:         LEE DAILEY

    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter (
            Position = 0,
            Mandatory)]
        [AllowEmptyString()]
        [string]
        $TEXT
    )

    switch ($TEXT) {
        "" { "--" }
        $Null { "--" }
        "True" { "Yes"; break }
        "False" { "No"; break }
        default { $TEXT }
    }
} # end
function Get-UnixDate ($UnixDate) {
    <#
    .SYNOPSIS
    Used by As Built Report to convert Date to a more nice format.
    .DESCRIPTION

    .NOTES
        Version:        0.2.0
        Author:         LEE DAILEY

    .EXAMPLE

    .LINK

    #>
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($UnixDate))
} # end
function ConvertTo-EmptyToFiller {
    <#
    .SYNOPSIS
    Used by As Built Report to convert empty culumns to "-".
    .DESCRIPTION

    .NOTES
        Version:        0.5.0
        Author:         Jonathan Colon

    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter (
            Position = 0,
            Mandatory)]
        [AllowEmptyString()]
        [string]
        $TEXT
    )

    switch ($TEXT) {
        "" { "-"; break }
        $Null { "-"; break }
        "True" { "Yes"; break }
        "False" { "No"; break }
        default { $TEXT }
    }
} # end

function ConvertTo-VIobject {
    <#
    .SYNOPSIS
    Used by As Built Report to convert object to VIObject.
    .DESCRIPTION

    .NOTES
        Version:        0.1.0
        Author:         Jon Colon

    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter (
            Position = 0,
            Mandatory)]
        [AllowEmptyString()]
        $OBJECT
    )

    if (Get-View $OBJECT -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name -Unique) {
        return Get-View $OBJECT -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name -Unique
    } else {
        return $OBJECT
    }
} # end
function ConvertTo-HashToYN {
    <#
    .SYNOPSIS
        Used by As Built Report to convert array content true or false automatically to Yes or No.
    .DESCRIPTION

    .NOTES
        Version:        0.1.0
        Author:         Jonathan Colon

    .EXAMPLE

    .LINK

    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    Param (
        [Parameter (Position = 0, Mandatory)]
        [AllowEmptyString()]
        [Hashtable] $TEXT
    )

    $result = [ordered] @{}
    foreach ($i in $inObj.GetEnumerator()) {
        try {
            $result.add($i.Key, (ConvertTo-TextYN $i.Value))
        } catch {
            Write-PScriboMessage -IsWarning "Unable to process $($i.key) values"
        }
    }
    if ($result) {
        return $result
    } else { return $TEXT }
} # end

function ConvertTo-FileSizeString {
    <#
    .SYNOPSIS
    Used by As Built Report to convert bytes automatically to GB or TB based on size.
    .DESCRIPTION
    .NOTES
        Version:        0.4.0
        Author:         LEE DAILEY
    .EXAMPLE
    .LINK
    #>
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter (
            Position = 0,
            Mandatory)]
        [int64]
        $Size
    )
    switch ($Size) {
        { $_ -gt 1TB } { [string]::Format("{0:0} TB", $Size / 1TB); break }
        { $_ -gt 1GB } { [string]::Format("{0:0} GB", $Size / 1GB); break }
        { $_ -gt 1MB } { [string]::Format("{0:0} MB", $Size / 1MB); break }
        { $_ -gt 1KB } { [string]::Format("{0:0} KB", $Size / 1KB); break }
        { $_ -gt 0 } { [string]::Format("{0} B", $Size); break }
        { $_ -eq 0 } { "0 KB"; break }
        default { "0 KB" }
    }
} # end >> function Format-FileSize