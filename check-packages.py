#!/bin/python

import subprocess
import re

p = subprocess.Popen(
    ['pacman', '-Qet'],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE
)

out, err = p.communicate()
package_list = str(out)

# List of all installed packages
packages = { x.split()[0] for x in package_list.split("\\n")[:-1] if not "'" in x  }


with open('initialize.sh') as f:
    script = f.readlines()

with open('root_initialize.sh') as f:
    script += f.readlines()


script = { x for y in
           [ x.split()
             for x in script
             if re.match("((sudo )?pacman -S.*)|(yaourt -S.*)", x)
           ] for x in y
           if not any( s in x for s in ('--', 'sudo', 'pacman', '-S')) }

for e in sorted(packages - script):
    print(e)
