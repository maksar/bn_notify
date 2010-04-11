@echo off
set SUBDIR=%~dp0
ruby -rubygems %SUBDIR%bn.rb #LOGIN# #PASSWORD# %SUBDIR%bn.png
