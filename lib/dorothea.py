#!/usr/bin/env python

"""
.. See the NOTICE file distributed with this work for additional information
   regarding copyright ownership.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""
import subprocess
import tarfile

from utils import logger


class Dorothea:
    """
    This is a class for Dorothea module.
    """
    test_mode = True  # If True local test is on, False otherwise

    @staticmethod
    def execute_dorothea_rscript(input_csv_path, arguments, input_r_script_path):
        """
        Execute dorothea.

        :param input_csv_path: Path of input CWV file
        :type input_csv_path: str
        :param arguments: Dict containing tool arguments
        :type arguments: dict
        :param input_r_script_path: Path of R script file
        :type input_r_script_path: str
        """
        logger.debug("Starting dorothea execution")
        args_list = list(arguments.values())

        cmd = [
            '/usr/bin/Rscript',
            '--vanilla', input_r_script_path, input_csv_path,
            args_list[3],
            str(args_list[4]),
            str(args_list[5])
        ]

        process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return process

    @staticmethod
    def tar_result(img_path, filename):
        """
        Compress output images from dorothea execution

        :param img_path: output images path
        :type img_path: str
        :param filename: tar output file name
        :type filename: str
        :return:
        """
        tar = tarfile.open(filename, "w:gz")
        tar.add(img_path)
        tar.close()
