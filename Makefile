CFLAGS+= $(shell pkg-config --static --cflags jemalloc openssl) -pthread -fPIC
LDFLAGS+=  $(shell pkg-config --static --libs jemalloc openssl) -lbsd -lm
PREFIX?=/usr/local
git-vain: git-vain.c
	cc $(CFLAGS) git-vain.c -O3 -g $(LDFLAGS) -o git-vain

install: git-vain
	cp git-vain $(PREFIX)/bin

clean:
	rm -f git-vain

