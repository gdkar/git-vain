CFLAGS+= $(shell pkg-config --cflags --static openssl)
LDFLAGS+= $(shell pkg-config --libs --static openssl) -lbsd -lm
PREFIX?=/usr/local
git-vain: git-vain.c
	cc $(CFLAGS) git-vain.c -O3 -g $(LDFLAGS) -o git-vain

install: git-vain
	cp git-vain $(PREFIX)/bin

clean:
	rm -f git-vain

