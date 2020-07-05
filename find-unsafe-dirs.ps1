# Möglichst zufälligen Dateinamen wählen.
$executableFilename = 'psancxtqkbgfomb.cmd';

# Bei Fehlern einfach fortsetzen.
$ErrorActionPreference = 'SilentlyContinue';

Get-ChildItem $env:windir -Recurse -Force | Where-Object { $_.PSIsContainer } | ForEach-Object {
    $currentFolder = $_.Fullname;
    $executableFilepath = (Join-Path $currentFolder $executableFilename);

    # Datei mit trivialem Inhalt erstellen.
    New-Item -Path $executableFilepath -ItemType file -Value "@echo off" | Out-Null;

    if ($?) {
        # Mehr Rechte für die neue Datei.
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule ("BUILTIN\Users", "ExecuteFile", "Allow");
        $acl = Get-ACL -Path $executableFilepath;
        $acl.AddAccessRule($rule);
        Set-ACL -Path $executableFilepath -AclObject $acl;

        # Datei ausführen.
        & $executableFilepath;

        if ($?) {
            Write-Host $currentFolder -BackgroundColor Red;
        }

        # Angelegte Datei wieder löschen.
        Remove-Item -Path $executableFilepath;
    }
}