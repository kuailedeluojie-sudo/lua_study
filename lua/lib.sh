gcc -g -o lib$1.so -fpic -shared $1.c
export LD_LIBRARY_PATH=:/home/mo/lua_study/lua
