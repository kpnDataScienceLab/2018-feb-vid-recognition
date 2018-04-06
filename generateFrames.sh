FPS="$2"
DIRECTORY="$1"
SCALE=""

if [ ! -z $3 ]
  then
    SCALE="scale="$3","
fi

# Remove any JPGs from previous runs.
find "$DIRECTORY" -name '*.jpg' | xargs rm

# Find any MP4s even in sub dirs, and store results in array.
unset a i
while IFS= read -r -d '' file; do
  a[i++]="$file"
done < <(find "$DIRECTORY" -name '*.mp4' -type f -print0)

# itterate over MP4s
for n in "${a[@]}"
do
   :
   FILEPREFIX=$(echo $n | sed 's/.mp4//g')
   
   # create directory for each subdirectories
   mkdir "$FILEPREFIX"
   
   # Generate frames
   ffmpeg -i "$FILEPREFIX".mp4 -y -an -q 0 -vf "$SCALE"fps="$FPS" "$FILEPREFIX"/jpg_%06d.jpg
done
