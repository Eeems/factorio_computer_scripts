import subprocess
import json
import sys
import os


def addFiles(dirPath):
    lines = []
    dirPath = "src/{}".format(dirPath)
    for name in os.listdir(dirPath):
        path = '{0}/{1}'.format(dirPath, name)
        if sys.argv[-1] == '--prod':
            lua = subprocess.check_output([
                r'C:\Users\Eeems\AppData\Roaming\npm\luamin', '-f', path],
                shell=True)

        else:
            try:
                subprocess.check_output([
                    r'C:\Users\Eeems\AppData\Roaming\npm\luaparse', '-f', path],
                    shell=True)
            except subprocess.CalledProcessError as e:
                raise Exception(e.output)

            with open(path, 'r') as f:
                lua = f.read()

        lines.append(
            "disk.writeFile('/{0}', {1})\n".format(path[4:], json.dumps(lua)))

    return lines


def Main():
    if not os.path.exists('src/install.lua'):
        raise Exception("src/install.lua missing")

    if not os.path.exists('dist'):
        os.makedirs('dist')

    if not os.path.exists('build'):
        os.makedirs('build')

    lines = ["term.write('Installing...')\n"] + addFiles('lib') + \
        addFiles('factory') + addFiles('mine') + addFiles('wrist') + addFiles('car')

    with open('src/install.lua', 'r') as f:
        lines = lines + list(f)

    with open('build/install.lua', 'w') as f:
        f.writelines(lines)

    with open('dist/install.lua', 'w') as f:
        lua = subprocess.check_output([
            r'C:\Users\Eeems\AppData\Roaming\npm\luamin', '-f', 'build/install.lua'],
            shell=True)
        f.write(lua)


if __name__ == "__main__":
    Main()
