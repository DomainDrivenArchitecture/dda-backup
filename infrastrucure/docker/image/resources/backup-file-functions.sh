function init-file-repo() {
  restic -r ${RESTIC_REPOSITORY}/files -v init
}
