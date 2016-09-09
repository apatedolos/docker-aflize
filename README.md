# Docker-aflize

Inspired by work from Jacek Wielemborek, Michal Zalewski and Ben Nagy

Git sourced docker build based on ubuntu trusty that installs all dependancies for the following:

- afl
 - qemu mode
 - llvm mode
- Crashwalk with triage using exploitable.py
- aflize

I have also included some simple bash scripts for the following:

- start/resume single master and multiple slaves from cmd args
- loop through files and invoke afl-tmin against corpus reduced files from afl-cmin
