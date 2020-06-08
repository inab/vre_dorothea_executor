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
import tool.VRE_Tool

from utils import logger


class Template:
    """
    This is a class for Template workflow module.
    """

    @staticmethod
    def execute_tool(input_csv_path, arguments, input_r_script_path):
        """

        """
        logger.debug("Starting tool execution")
        R_script = input_r_script_path + "run_dorothea.r"
        print(R_script)
        print(input_csv_path)
        args_list = list(arguments.values())
        
        py2output = subprocess.check_output(['/usr/bin/Rscript', '--vanilla', R_script, input_csv_path,
                args_list[2], str(args_list[3]), str(args_list[4]), str(args_list[5])])
        print('py2 said:', py2output)

        # Rscript run_dorothea.r "dorothea_example.csv" "test" "A,B,C" 5 F 25
        process = subprocess.Popen(['/usr/bin/Rscript', '--vanilla', R_script, input_csv_path,
                args_list[2], str(args_list[3]), str(args_list[4]), str(args_list[5])], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return process
