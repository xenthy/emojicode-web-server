ifeq ($(OS),Windows_NT)
	CC=emojicodec
else
	CC=emojicodec
endif

TARGET?=src/main.emojic
OUT?=main

FLAGS?= --color

SOURCES = $(shell find src/ -type f -name '*.emojic')

.PHONY: all check docker dockerclean clean

all:
	$(CC) $(FLAGS) $(TARGET) && ./src/$(OUT)

check:
	$(CC) $(FLAGS) $(TARGET) && ./src/$(OUT)

docker:
	docker build -t ict2206:latest .
	docker run -ti ict2206

dockerclean:
	docker system prune -a

clean:
ifeq ($(OS),Windows_NT)
	@powershell "(Get-ChildItem * -Include $(OUT) -Recurse | Remove-Item)"
	@powershell "(Get-ChildItem * -Include *.o -Recurse | Remove-Item)"
	@echo Cleaned up ./src/main & *.o files
else
	@echo "Cleaning up [.pyc, __pycache__, apktool/, junk apk] files..."
	@find ./src -type f -name "$(OUT)" -exec rm -f {} +
	@find . -type f -name "*.o" -exec rm -f {} +
	@find . -type f -name "*.emojic_original" -exec rm -f {} +
endif
