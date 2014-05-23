TARGETS = auth commands
test: packages
		go test -v ./...

packages:
	go get code.google.com/p/go.tools/cmd/cover
	go get github.com/axw/gocov/gocov
	go get gopkg.in/matm/v1/gocov-html
	go get github.com/mattn/goveralls
	go get github.com/modocache/gover

cover: packages
	rm -rf *.out
	rm -rf cover*
	touch cover.json
	@for t in $(TARGETS); \
	do \
		gocov test github.com/Shaked/getpocket/$$t/ -v >> cover_$$t.json; \
		gocov-html cover_$$t.json >> cover_$$t.html; \
	done;

travis:
	rm -rf gover.coverprofile
	@for t in $(TARGETS); \
	do \
		go test -covermode=count -coverprofile=profile.cov github.com/Shaked/getpocket/$$t/; \
	done;
	gover 
	goveralls -repotoken 4aRDhgifgmEKSiBfuUvQa4whjauFFlkc2 -coverprofile=gover.coverprofile -service travis-ci
