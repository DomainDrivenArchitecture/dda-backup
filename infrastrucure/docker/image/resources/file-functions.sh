function init-file-repo() {
  restic -r ${RESTIC_REPOSITORY}/files -v init
}


function backup-directory() {
  local directory="$1"; shift

  restic -v -r ${RESTIC_REPOSITORY}/files unlock --cleanup-cache

  cd ${directory} && restic -v -r ${RESTIC_REPOSITORY}/files backup .

  restic -v -r ${RESTIC_REPOSITORY}/files forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune
}

function restore-directory() {
  local directory="$1"; shift

  restic -v -r ${RESTIC_REPOSITORY}/files unlock --cleanup-cache

  rm -rf ${directory}*
  restic -v -r $RESTIC_REPOSITORY/files restore latest --target ${directory}
}