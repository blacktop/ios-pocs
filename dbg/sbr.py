#!/usr/bin/python
#coding:utf-8

import lldb
# import commands
import optparse
import shlex
import re


def get_ASLR():
    interpreter = lldb.debugger.GetCommandInterpreter()
    returnObject = lldb.SBCommandReturnObject()
    interpreter.HandleCommand('image list -o', returnObject)
    output = returnObject.GetOutput();
    match = re.match(r'.+(0x[0-9a-fA-F]+)', output)
    if match:
        return match.group(1)
    else:
        return None

# Super breakpoint
def sbr(debugger, command, result, internal_dict):

    # Whether the user has entered an address parameter
    if not command:
        print >>result, 'Please input the address!'
        return

    ASLR = get_ASLR()
    if ASLR:
        # If ASLR offset is found, set a breakpoint
        debugger.HandleCommand('br set -a "%s+%s"' % (ASLR, command))
    else:
        print >>result, 'ASLR not found!'

def readReg(debugger, register, result, internal_dict):
    interpreter = lldb.debugger.GetCommandInterpreter()
    returnObject = lldb.SBCommandReturnObject()
    debugger.HandleCommand('register read ' + register, returnObject)
    output = returnObject.GetOutput()
    match = re.match(' = 0x(.*)', output)
    if match:
        print(match.group(1))
    else:
        print("error: " + output)

def readMem(debugger, address, result, internal_dict):
    debugger.HandleCommand('memory read --size 4 --format x --count 32 ' + address)
    
def connLocal(debugger, address, result, internal_dict):
    debugger.HandleCommand('platform select remote-ios')
    debugger.HandleCommand('process connect connect://localhost:2008')

# And the initialization code to add your commands 
def __lldb_init_module(debugger, internal_dict):
    # 'command script add sbr' : 给lldb增加一个'sbr'命令
    # '-f sbr.sbr' : 该命令调用了sbr文件的sbr函数
    debugger.HandleCommand('command script add sbr -f sbr.sbr')
    debugger.HandleCommand('command script add readReg -f sbr.readReg')
    debugger.HandleCommand('command script add connLocal -f sbr.connLocal')
    debugger.HandleCommand('command script add readMem -f sbr.readMem')
    print('The "sbr" python command has been installed and is ready for use.')
