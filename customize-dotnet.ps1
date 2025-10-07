param (
    [string]$Path = ".",
    [string]$NewPrefix
)

function Replace-Namespace {
    param (
        [string]$FilePath,
        [string]$OldNamespace,
        [string]$NewNamespace
    )

    (Get-Content -Path $FilePath) -replace "\b$OldNamespace\b", $NewNamespace | Set-Content -Path $FilePath
}

function Process-Files {
    param (
        [string]$Directory,
        [string]$OldNamespace,
        [string]$NewNamespace
    )

    Get-ChildItem -Path $Directory -Recurse -File | ForEach-Object {
        Replace-Namespace -FilePath $_.FullName -OldNamespace $OldNamespace -NewNamespace $NewNamespace
    }
}

function Rename-CsprojFiles {
    param (
        [string]$Directory,
        [string]$OldPrefix,
        [string]$NewPrefix
    )

    Get-ChildItem -Path $Directory -Recurse -File -Filter "*.csproj" | ForEach-Object {
        $newName = $_.Name -replace "^$OldPrefix", $NewPrefix
        Rename-Item -Path $_.FullName -NewName $newName
    }
}

function Rename-Directories {
    param (
        [string]$Directory,
        [string]$OldPrefix,
        [string]$NewPrefix
    )

    Get-ChildItem -Path $Directory -Recurse -Directory | ForEach-Object {
        if ($_.Name -like "$OldPrefix*") {
            $newName = $_.Name -replace "^$OldPrefix", $NewPrefix
            Rename-Item -Path $_.FullName -NewName $newName
        }
    }
}

if (-not $NewPrefix) {
    Write-Host "Please provide a new prefix for the namespace."
    exit 1
}

$OldNamespace = "DotnetTemplate"
$NewNamespace = $NewPrefix

Process-Files -Directory $Path -OldNamespace $OldNamespace -NewNamespace $NewNamespace
Rename-CsprojFiles -Directory $Path -OldPrefix $OldNamespace -NewPrefix $NewNamespace
Rename-Directories -Directory $Path -OldPrefix $OldNamespace -NewPrefix $NewNamespace

Write-Host "Namespace, .csproj file, and directory renaming completed."
