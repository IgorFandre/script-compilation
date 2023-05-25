COMPILERS=()
EXTENSIONS=()
((LENGTH=0))
ARCHIEVE_PATH="$PWD"
PROJECT_PATH=""
ARCHIEVE_DIR=""

while [[ $# -gt 0 ]];
do
  case $1 in
    -s|--source)
      PROJECT_PATH="$2"
      ;;
    -a|--archive)
      ARCHIEVE_DIR="$2"
      ;;
    -c|--compiler)
      PARSE="$2"
      PARSE_LEN=${#PARSE}
      CUR_TEXT=""
      ((ITER=0))
      for ((i=1; i <= PARSE_LEN; i++))
      do
        CHAR=${PARSE:i-1:1}
        if [[ "$CHAR" != "=" ]];
        then
          CUR_TEXT+="$CHAR"
        else
          EXTENSIONS+=( "$CUR_TEXT" )
          ((ITER++))
          ((LENGTH++))
          CUR_TEXT=""
        fi
      done
      for ((i=1; i <= ITER; i++))
      do
        COMPILERS+=( "$CUR_TEXT" )
      done
      ;;

    *)
      echo "Unexpected parameters. Process killed"
      exit 1
      ;;
  esac
  shift
  shift
done

ARCHIEVE_FILES=()
ARCHIEVE_DIR_PATH="${PROJECT_PATH}/archieve_directory/${ARCHIEVE_DIR}"
mkdir -p "${ARCHIEVE_DIR_PATH}"

for ((ext_num=0; ext_num < LENGTH; ext_num++))
do
  find "$PROJECT_PATH" -name "*.${EXTENSIONS[ext_num]}" -print0 >tmpfile.txt
  (( WAS=0 ))
  while IFS=  read -r -d $'\0';
  do
    (( WAS=1 ))
    dirname "${REPLY}" >dirname.txt
    cut -b $(( ${#PROJECT_PATH}+1 ))- dirname.txt >filepath.txt
    DIR="${ARCHIEVE_DIR_PATH}$(head -n 1 filepath.txt)"
    FILENAME=$(basename -- "$REPLY")
    FILE="${FILENAME%.*}"
    mkdir -p "${DIR}"
    ARCHIEVE_FILES+=( "./${ARCHIEVE_DIR}$(head -n 1 filepath.txt)/${FILE}.exe" )
    ${COMPILERS[ext_num]} -o "${DIR}"/"${FILE}".exe "${REPLY}"
  done <tmpfile.txt
  rm tmpfile.txt
  if (( WAS == 1 ));
  then
     rm filepath.txt dirname.txt
  fi
done

cd "${PROJECT_PATH}/archieve_directory" || return
tar -czf "${ARCHIEVE_PATH}/${ARCHIEVE_DIR}.tar.gz" "${ARCHIEVE_FILES[@]}"
rm -r "${ARCHIEVE_DIR_PATH}"

echo "complete"

