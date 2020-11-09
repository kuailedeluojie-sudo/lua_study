#把C文件编译成一个库文件，然后在lua里面调用它
gcc -g -o lib$1.so -fpic -lSDL2 -shared -static $1.c
#gcc -g -o lib$1.so -fpic -lSDL2 -shared $1.c
export LD_LIBRARY_PATH=:/home/mo/lua_study/lua
