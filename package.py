name = 'studiolibrary'

version = '2.19.0.hh.1.0.2'

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


def post_commands():

    # NOTE: use built-in getenv to get env variables being defined during rez env process
    proj_code = getenv("HH_PROJ_CODE")
    projs_root = getenv(f"{proj_code}_HH_PROJS_ROOT_LINUX")

    import os
    proj_root = os.path.join(projs_root, proj_code)
    proj_configs = os.path.join(proj_root, "configs")
    proj_libraries = os.path.join(proj_root, "libraries")

    # -------------------------------------------------------
    # StudioLibrary
    studiolib_config = os.path.join(proj_configs, "studioLibrary", "config.json")
    studiolib_db = os.path.join(proj_libraries, "studioLibrary", "database.json")
    studiolib_meta = os.path.join(proj_libraries, "studioLibrary", "metadata.json")

    env.STUDIO_LIBRARY_CONFIG_PATH = studiolib_config
    env.STUDIO_LIBRARY_DB_PATH = studiolib_db
    env.STUDIO_LIBRARY_META_PATH = studiolib_meta


build_command = 'rez python {root}/rez_build.py'
uuid = 'repository.studiolibrary'
