BUILD_DIR = ./build

KERNELS = kernels/hello_world_mc.s
OBJ_FILES = $(patsubst kernels/%.s, $(BUILD_DIR)/%.o, $(KERNELS))

hello_world_stuff: $(OBJ_FILES) driver_hello_world.cpp
	g++ -pedantic -Wall -Wextra -Werror -O2 $^ -o $(BUILD_DIR)/hello_world_mc

$(BUILD_DIR)/%.o: kernels/%.s
	as -o $@ $<

all: hello_world

$(shell mkdir -p $(BUILD_DIR))