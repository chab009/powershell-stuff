# ---------- JOB 1: CREATE RARBG LIST ----------

$mediainfo = "PATH TO MEDIAINFO.EXE CLI VERSION"
$scanPath  = "PATH TO MAIN MEDIA FOLDER"

#Output file created that will contain the path to each media file detected to have the rarbg metadata tag. Used in Job 2.
$outputList = "C:\VideoScan\rarbg_files.txt"

Remove-Item $outputList -ErrorAction SilentlyContinue

Get-ChildItem -Path $scanPath -Recurse -Include *.mp4 | ForEach-Object {
    $file = $_.FullName
    $encodedLib = & $mediainfo --Inform 'Video;%Encoded_Library%' "$file" 2>$null
    if ($encodedLib -match 'rarbg') {
        Add-Content -Path $outputList -Value $file
        Write-Host "Found RARBG tag in: $file"
    }
}

Write-Host "`nRARBG scan complete."
Write-Host "File list saved to: $outputList"


# ---------- JOB 2: CONVERT LISTED MP4s TO MKVs + DELETE ORIGINAL ----------
$mkvmerge  = "C:\Program Files\MKVToolNix\mkvmerge.exe"

#Output file created from Job 1. Used to feed in to MKVMERGE
$listFile  = "C:\VideoScan\rarbg_files.txt"

if (Test-Path $listFile) {
    $files = Get-Content $listFile
    foreach ($f in $files) {
        if (-not (Test-Path $f)) {
            Write-Warning "File missing: $f"
            continue
        }

        $output = [System.IO.Path]::ChangeExtension($f, ".mkv")

        if (Test-Path $output) {
            Write-Host "Skipping (already exists): $output"
            continue
        }

        Write-Host "`nConverting:`n$f`n--> $output"

        # Run mkvmerge and capture the exit code
        & $mkvmerge -o "$output" "$f"
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0 -and (Test-Path $output)) {
            try {
                Remove-Item -LiteralPath $f -Force
                Write-Host "✅ Conversion successful. Deleted original: $f"
            } catch {
                Write-Warning "Converted OK but failed to delete original: $f"
            }
        } else {
            Write-Warning "❌ Conversion failed for: $f (Exit code: $exitCode)"
        }
    }
} else {
    Write-Warning "List file not found: $listFile"
}

Write-Host "`nBatch conversion complete."
