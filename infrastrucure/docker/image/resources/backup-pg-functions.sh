function init-role-repo() {
  restic -r ${RESTIC_REPOSITORY}/pg-role -v init
}
