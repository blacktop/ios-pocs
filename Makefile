CC=clang
ARCH=arm64
IOS=11.2

all: build sign proxy push

.PHONY: build
build:
	$(CC) -g -arch $(ARCH) -mios-version-min=$(IOS) -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/ -o evil main.c

.PHONY: sign
sign:
	ARCH=$(ARCH) jtool --sign --ent platform-application.xml --inplace evil

.PHONY: push
push:
	ssh -p 2222 -t root@localhost 'rm /bin/evil' || true
	scp -P 2222 evil root@localhost:/bin/evil
	ssh -p 2222 -t root@localhost 'chown root:admin /bin/evil'
	ssh -p 2222 -t root@localhost '/bin/evil'
	# ssh -p 2222 -t root@localhost '/Developer/usr/bin/debugserver localhost:6666 --waitfor evil &'

.PHONY: proxy
proxy:
	iproxy 6666 6666 &

clean:
	rm -rf evil*
