#!/usr/bin/env python2

##############################################################################
#   CEGUI auto docs builder
#
#   Copyright (C) 2014   Martin Preisler <martin@preisler.me>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
##############################################################################

# I would have preferred a bash script or a Makefile but to potentially
# allow Windows folks to use this as well I have chosen python in the end

import sys
import os
import argparse
import subprocess
import shutil


def get_temporary_directory_path():
    temp_directory_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "local-temp")
    )

    if not os.path.exists(temp_directory_path):
        os.mkdir(temp_directory_path)

    return temp_directory_path


def parse_cegui_branch(branch):
    if branch[0] != "v":
        raise RuntimeError("'%s' is not a valid CEGUI version branch/tag! 'v' is not the first character." % (branch))

    branch = branch[1:]
    split = branch.split("-")

    if len(split) != 3:
        raise RuntimeError("'%s' doesn't have 3 version components, instead if has %i components!" % (branch, len(split)))

    return (split[0], split[1], split[2])


def build():
    old_cwd = os.getcwd()

    try:
        temp_directory_path = get_temporary_directory_path()
        os.chdir(temp_directory_path)

        print("*** Making sure the cegui repository is up to date...")
        if os.path.exists("cegui"):
            os.chdir("cegui")
            subprocess.check_call(["hg", "pull"])
            os.chdir(temp_directory_path)
        else:
            subprocess.check_call(["hg", "clone",
                                   "http://bitbucket.org/cegui/cegui",
                                   "cegui"])

        print("*** cegui is up to date now!")

        def build_api_docs(branch, target_path):
            ver_major, ver_minor, ver_patch = parse_cegui_branch(branch)
            ver_major = int(ver_major)
            ver_minor = int(ver_minor)
            ver_patch = int(ver_patch)

            os.chdir(os.path.join(temp_directory_path, "cegui"))

            print("*** Preparing build API docs from the '%s' branch and copy them to '%s'" % (branch, target_path))
            subprocess.check_call(["hg", "update", "-C", branch])

            if os.path.exists(target_path):
                print("*** The path already exists, deleting the whole tree ('%s')..." % (target_path))
                shutil.rmtree(target_path)

            result_doxygen_path = None

            if (ver_major, ver_minor, ver_patch) >= (0, 8, 0):
                build_dir = os.path.join(temp_directory_path, "cegui", "build")

                if os.path.exists(build_dir):
                    shutil.rmtree(build_dir)

                os.mkdir(build_dir)
                os.chdir(build_dir)

                subprocess.check_call(["cmake", "../"])
                subprocess.check_call(["make", "html"])

                result_doxygen_path = os.path.join(build_dir, "doc", "doxygen", "html")

            elif (ver_major, ver_minor, ver_patch) >= (0, 7, 0):
                os.chdir(os.path.join(temp_directory_path, "cegui", "doc", "doxygen"))
                subprocess.check_call(["doxygen", "doxyfile"])
                result_doxygen_path = os.path.join(temp_directory_path, "cegui", "doc", "doxygen", "html")

            elif (ver_major, ver_minor, ver_patch) >= (0, 6, 0):
                os.chdir(os.path.join(temp_directory_path, "cegui"))
                subprocess.check_call(["doxygen", "doxyfile"])
                result_doxygen_path = os.path.join(temp_directory_path, "cegui", "documentation", "api_reference")

            print("*** Copying docs to '%s'" % (target_path))
            shutil.copytree(result_doxygen_path, target_path, ignore = shutil.ignore_patterns(".hg"))
            print("*** API docs from branch '%s' are up to date in '%s'!" % (branch, target_dir))

        os.chdir(os.path.join(temp_directory_path, "cegui"))
        # actually it's tags, but whatever, it's all the same
        branches_output = subprocess.check_output(["hg", "tags"]).split("\n")

        for branch_line in branches_output:
            try:
                branch, commit = branch_line.split(" ", 1)

                if branch == "tip":
                    continue

                ver_major, ver_minor, ver_patch = parse_cegui_branch(branch)
                rel_dir = "%s.%s.%s" % (ver_major, ver_minor, ver_patch)
                target_dir = os.path.join(temp_directory_path, "output", rel_dir)

                build_api_docs(branch, target_dir)

                os.chdir(os.path.join(temp_directory_path, "output"))
                subprocess.check_call(["zip", "-r", "%s.%s.%s.zip" % (ver_major, ver_minor, ver_patch), rel_dir])

            except:
                print("Can't build docs for branch '%s', it likely isn't a version branch..." % (branch))

    finally:
        os.chdir(old_cwd)


def clean():
    temp_directory_path = get_temporary_directory_path()
    shutil.rmtree(temp_directory_path)

    print("*** No local temporary directory present now!")


def main():
    parser = argparse.ArgumentParser(description = "CEGUI auto docs builder")

    parser.add_argument(
        "task", type = str, default = "build",
        help = "Which task do you want to perform? (choices: build, clean)"
    )

    args = parser.parse_args()

    if args.task == "build":
        build()

    elif args.task == "clean":
        clean()

    else:
        print("*** No valid task provided")
        sys.exit(1)


if __name__ == "__main__":
    main()
