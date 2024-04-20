@echo off
echo Quickly setting up Miu Engine for compiling...
haxelib setup .\haxelib
haxelib --global install hmm
haxelib --global run hmm install
echo Finished. You may now compile Miu Engine!
echo Press any key to exit.
pause >nul
