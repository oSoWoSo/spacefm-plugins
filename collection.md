# The whole collection
# Play-with-VLC.spacefm plugin
## Play with VLC
    
    #play whole directory or only directory VIDEO_TS in VLC
    vlc %F

# Archive.spacefm plugin
## Archive...
    
    file-roller -d %F

# Check out.spacefm plugin
## Look at
    
    echo -ne "\\e]2;less "%n"...\\a" & less -R -- %F

# Bulk-rename.spacefm plugin
## B_ulk rename
    
    thunar --bulk-rename %F

# Check-checksum.spacefm plugin
## Chec_k checksum
    
    ${fm_file##*.}sum -c %n

# Checksums---file1sha256.spacefm plugin
## Checksu_ms -> "file[1].sha256"
    
    sha256sum %N > %n.sha256

# Copy-tab-to-panel-.spacefm-plugin
## Copy tab to panel ...
    
    [[ $fm_value =~ ^[1-4]$ ]] || { spacefm -g --label "Error panel number $fm_value" --button ok; exit; }
    [ $(spacefm --socket-cmd get panel${fm_value}_visible) = 1 ] || spacefm --socket-cmd set panel${fm_value}_visible true
    spacefm --socket-cmd set --panel $fm_value new_tab %d

# Copy-to-ramdisk.spacefm plugin
## Copy to _ramdisk
    
    spacefm -s run-task copy "${fm_files[@]}" /media/ramdisk

# Del-from-Trash.spacefm plugin
## Del from Trash
    
    ## NO HOTKEY, because that would also work without showing the menu item; disabled outside trash is shown anyway, and that makes our menus too long. So just context "show in trash", and no hotkey
    
    # if in trash files, remove trash info too, and vice versa
    # we ARE carefull to remove only when directory change succeeds
    # we don't care if files we want to delete do not exist
    # we always remove trash file before trashinfo
    #! [[ == ]] to use pattern matching
    if [[ %d == */files ]]
    then
    rm --recursive %F
    cd %d/../info && rm "${fm_filenames[@]/%/.trashinfo}"
    elif [[ %d == */info ]]
    then
    pushd ../files > /dev/null && (
    rm --recursive "${fm_filenames[@]/%.trashinfo}"
    popd > /dev/null && rm %F
    )
    else
    >&2 echo "Spacefm plugin malconfigured, should run only in trash info or trash files"
    fi

# Film-nfo-zien.spacefm plugin
## see movie info
    
    ##shows the .nfo with the same base name as the movie
    ## neither as task nor as terminal, start e.g. mouse pad :
    #/home/dirk/Documents/shellscripts/toonfilmnfo.sh %F
    
    ## as task, in spacefm popup (see Options "X Run as task, X Popup task")
    # sort "${fm_files[@]}" (same as %F), and replace .??? by .nfo
    [ -v IFS ] && ifsOld="$IFS" || unset ifsOld
    IFS=$'
    ' nfos=($(sort -u <<<"${fm_files[*]/%.[^.][^.][^.]/.nfo}"))
    [ -v ifsOld ] && IFS="$ifsOld" || unset IFS
    # see my /bin/catfiles
    for nfo in "${nfos[@]}"
    do
    if [[ -f "$nfo" && -r "$nfo" ]]
    then
    echo "${nfo##*/}"
    echo "${nfo%/*}"
    cat "$nfo"
    echo -e "
    =============="
    fi
    done
    

# HexEdit-Tweak.spacefm plugin
## HexEdit Tweak
    
    ## run in Terminal (works, but without its own window title)
    #tweak -l %f
    
    ## run as task, open terminal yourself with filename in window title (works)
    # xfce4-terminal --geometry=78x51 --hide-menubar --hide-toolbar -T tweak_%n -x tweak -l %f >> "/tmp/${USER}_tweak$$_stdout" 2>> " /tmp/${USER}_tweak$$_stderr"
    
    ## run as task, open terminal yourself with file name in window title and man page in 2nd tab (works)
    ## NOTE : tweak in 2nd tab gets wrong geometry from xfce4-terminal when that tabs only show
    ## from 2nd tab (depending on MiscAlwaysShowTabsin in ~/.config/xfce4/terminal/terminalrc)
    ## But in 1st tab, xfce4-terminal can only run command with -e "command param",
    ## because -x, for which rest of the line is the command, can only be used as the last parameter.
    ## Spacefm doesn't want quotes around %n and %f, so use the corresponding shell variables :
    xfce4-terminal --geometry=78x51 --hide-menubar --hide-toolbar -T "tweak $fm_filename" -H -e "tweak -fl \"$fm_file\"" --active-tab --tab -T "man tweak" -e "man tweak"
    ## other workaround
    #export file=%f;xfce4-terminal --geometry=78x51 --hide-menubar --hide-toolbar -T tweak_%n -H -e "tweak -fl \"$file\"" --active-tab --tab -T "man tweak" -e "man tweak"
    

# ImageWrapper---file1pdf.spacefm plugin
## ImageWrapper -> file[1].pdf
    
    #makes 1 pdf from set jpg and jb2
    java be.arci.pdf.ImageWrapper %N

# Java-class-decompiler.spacefm-plugin
## Java .class decompiler
    
    # Luyten GUI for Procyon decompiler
    java -jar /home/dirk/bin/java/luyten.jar %f

# Jbig2Viewer.spacefm plugin
## Jbig2Viewer
    
    java be.arci.jbig2.Jbig2Viewer %F

# Jbig2Writer.spacefm plugin
## Jbig2Writer
    
    # only works for black and white
    nice java be.arci.jbig2.Jbig2Writer %F

# Jpeg-decolorize.spacefm plugin
## Decolor Jpeg
    
    Convert #jpegs to gray with JpegTrans
    nice /home/dirk/Documents/shellscripts/parallel_jpegtran_grayscale.sh %F

# Optimize jpeg.spacefm plugin
## Optimize Jpeg
    
    #jpegs lossless recompress with JpegTran
    nice /home/dirk/Documents/shellscripts/parallel_jpegtran_recompress.sh %F

# Crisscross-with-VLC.spacefm plugin
## Crisscross with VLC
    
    #play whole directory or only directory VIDEO_TS in VLC
    vlc --random %F

# Mount-archive-on-mediazipmnt.spacefm-plugin
## Mount archive on /media/zipmnt
    
    # archivemount readonly zip etc. (preferably no tar.xx)
    archivemount -o readonly %f /media/zipmnt; spacefm /media/zipmnt

# Mount-isosquash-on-cdrom.spacefm-plugin
## Mount iso/squash on /cdrom
    
    #mount a CD image (ISO, UDF, Alcohol MDF) or a squashfs archive on /cdrom
    #must exactly match a line in sudoers.d
    mtyp="${fm_file##*.}"
    mtyp="${mtyp,,}"
    [ "$mtyp" = "squashfs" ] || mtyp="udf,iso9660"
    sudo /bin/mount -o ro -t $mtyp %f /cdrom
    spacefm --socket-cmd set new_tab /cdrom
    

# Mount-isosquash-on-mnt.spacefm-plugin
## Mount iso/squash on /mnt
    
    #mount a CD image (ISO, UDF, Alcohol MDF) or a squashfs archive on /mnt
    #must exactly match a line in an /etc/sudoers.d/file
    mtyp="${fm_file##*.}"
    mtyp="${mtyp,,}"
    [ "$mtyp" = "squashfs" ] || mtyp="udf,iso9660"
    sudo /bin/mount -o ro -t $mtyp %f /mnt
    spacefm --socket-cmd set new_tab /mnt
    

# Compress PDF.spacefm plugin
## Compress PDF
    
    #compress pdf with Multivalent
    nice /home/dirk/bin/pdfcompress %F

# Paste-Sparse.spacefm plugin
## Paste Sparse
    
    eval copied_files=$(spacefm -s get clipboard_copy_files)
    cp --recursive --sparse=always "${copied_files[@]}" %d

# Script-in-terminal.spacefm-plugin
## _Script in terminal
    
    %f

# SmartVersion-list-svf.spacefm-plugin
## SmartVersion list .svf
    
    # views contents of .svf SmartVersion file
    # dependencies : smv on path [SmartVersion](http://www.smartversion.com/)
    for svf in %F
    do
    smv -lv "$svf"
    done

# SmartVersion-pack-svf-out-in.spacefm-plugin
## SmartVersion extract .svf into...
    
    # Extract .svf SmartVersion file to chosen directory
    # dependencies :
    # - bash
    # - smv on path [SmartVersion](http://www.smartversion.com/)
    # NOTE: spacefm -t --chooser has problems with its arguments : --dir and --save must be FOR
    # DIR/, DIR/ must end with /, and last path part of DIR/ is put in the
    # entry field shown. Make this as short and inconspicuous as possible by limiting it
    #	until "."
    eval "`cd "$fm_pwd";spacefm -g --window-size 1024x800 --label 'Choose target directory:' --chooser --dir --save ./ --button cancel --button ok`"
    if [ "$dialog_pressed_label" = "ok" ]
    then
    if [ -d "$dialog_chooser1_dir" ]
    then
    if [ -w "$dialog_chooser1_dir" ]
    then
    svf=$(realpath %f)
    cd "$dialog_chooser1_dir"
    smv -x "$svf" -br "${svf%/*}"
    else
    >&2 echo "Cannot write to target directory \"$dialog_chooser1_dir\""
    fi
    else
    >&2 echo "This is not a directory : \"$dialog_chooser1_dir\""
    fi
    fi
    

# Send-in-email.spacefm plugin
## _Send in email
    
    ## Requires Thunderbird, bash
    
    # Thunderbird CLI compose format : thunderbird -compose "subject='subject',body='text',attachment='path1,path2,...'"
    
    # escaping commas in attachment= doesn't work, so remove them by using symbolic
    # links without commas to such files; if it happens, thunderbird will resolve
    # the symbolic links and use the original filename in the message
    nocommapath=/tmp # on a multi-user system you might prefer a private directory
    attach=()
    cleanup=()
    for a in "${fm_files[@]}"
    do
    nocomma="${a//,/_}"
    if [ "$a" = "$nocomma" ]
    then # no commas to remove
    attachs+=("$a")
    elif [ "${a##*/}" = "${nocomma##*/}" ]
    then # comma is in the directory, link to a path without commas
    ln -s -t "$nocommapath"/ "$a"
    attachs+=("$nocommapath"/"${a##*/}")
    cleanup+=("$nocommapath"/"${a##*/}")
    else # comma is in the filename itself, replace it
    ln -s -T "$a" "$nocommapath"/"${nocomma##*/}"
    attachs+=( "$nocommapath"/"${nocomma##*/}")
    cleanup+=( "$nocommapath"/"${nocomma##*/}")
    fi
    done
    # use [*], NOT [@]
    thunderbird -compose "subject='$fm_value',body='<- ${#attachs[*]} attached file(s) ->',attachment='$(IFS=$','; echo "${attachs [*]}")'"
    
    # I would like to do a cleanup, but the thunderbird -compose command seems to delegate
    # to a running Thunderbird instance and exit; that's too soon to rm the symlinks
    # rm "${cleanup[@]}"
    
    # OLD VERSION
    #% is special for spacefm, separate it from format spec
    #stringformat=s
    #printf reuses format as necessary to consume all of the arguments
    #thunderbird -compose "subject='$fm_value',body='<- ${#fm_files[*]} attached file(s) ->',attachment='$(IFS=$','; printf "\" %$string format\"" "${fm_files[*]}")'"

# Tab-on-link-target.spacefm plugin
## Tab on link target
    
    # opens new tab on directory of link target
    # not your tab is opened first, then its directory is set;
    # so we have to watch out for paths relative to directory of current tab
    
    target="$(readlink %f)"
    
    if [[ -z ${target} ]]
    then
    target=%d
    else
    if [[ ${target:0:2} == ".." ]]
    then
    target="$(readlink --canonicalize %f)"
    elif [[ ${target:0:1} != "/" ]]
    then
    target=%d/"$target"
    fi
    fi
    
    spacefm --socket-cmd set new_tab "${target%/*}"
    ## wait for new_tab to arrive
    sleep 0.3
    spacefm --socket-cmd set selected_filenames "${target##*/}"
    

# Trash.spacefm plugin
## Trash
    
    # remove arguments if on one of my tmpfs mounts, else trash
    # workaround spacefm parameter %m, cannot be escaped as \%m or %%m
    #
    # requirements [batrash](https://github.com/db-inf/batrash) on your path
    mountpt=$(stat -c %"m" %d) &&
    filesys=$(findmnt --noheadings --output SOURCE "$mountpt") &&
    [ tmpfs = "$filesys" ] &&
    rm --force --recursive %F ||
    batrash %F
    

# URL-from-clipboard.spacefm plugin
## URL from clipboard
    
    url=$(spacefm -s get clipboard_text)
    # escape letters after '%' to disrupt spacefm substitution
    urlfile="new link $(date +%\y%\m%\d_%\Hu%\Mm%\Ss).url"
    echo "[InternetShortcut]" >> "$urlfile"
    echo "URL=$url" >> "$urlfile"
    drag 0.5
    spacefm -s set selected_files "$urlfile" &

# Unmount-archive-on-mediazipmnt.spacefm-plugin
## Unmount archive on /media/zipmnt
    
    fusermount -u %f

# Unmount-mnt-of-cdrom.spacefm-plugin
## Unmount mnt/ or cdrom/
    
    #must match a line in sudoers.d
    sudo umount %f

# Compare-with-Report-pnl-1-3.spacefm-plugin
## Compare with Meld (pnl 1-3)
    
    #compare 2 folders or text files with MELD
    report "${fm_panel1_files[0]}" "${fm_panel3_files[0]}"

# Compare-with-Meld.spacefm-plugin
## Compare with Meld
    
    #compare 2 folders or text files with MELD
    report %F

# Compare-with-WinMerge-wine.spacefm-plugin
## Compare with WinMerge (wine)
    
    #opens WinMerge; playonlinux mount linux root on windows drive letter Z:
    /usr/share/playonlinux/playonlinux --run "WinMerge" /r /x /u "Z:${fm_files[0]}" "Z:${fm_files[1]}"

# Compare-with-diff-varcontext.spacefm-plugin
## Compare with dif_f ☰
    
    #compare 2 text files with diff, with variable number of context lines (via popup question)
    # possibly. extra options:
    # -Z, --ignore-trailing-space
    diff -c$fm_value %F | less
    

# Compare-with-diff-sideby.spacefm-plugin
## Compare with _diff <|>
    
    #compare 2 text files with diff, side by side
    # possibly. extra options:
    # -Z, --ignore-trailing-space
    diff --side-by-side --suppress-common-lines %F | less

# ZipWebBrowser-here.spacefm plugin
## _ZipWebBrowser here
    
    cd ~/Documents/java/ZipWebServer
    if [ -d %f ]
    then
    echo Stop the server with url 127.0.0.3:8080/server?stop
    firefox -new-window 127.0.0.3:8080 &
    java be.arci.zipweb.Server SERVER=127_0_0_3__8080_from_root.properties SERVER_ROOT=%f
    else
    echo Stop the server with url 127.0.0.3:8080/server?stop
    firefox -new-window 127.0.0.3:8080/%N!/ &
    java be.arci.zipweb.Server SERVER=127_0_0_3__8080_from_root.properties SERVER_ROOT=%d
    fi
    

# cp1252---utf-8.spacefm plugin
## cp1252 -> utf-8
    
    #Convert in place from Windows 1252 to UTF-8, with backup to .cp1252 on changes
    /home/dirk/Documents/shellscripts/cp1252-to-utf8.sh %F

# exec-in-Wine-Win7x86PROGS.spacefm plugin
## exec in Wine (Win7x86PROGS)
    
    #runs a Windows .bat, .exe or .com
    /usr/share/playonlinux/playonlinux --run "execute in Win7x86PROGS" %f

# ffprobe.spacefm plugin
## ffprobe
    
    #ffprobe shows properties of film and sound
    # dependencies :
    # - bash : to not have to explicitly keep the terminal open (and then explicitly close it)
    # do I use bash to pipe to less so terminal closes by typing 'q' in less
    # - ffprobe(ffmpeg)
    
    ## version 1 : -H(old) terminal open, close explicitely
    #for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -H -T "ffprobe $i" -e "ffprobe -hide_banner \"$i\"" & done
    
    ## my favourite
    ## version 2 : terminal window per file, use less to hold window open until 'q' typed
    #for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -T "ffprobe $i" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | less\"" & done
    # emphasizing a few details
    for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -T "ffprobe $i" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | grep --colour=always -E -e 'Duration[^[:alpha:]]+' -e '[0-9]+ Hz' -e '[0-9.]+ kb[/p]s' -e 'Stream [^,]+(,|$)' -e ', [0-9]+x[0-9]+( \[.+])?,' -e '^' | less -R\"" & done
    
    ## version 3 : single terminal window with tabs
    #termtabs=()
    #for i in %F
    #do
    # [ ${#termtabs[*]} = 0 ] || termtabs+=(--tab)
    # termtabs+=(-T "\"ffprobe $i\"" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | less\"")
    #done
    #xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar "${termtabs[@]}" &
    
    

# hexdump.spacefm plugin
## he_xdump
    
    ## put an extra space tss in xxd output. 2 blocks of 8 bytes (with possibly.
    ## incomplete last line), and offset also in caps ABCDEF
    echo -ne "\\e]2;hexdump "%n"\\a" & xxd -g 1 -u %f | sed -E 's=^(.{8}):(.{24}) (.{24}) (.{1,16})=\U\1\E\2 \3\4=' | less
    #hexdump -C %f |less
    

# ibm850---utf-8.spacefm-plugin
## ibm850 -> utf-8
    
    #Convert in place from IBM850 to UTF-8, with backup to .ibm850 on changes
    /home/dirk/Documents/shellscripts/ibm850-to-utf8.sh %F

# markdown-browse.spacefm plugin
## markdown browse
    
    md2html %f

# mv--ln----pnl3.spacefm-plugin
## pl && ln --> pnl3
    
    # move selected files to panel 3, and put symlink to it here
    if [[ -n "${fm_pwd_panel[3]}" && "${fm_pwd_panel[3]}" != "${fm_pwd}" ]]
    then
    #run explicitly over all files, to check for success (mv is too coarse)
       for i in %N
       do
    # overwrite "mv" with exit code 0, with or without option -n --no-clobber
    # that's why we test whether target already exists; just to be sure "mv -n"
          if [ ! -e "${fm_pwd_panel[3]}/$i" ] && [ ! -L "${fm_pwd_panel[3]}/$i" ] && mv -n "$i" "${fm_pwd_panel[3]}/"
          then
    # just to be sure no -f --force
             ln -s "${fm_pwd_panel[3]}/${i}"
          else
             echo \"${i}\" already exists in panel 3, or move not OK: check
          fi
       done
    ## wait for spacefm to update
       sleep 0.3
       spacefm --socket-cmd set --panel 3 selected_filenames %N
    # sometimes useful: focus, or focus and selection, back to panel 1 (context: only panel 1)
    # spacefm --socket-cmd set focused_panel 1
       spacefm --socket-cmd set --panel 1 selected_filenames %N
    else
    echo "First open in panel 3 a different destination folder than the folder of this panel"
    fi
    

# sha256sum.spacefm plugin
## sha256sum
    
    #Shows sha256 checksums of selected files in
    #a terminal window
    
    # sort filenames first, to make it easier
    # compare with output from other directory
    
    IFS=$'
    ' A=( $(printf "%s
    " %N|sort) )
    sha256sum "${A[@]}"

# tail-VanDale.spacefm plugin
## tail VanDale
    
    xfce4-terminal --geometry=40x20 --hide-menubar --hide-toolbar -T tail_%n -e "bash -ic 'tail -F %f | grep -E \"^<<<\"'"

# tarxz-HERE.spacefm plugin
## tar.xz HERE
    
    file-roller -a %f.tar.xz %F

# utf-8---cp1252.spacefm plugin
##utf-8 -> cp1252
    
    #Convert in place from UTF-8 to Windows 1252, with backup to .utf8 on changes
    /home/dirk/Documents/shellscripts/utf8-to-cp1252.sh %F

# View-less.spacefm-file-handler
## View (less)
    

# Jbig2-viewer.spacefm-file-handler
## Jbig2 viewer
    

# Open-in-Firefox.spacefm-file-handler
## Open in Firefox
    

# Stafke-cards.spacefm-file-handler
## Staff cards
    

# Stafke-tiled-mapviewer.spacefm-file-handler
## Stafke tiled map viewer
