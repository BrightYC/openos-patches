local shell = require("shell")
local tty = require("tty")
local fs = require("filesystem")
local component = require("component")
local resolutionScale = 1

if tty.isAvailable() then
    if io.stdout.tty then
        local screen, gpu = component.getPrimary("screen"), component.getPrimary("gpu")
        local aspectWidth, aspectHeight, proportion = screen.getAspectRatio()
        local width, height = gpu.maxResolution()
    
        proportion = 2*(16*aspectWidth-4.5)/(16*aspectHeight-4.5)
        if proportion > width / height then
            height = width / proportion
        else
            width = height * proportion
        end

        gpu.setResolution(math.floor(width * resolutionScale), math.floor(height * resolutionScale))
        tty.clear()
    end
end
dofile("/etc/motd")

shell.setAlias("dir", "ls")
shell.setAlias("move", "mv")
shell.setAlias("rename", "mv")
shell.setAlias("copy", "cp")
shell.setAlias("del", "rm")
shell.setAlias("md", "mkdir")
shell.setAlias("cls", "clear")
shell.setAlias("rs", "redstone")
shell.setAlias("view", "edit -r")
shell.setAlias("help", "man")
shell.setAlias("cp", "cp -i")
shell.setAlias("l", "ls -lhp")
shell.setAlias("..", "cd ..")
shell.setAlias("df", "df -h")
shell.setAlias("grep", "grep --color")
shell.setAlias("more", "less --noback")
shell.setAlias("reset", "resolution `cat /dev/components/by-type/gpu/0/maxResolution`")
shell.setAlias("~", "cd $HOME")

os.setenv("EDITOR", "/bin/edit")
os.setenv("HISTSIZE", "10")
os.setenv("HOME", "/home/")
os.setenv("IFS", " ")
os.setenv("MANPATH", "/usr/man:.")
os.setenv("PAGER", "less")
os.setenv("PS1", "\27[32m$HOSTNAME$HOSTNAME_SEPARATOR$PWD\27[37m $ \27[37m")
os.setenv("LS_COLORS", "di=0;36:fi=0:ln=0;33:*.lua=0;32")

shell.setWorkingDirectory(os.getenv("HOME"))

local home_shrc = shell.resolve(".shrc")
if fs.exists(home_shrc) then
    loadfile(shell.resolve("source", "lua"))(home_shrc)
end
