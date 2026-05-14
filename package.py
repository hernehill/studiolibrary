name = 'studiolibrary'

version = '2.21.2.hh.1.0.5'

authors = [
    'Kurt Rathjen',
]

description = '''Animation pose library'''

with scope('config') as c:
    import os
    c.release_packages_path = os.environ['HH_REZ_REPO_RELEASE_EXT']

requires = [
    "maya",
]

private_build_requires = [
]

variants = [
]

def commands():
    env.REZ_STUDIOLIBRARY_ROOT = '{root}'
    env.PYTHONPATH.append('{root}/src')


build_command = 'rez python {root}/rez_build.py'
uuid = 'repository.studiolibrary'
