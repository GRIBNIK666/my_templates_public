#bash.sh
##grep lines by range from 'LINE_FROM' and including 'LINE_TO'
awk '/line_from/,/line_to/'
##replace string in file
sed 's/<old_val>/<new_val>/g' /path/file
