#
# Build extractor tool then run it. Convert output and combine. Upload to S3
#

MVN_CMD = mvn
GIT_CMD = git
JAVA_CMD = java
JAVA_OPTS = -Xms512M -Xmx512M

content: source update build dirs extract

source: avalon-in-virgo-indexer archivesspace-virgo

avalon-in-virgo-indexer:
	$(GIT_CMD) clone https://github.com/uvalib/avalon-in-virgo-indexer.git
 
archivesspace-virgo:
	$(GIT_CMD) clone https://github.com/uvalib/archivesspace-virgo.git

update:
	cd avalon-in-virgo-indexer; $(GIT_CMD) pull
	cd archivesspace-virgo; $(GIT_CMD) pull

build: avalon-in-virgo-indexer archivesspace-virgo
	cd avalon-in-virgo-indexer; $(MVN_CMD) clean install dependency:copy-dependencies -DskipTests
	cd archivesspace-virgo; $(MVN_CMD) clean install dependency:copy-dependencies -DskipTests

dirs:
	mkdir -p results/index
	mkdir -p results/logs

extract:
	cp config/indexer.properties config.properties
	-rm index-generation.log
	$(JAVA_CMD) $(JAVA_OPTS) -cp avalon-in-virgo-indexer/target/indexer-1.0-SNAPSHOT.jar:avalon-in-virgo-indexer/target/dependency/* edu.virginia.lib.avalon.indexer.AvalonIndexer config.properties

upload-staging:
	$(JAVA_CMD) $(JAVA_OPTS) -cp archivesspace-virgo/target/as-to-virgo-1.0-SNAPSHOT.jar:archivesspace-virgo/target/dependency/* edu.virginia.lib.indexing.tools.IndexRecordsForV4 config/upload-staging.properties

upload-production:
	$(JAVA_CMD) $(JAVA_OPTS) -cp archivesspace-virgo/target/as-to-virgo-1.0-SNAPSHOT.jar:archivesspace-virgo/target/dependency/* edu.virginia.lib.indexing.tools.IndexRecordsForV4 config/upload-production.properties

#
# end of file
#
