#!/usr/bin/env nix-shell
#! nix-shell -p ffmpeg -p powershell -i pwsh

Get-ChildItem /media/sda1-usb-MATSHITA_HC-V380/PRIVATE/AVCHD/BDMV/STREAM/ | foreach {
    $infile = $_.FullName
    $outfile = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") + '.webm'
    $timestamp = $_.LastWriteTime.ToString("yyyyMMddTHH:mm:ssZ")
    If (-not (Test-Path "./$outfile")) {
        echo "$outfile doesn't exist, converting. $infile -> $outfile"
        ffmpeg -y -i $infile -metadata DATE_RECORDED="$timestamp" -strict 2 -vb 10M -crf 0 `
               -vcodec vp9 -ab 128k -acodec libopus ".$outfile"
        mv ".$outfile" $outfile
    } Else {
        echo "$outfile exists, skipping"
    }
}

