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

from utils import logger


class Dorothea:
    """
    This is a class for Dorothea module.
    """

    @staticmethod
    def execute_dorothea_rscript(input_csv_path, arguments, input_r_script_path):
        """
        Execute dorothea.

        :param input_csv_path:
        :param arguments:
        :param input_r_script_path:
        :type input_csv_path: str
        :type arguments: dict
        :type input_r_script_path: str
        """
        logger.debug("Starting dorothea execution")
        args_list = list(arguments.values())
        print(args_list)

        process = subprocess.Popen(
            ['/usr/bin/Rscript', '--vanilla', input_r_script_path, input_csv_path, args_list[2], str(args_list[3]),
             str(args_list[4])], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        return process
