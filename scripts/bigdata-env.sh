#!/usr/bin/env bash

# =============================================================================
# Setup environment variables for Spark
#
# Usage: source bigdata-env.sh
#
# =============================================================================

# set -o xtrace

function download_and_extract() {
  local download_url=$1
  local tarball=$2

  pushd ${HOME_LOCAL}
  echo "Download and extract ${tarball} from ${download_url}"
  [[ -f ${tarball} ]] || curl -L -O ${download_url}
  tar xf ${tarball}
  popd
}

SPARK_VERSION=2.4.4
# XXX: bump hadoop version for local s3 support
HADOOP_VERSION=3.2.1

# -----------------------------------------------------------------------------
HOME_LOCAL=${HOME_LOCAL:-${HOME}/local}
mkdir -p ${HOME_LOCAL}

# ## Hadoop ##
HADOOP_BASE=hadoop-${HADOOP_VERSION}
HADOOP_HOME=${HOME_LOCAL}/${HADOOP_BASE}
HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
if ! grep -q ":${HADOOP_HOME}/bin:" <<<${PATH}; then
  PATH=${HADOOP_HOME}/bin:${PATH}
fi

if [[ ! -d ${HADOOP_HOME} ]]; then
  HADOOP_TARBALL=${HADOOP_BASE}.tar.gz
  # http://archive.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
  HADOOP_DOWNLOAD_URL=http://archive.apache.org/dist/hadoop/common/${HADOOP_BASE}/${HADOOP_TARBALL}
  download_and_extract ${HADOOP_DOWNLOAD_URL} ${HADOOP_TARBALL}
fi

export HADOOP_HOME HADOOP_CONF_DIR

# ## Spark ##
# http://spark.apache.org/docs/latest/hadoop-provided.html
# https://issues.apache.org/jira/browse/HADOOP-12537, S3A to support Amazon STS temporary credentials
# XXX: we need spark without hadoop because spark 2.4.0 bundled hadoop 2.7.3 does not support STS.
SPARK_BASE=spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12
SPARK_HOME=${HOME_LOCAL}/${SPARK_BASE}
SPARK_CONF_DIR=${SPARK_HOME}/conf
SPARK_CONF_DEFAULTS=${SPARK_CONF_DIR}/spark-defaults.conf
if ! grep -q ":${SPARK_HOME}/bin:" <<<${PATH}; then
  PATH=${SPARK_HOME}/bin:${PATH}
fi

if [[ ! -d ${SPARK_HOME} ]]; then
  SPARK_TARBALL=${SPARK_BASE}.tgz
  SPARK_DOWNLOAD_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_TARBALL}
  download_and_extract ${SPARK_DOWNLOAD_URL} ${SPARK_TARBALL}
fi

# enable spark to use hadoop/hdfs to access s3
# https://hadoop.apache.org/docs/current/hadoop-aws/tools/hadoop-aws/index.html
SPARK_DIST_CLASSPATH=$(hadoop --config ${HADOOP_CONF_DIR} classpath)
if ! grep -q aws <<<${SPARK_DIST_CLASSPATH}; then
  # https://hadoop.apache.org/docs/r3.1.1/hadoop-project-dist/hadoop-common/UnixShellAPI.html
  ADD_HADOOP_AWS_LIB="hadoop_add_to_classpath_tools hadoop-aws"
  if [[ ! -f ~/.hadooprc ]] || ! (grep -qF "${ADD_HADOOP_AWS_LIB}" ~/.hadooprc); then
    echo ${ADD_HADOOP_AWS_LIB} >>~/.hadooprc
  fi
  SPARK_DIST_CLASSPATH=$(hadoop --config ${HADOOP_CONF_DIR} classpath)
fi

# leverage environment provided authentication mechanism
[[ -f scripts/conf/core-site.xml ]] && cp -f scripts/conf/core-site.xml ${HADOOP_HOME}/etc/hadoop || true
# configure spark executor memory etc
[[ -f scripts/conf/spark-defaults.conf ]] && cp -f scripts/conf/spark-defaults.conf ${SPARK_CONF_DIR} || true
# for local spark history server.
mkdir -p /tmp/spark-events/

export SPARK_HOME SPARK_CONF_DIR SPARK_DIST_CLASSPATH SPARK_CONF_DEFAULTS
