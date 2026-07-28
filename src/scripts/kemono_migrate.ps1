```powershell

$DelayMs = 100
$Session = "eyJfcGVybWFuZW50Ijp0cnVlLCJhY2NvdW50X2lkIjoxOTA1OTJ9.akqHXA.-feU7JNnRzeafGnZPhiu6jEGwmo"
$JsonFile = "./kemono.json"
$BaseUrl = "https://pawchive.pw/api/v1/favorites/creator"

$ErrorActionPreference = "Stop"

function Add-Creator {
    param(
        [hashtable]$Map,
        [string]$Service,
        [string]$Id
    )

    if ([string]::IsNullOrWhiteSpace($Service) -or [string]::IsNullOrWhiteSpace($Id)) {
        return
    }

    $key = "$Service|$Id"
    if (-not $Map.ContainsKey($key)) {
        $Map[$key] = [pscustomobject]@{
            Service = $Service
            Id      = $Id
        }
    }
}

if (-not (Test-Path -LiteralPath $JsonFile)) {
    throw "JSON file not found: $JsonFile"
}

# Read and parse JSON
$jsonText = Get-Content -LiteralPath $JsonFile -Raw
$json = $jsonText | ConvertFrom-Json -Depth 50

# Collect unique creators while keeping insertion order
$creators = @{}

if ($null -ne $json.posts) {
    foreach ($post in $json.posts) {
        Add-Creator -Map $creators -Service ([string]$post.service) -Id ([string]$post.user)
    }
}

if ($null -ne $json.artists) {
    foreach ($artist in $json.artists) {
        Add-Creator -Map $creators -Service ([string]$artist.service) -Id ([string]$artist.id)
    }
}

$creatorList = $creators.Values

Write-Host "Found $($creatorList.Count) unique creators."

# Browser-like headers based on captured request
$headers = @{
    Cookie       = "session=$Session"
    Origin       = "https://pawchive.pw"
    Referer      = "https://pawchive.pw/"
    Accept       = "*/*"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:153.0) Gecko/20100101 Firefox/153.0"
    DNT          = "1"
    "Sec-GPC"    = "1"
}

$okCount = 0
$failCount = 0
$index = 0

foreach ($creator in $creatorList) {
    $index++

    $service = [uri]::EscapeDataString($creator.Service)
    $id = [uri]::EscapeDataString($creator.Id)
    $url = "$BaseUrl/$service/$id"

    Write-Progress `
        -Activity "Migrating favorite creators" `
        -Status "$index / $($creatorList.Count)" `
        -PercentComplete ([math]::Round(($index * 100) / [math]::Max($creatorList.Count, 1), 0))

    if ($DryRun) {
        Write-Host "[DRY] POST $url"
        continue
    }

    try {
        $response = Invoke-WebRequest `
            -Method POST `
            -Uri $url `
            -Headers $headers `
            -ContentType "application/json" `
            -UseBasicParsing

        $status = [int]$response.StatusCode
        if ($status -eq 204 -or $status -eq 200) {
            $okCount++
            Write-Host "[OK] $($creator.Service)/$($creator.Id) -> $status"
        }
        else {
            $failCount++
            Write-Warning "[UNEXPECTED] $($creator.Service)/$($creator.Id) -> $status"
        }
    }
    catch {
        $failCount++

        $statusCode = $null
        $message = $_.Exception.Message

        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }

        if ($null -ne $statusCode) {
            Write-Warning "[FAIL] $($creator.Service)/$($creator.Id) -> $statusCode"
        }
        else {
            Write-Warning "[FAIL] $($creator.Service)/$($creator.Id)"
        }

        Write-Warning $message
    }

    if ($DelayMs -gt 0) {
        Start-Sleep -Milliseconds $DelayMs
    }
}

Write-Host ""
Write-Host "Done. OK=$okCount FAIL=$failCount TOTAL=$($creatorList.Count)"
