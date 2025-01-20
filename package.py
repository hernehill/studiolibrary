name = 'studiolibrary'

version = '2.14.1.hh.1.0.0'

authors = [
    'Kurt Rathjen',
]

description = '''Animation pose library'''

with scope('config') as c:
    import os
    c.release_packages_path = os.environ['HH_REZ_REPO_RELEASE_EXT']

requires = [
]

private_build_requires = [
]

variants = [
]

def commands():
    env.REZ_STUDIOLIBRARY_ROOT = '{root}'
    env.PATH.append('{root}/bin')
    env.PYTHONPATH.append('{root}/src/python')
    # env.STUDIO_LIBRARY_CONFIG_PATH = ""


build_command = 'rez python {root}/rez_build.py'
uuid = 'repository.studiolibrary'
