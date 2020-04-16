CC=clang
ARCH=arm64
IOS=13.4

all: build sign proxy push

.PHONY: build
build:
	$(CC) -g -arch $(ARCH) -mios-version-min=$(IOS) -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/ -o slide main.c

.PHONY: sign
sign:
	ARCH=$(ARCH) jtool --sign --ent platform-application.xml --inplace slide

.PHONY: push
push:
	ssh -p 2222 -t root@localhost 'rm /bin/slide' || true
	scp -P 2222 slide root@localhost:/bin/slide
	ssh -p 2222 -t root@localhost 'chown root:admin /bin/slide'
	ssh -p 2222 -t root@localhost '/bin/slide'
	# ssh -p 2222 -t root@localhost '/Developer/usr/bin/debugserver localhost:6666 --waitfor slide &'

.PHONY: proxy
proxy:
	iproxy 6666 6666 &

clean:
	rm -rf slide*
