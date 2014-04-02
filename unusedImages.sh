PROJ_DIR_TO_IGNORE=$(find * -type d -name '*.xcodeproj')

for i in `find . -name "*.png" -o -name "*.jpg"`; do 
    file=`basename -s .jpg "$i" | xargs basename -s .png | xargs basename -s @2x`
    
    result=`ack -i --ignore-dir=$PROJ_DIR_TO_IGNORE "$file"`
    if [ -z "$result" ]; then
        echo "$i"
    fi
done