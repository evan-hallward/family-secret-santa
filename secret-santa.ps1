# Hallward Family Secret Santa matcher
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\secret-santa.ps1            # do the real draw
#   powershell -ExecutionPolicy Bypass -File .\secret-santa.ps1 -SelfTest  # check the rules, reveals nothing
#
# The real draw writes one file per person into .\assignments\ (e.g. John.txt)
# and never prints the matches, so the organizer can take part without peeking.

param(
    [string]$OutDir = (Join-Path $PSScriptRoot 'assignments'),
    [switch]$SelfTest
)

$Participants = @('John', 'Karma', 'Laura', 'Sam', 'Evan', 'Cat', 'Derek')

# Pairs who must not be matched with each other (in either direction).
$Excluded = @(
    @('John', 'Karma'),
    @('Laura', 'Sam'),
    @('Evan', 'Cat')
)

function Test-Allowed([string]$Giver, [string]$Receiver) {
    if ($Giver -eq $Receiver) { return $false }
    foreach ($pair in $Excluded) {
        if (($pair -contains $Giver) -and ($pair -contains $Receiver)) { return $false }
    }
    return $true
}

# Shuffle until every giver/receiver pair is allowed. Rejection sampling keeps
# every valid outcome equally likely.
function New-Draw {
    for ($attempt = 1; $attempt -le 100000; $attempt++) {
        $receivers = @($Participants | Get-Random -Count $Participants.Count)
        $ok = $true
        for ($i = 0; $i -lt $Participants.Count; $i++) {
            if (-not (Test-Allowed $Participants[$i] $receivers[$i])) { $ok = $false; break }
        }
        if ($ok) {
            $draw = [ordered]@{}
            for ($i = 0; $i -lt $Participants.Count; $i++) { $draw[$Participants[$i]] = $receivers[$i] }
            return $draw
        }
    }
    throw 'Could not find a valid draw. Check the exclusion rules.'
}

if ($SelfTest) {
    $runs = 2000
    for ($n = 1; $n -le $runs; $n++) {
        $draw = New-Draw
        foreach ($giver in $draw.Keys) {
            if (-not (Test-Allowed $giver $draw[$giver])) { throw "Rule broken in draw $n" }
        }
        $distinct = @($draw.Values | Sort-Object -Unique).Count
        if ($distinct -ne $Participants.Count) { throw "Someone received twice in draw $n" }
    }
    Write-Host "Self-test passed: $runs draws, no rules broken, everyone gives and receives exactly once."
    return
}

$draw = New-Draw

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
Get-ChildItem -Path $OutDir -Filter '*.txt' | Remove-Item -Force

foreach ($giver in $draw.Keys) {
    $message = @(
        "Hi $giver!",
        '',
        'For the Hallward family Secret Santa, you are buying a gift for:',
        '',
        "    $($draw[$giver])",
        '',
        "Shh, it's a secret. Merry Christmas!"
    )
    Set-Content -Path (Join-Path $OutDir "$giver.txt") -Value $message -Encoding UTF8
}

Write-Host "Done. $($Participants.Count) assignment files written to: $OutDir"
Write-Host 'Send each person only their own file. The matches were not shown here.'
