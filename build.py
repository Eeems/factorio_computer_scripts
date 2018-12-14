from __future__ import print_function

import subprocess
import json
import sys
import os


def addFiles(dirPath, ignore=[]):
    lines = []
    for name in os.listdir(dirPath):
        path = '{0}/{1}'.format(dirPath, name)
        if path in ignore:
            pass

        elif os.path.isfile(path):
            print("Adding {}...".format(path), end='')
            try:
                if sys.argv[-1] == '--prod':
                    lua = subprocess.check_output([
                        r'C:\Users\Eeems\AppData\Roaming\npm\luamin', '-f', path],
                        shell=True)

                else:
                    subprocess.check_output([
                        r'C:\Users\Eeems\AppData\Roaming\npm\luaparse', '-f', path],
                        shell=True)
                    with open(path, 'r') as f:
                        lua = f.read()

            except subprocess.CalledProcessError as e:
                print('FAIL')
                raise Exception(e.output)

            lines.append(
                "disk.writeFile('/{0}', {1})\n".format(path[4:], json.dumps(lua)))
            print('OK')

        else:
            lines += addFiles(path, ignore)

    return lines


def Main():
    if not os.path.exists('src/install.lua'):
        raise Exception("src/install.lua missing")

    if not os.path.exists('dist'):
        os.makedirs('dist')

    if not os.path.exists('build'):
        os.makedirs('build')

    lines = ["term.write('Installing...')\n"] + \
        addFiles('src', ['src/install.lua', 'src/lib/shim.lua'])

    print('Adding src/install.lua...', end='')
    try:
        subprocess.check_output([
            r'C:\Users\Eeems\AppData\Roaming\npm\luaparse', '-f', 'src/install.lua'],
            shell=True)
    except subprocess.CalledProcessError as e:
        print('FAIL')
        raise Exception(e.output)

    with open('src/install.lua', 'r') as f:
        lines = lines + list(f)

    print('OK')
    print("Building...", end='')
    with open('build/install.lua', 'w') as f:
        f.writelines(lines)

    with open('dist/install.lua', 'w') as f:
        try:
            lua = subprocess.check_output([
                r'C:\Users\Eeems\AppData\Roaming\npm\luamin', '-f',
                'build/install.lua'], shell=True)
            f.write(lua)
        except subprocess.CalledProcessError as e:
            print('FAIL')
            raise Exception(e.output)

    print('OK')


if __name__ == "__main__":
    Main()
