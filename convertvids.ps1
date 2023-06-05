
$oldVideos = Get-ChildItem -Include @("*.avi", "*.divx", "*.mov", "*.mpg", "*.wmv") -Recurse;

do{
    $deleteAfter =  Read-Host -Prompt 'Delete original files after conversion? (y/n): ';
} until ($deleteAfter -eq "y" -or $deleteAfter -eq "n");


foreach ($oldVideo in $oldVideos) {
    $newVideo = [io.path]::ChangeExtension($oldVideo.FullName, '.mp4');
    $newVideo = $newVideo.Replace(".", "_rencoded_h264.");

    $ArgumentList = '-y -i "{0}" -c:v libx264 -preset slow -movflags +faststart -crf 20 -c:a libfdk_aac -b:a 128k "{1}"' -f $oldVideo, $newVideo;

    $success = (Start-Process -FilePath .\ffmpeg.exe -ArgumentList $ArgumentList -Wait -NoNewWindow -PassThru)
    if ($success.ExitCode -ne 0){
        Remove-Item $newVideo;
    }
    if ($success.ExitCode -eq 0 -and $deleteAfter -eq "y"){
        Remove-Item $oldVideo;
    }
}