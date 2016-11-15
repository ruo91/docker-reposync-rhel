#
# Dockerfile - RepoSync RHEL
#
# - Build
# docker build --rm -t rhel7:reposync -f rhel7.x .
#
# - Run
# docker run -d --name="rhel7-reposync" -h "rhel7-reposync" -v /path/to/host/directory:/path/to/container/directory rhel7:reposync
#
# Use the base images
FROM ruo91/rhel:72
MAINTAINER Yongbok Kim <ruo91@yongbok.net>

# Subscription
ENV RHNID 'Change_Your_RHNID'
ENV RHNPW 'Change_Your_RHNPW'
RUN subscription-manager register \
 --auto-attach --username="$RHNID" --password="$RHNPW" --name="docker_repo" \
 && subscription-manager repos --disable='*' \
 && subscription-manager repos \
 --enable=rhel-7-server-rpms \
 --enable=rhel-7-server-extras-rpms \
 --enable=rhel-7-server-optional-rpms \
 --enable=rhel-7-server-rh-common-rpms \
 && yum repolist
 
# The install package for reposync
RUN rpm --rebuilddb && yum install -y yum-utils createrepo

# Variable
ENV SRC_DIR /opt
WORKDIR $SRC_DIR

# Add scripts
ADD conf/repo_sync.sh /bin/repo_sync.sh
RUN sed -i '/^repo_dir=/ s:.*:repo_dir=\"$SRC_DIR\":' /bin/repo_sync.sh
RUN chmod a+x /bin/repo_sync.sh

# repo sync
CMD ["/bin/bash", "/bin/repo_sync.sh", "y"]

