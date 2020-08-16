BIN += PoiEngine

SRC += $(wildcard src/*.cpp)
SRC += $(wildcard src/*/*.cpp)
SRC += $(wildcard src/*/*/*.cpp)
SRC += $(wildcard src/*/*/*/*.cpp)
SRC += $(wildcard src/*/*/*/*/*.cpp)

INC += -I src/

FLG += -std=c++17 -O2
LIB += -lm

OBJ += $(SRC:.cpp=.o)
DEP += $(SRC:.cpp=.d)

ifeq ($(OS),Windows_NT) 
    detected_OS = Windows
else
    detected_OS = $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

ifeq ($(detected_OS),Windows)
	FLG += -D OS_WINDOWS
	EXT += .exe
	INC += -I __External/win32/glfw/include/
	LIB += -L __External/win32/glfw/lib-mingw-w64 -lglfw3dll
endif
ifeq ($(detected_OS),Linux)
	FLG += -D OS_LINUX
	EXT += .out
endif
ifeq ($(detected_OS),Darwin)
	FLG += -D OS_OSX
	EXT += .out
endif

all: $(BIN)

-include $(DEP)

%.o: %.cpp
	@g++ $(FLG) -MMD -MP -c $< -o $@ $(INC)

$(BIN): $(OBJ)
	@g++ $(FLG) -o $(BIN)$(EXT) $(OBJ) $(LIB) $(FRM)

clean:
	@rm -f $(OBJ)
	@rm -f $(DEP)

binclean:
	@rm -f $(BIN)$(EXT)

fclean: clean binclean