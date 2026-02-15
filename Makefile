BINARY  := deploy
CMD     := ./cmd/deploy
LDFLAGS := -s -w

.PHONY: build run clean

build:
	go build -ldflags="$(LDFLAGS)" -o $(BINARY) $(CMD)

run:
	go run $(CMD)

clean:
	rm -f $(BINARY)
