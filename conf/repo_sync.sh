#################################################
# Title      : Reposync                         #
# Date       : 2016.11.03                       #
# Maintainer : Yongbok Kim (ruo91@yongbok.net)  #
#################################################
#!/bin/bash
REPO_DIR="/opt"
REPO_VER="rhel-$(cat /etc/redhat-release | awk '{print $7}' | cut -d '.' -f '1')"
REPO_LIST="$REPO_VER-server-rpms $REPO_VER-server-extras-rpms $REPO_VER-server-optional-rpms $REPO_VER-server-rh-common-rpms"

function f_reposync {
  for repos in ${REPO_LIST}; do
      if [[ -d "$REPO_DIR/$repos" ]]; then
          echo "Repo sync..."
          reposync --downloadcomps --download-metadata --newest-only -r $repos $REPO_DIR
          cd $REPO_DIR/$repos && createrepo .
          echo "Done"

      else
          echo "Repo sync..."
          reposync --downloadcomps --download-metadata -r $repos $REPO_DIR
          cd $REPO_DIR/$repos && createrepo .
          echo "Done"
      fi
  done
}

function f_help {
  echo "Usage: $ARG_0 [Options]"
  echo
  echo "- Options"
  echo "y, yes"
  echo "n, no"
  echo
}

# Main
ARG_0="$0"
ARG_1="$1"

case ${ARG_1} in
    y|Y|yes|YES)
        f_reposync
    ;;

    n|N|no|NO)
        exit 0
    ;;

    *)
        f_help
    ;;
esac

