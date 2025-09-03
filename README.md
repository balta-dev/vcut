# VCut – Video Cutting Tool ✂️🎬

VCut is a lightweight command-line tool to quickly cut video fragments.
* Supports any video format
* You can mix formats (for example, 12 3:12, means from the second 12 to 3 minutes and 12 seconds)
* EXTREMELY FAST
* very easy to use
* 
# REQUIREMENTS
* [FFMPEG](https://ffmpeg.org/download.html)

# --- Linux ---

## Download the latest release:
``` https://github.com/balta-dev/vcut/releases/download/1.1/vcut ```

## Open your Download directory and move the file to ```/usr/bin``` to use it globally:
```bash
cd {your/download/directory}
sudo mv vcut /usr/bin 
```

# --- Windows ---

## Download the latest release:
``` https://github.com/balta-dev/vcompr/releases/download/1.1/vcut.exe ```

## Go to your Download Folder, right click and open "cmd" or "powershell", and paste that command to use it globally:
```powershell
Copy-Item .\vcut.exe "C:\Windows\System32"
```

## Ready! Usage examples:
* vcut 5:23 5:42 "filename.mp4"
* vcut 12 15:32 "filename.mkv"
