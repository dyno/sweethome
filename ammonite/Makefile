SHELL = /bin/bash

# https://get-coursier.io/docs/cli-launch.html#java-options
define AMM_SCRIPT
#!/bin/bash

command -v scala &>/dev/null || {
  echo "cannot execute scala. is it installed?"
  exit 1
}
scala_version=$$(scala -e "println(util.Properties.versionNumberString)")
amm_version=$${AMMONITE_VERSION:-2.0.1+}

java -Xmx2048m -XX:+UseG1GC $$JAVA_OPTS \
  -jar $$(which coursier) launch com.lihaoyi:ammonite_$${scala_version}:$${amm_version} \
  -M ammonite.Main -- $$@
endef
export AMM_SCRIPT

# https://github.com/lihaoyi/Ammonite/releases
export AMMONITE_VERSION = 2.0.1

export PATH := $(shell pwd)/bin:$(PATH)

.DEFAULT_GOAL: amm
.PHONY: amm
amm: bin/amm
	cd ..                                       \
	&& source scripts/bigdata-env.sh            \
	&& cd -                                     \
	&& source ~/.sdkman/bin/sdkman-init.sh      \
	&& amm  --no-home-predef --predef predef.sc \
	# END

.PHONY: install-ammonite
install-ammonite: bin/amm install-java-scala

bin/amm: bin/coursier
	mkdir -p bin
	echo "$${AMM_SCRIPT}" > bin/amm
	chmod +x bin/amm

bin/coursier:
	@echo "-- install [coursier](https://get-coursier.io/docs/cli-overview.html#installation)"
	mkdir -p bin
	curl -L -o bin/coursier https://git.io/coursier
	chmod +x bin/coursier

# https://spark.apache.org/docs/latest/#downloading
# `spark-shell` will show the scala version, e.g.
# > Using Scala version 2.12.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_232)
# https://www.scala-lang.org/download/all.html
SCALA_VERSION := 2.12.8
# https://api.sdkman.io/2/candidates/java/Darwin/versions/list?installed=
JAVA_VERSION := 8.0.232-amzn

.PHONY: install-java-scala
install-java-scala: install-sdkman
	@echo "-- install java/scala with sdkman"
	@# https://sdkman.io/usage#config
	sed -i .bak-$$(date +'%Y%m%d-%H%M%S') 's/sdkman_auto_answer=false/sdkman_auto_answer=true/' ~/.sdkman/etc/config
	source ~/.sdkman/bin/sdkman-init.sh               \
	  && sdk selfupdate force                         \
	  && (sdk install java $(JAVA_VERSION) || true)   \
	  && (sdk install scala $(SCALA_VERSION) || true) \
	# END

.PHONY: install-sdkman
install-sdkman:
	@echo "-- install [sdkman](https://sdkman.io/install)"
	@# XXX: sdkman is a shell function, and can not be initialized in make env.
	@if [[ ! -d ~/.sdkman ]]; then            \
	  curl -s "https://get.sdkman.io" | bash; \
	fi                                        \
	# END
