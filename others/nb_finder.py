#---------------
# Importing Jupyter Notebooks as Modules
#   https://jupyter-notebook.readthedocs.io/en/4.x/examples/Notebook/rstversions/Importing%20Notebooks.html
#
#   This program is copied from
#     https://www.linuxtut.com/en/d0f6e792b176d2613f9a/
#
# Usage
#
#   import sys
#   import nb_finder as nbf
#   sys.meta_path.append(nbf.NotebookFinder()) 
#   import yhc_module as yhc  
#   help(yhc) 
#
# Yi-Hsuan Chen
#---------------



import io, os, sys, types
from IPython import get_ipython
from nbformat import read
from IPython.core.interactiveshell import InteractiveShell

def find_notebook(fullname, path=None):
    name = fullname.rsplit('.', 1)[-1]
    if not path:
        path = ['']
    for d in path:
        nb_path = os.path.join(d, name + ".ipynb")
        if os.path.isfile(nb_path):
            return nb_path
        nb_path = nb_path.replace("_", " ")
        if os.path.isfile(nb_path):
            return nb_path

class NotebookLoader(object):
    def __init__(self, path=None):
        self.shell = InteractiveShell.instance()
        self.path = path

    def load_module(self, fullname):
        path = find_notebook(fullname, self.path)
        with io.open(path, 'r', encoding='utf-8') as f:
            nb = read(f, 4)
        mod = types.ModuleType(fullname)
        mod.__file__ = path
        mod.__loader__ = self
        mod.__dict__['get_ipython'] = get_ipython
        sys.modules[fullname] = mod
        save_user_ns = self.shell.user_ns
        self.shell.user_ns = mod.__dict__
        try:
          for cell in nb.cells:
            if cell.cell_type == 'code':
                code = self.shell.input_transformer_manager.transform_cell(cell.source)
                #At the beginning of the cell"#export"Execute only the cell described as
                if code.startswith("#export"):
                    exec(code, mod.__dict__)
        except Exception as ex:
            #In the cell"#export"I often forget to add, so let me know where the error occurred
            print(code)
            raise ex
        finally:
            self.shell.user_ns = save_user_ns
        return mod

class NotebookFinder(object):
    def __init__(self):
        self.loaders = {}

    def find_module(self, fullname, path=None):
        nb_path = find_notebook(fullname, path)
        if not nb_path:
            return
        key = path
        if path:
            # lists aren't hashable
            key = os.path.sep.join(path)
        if key not in self.loaders:
            self.loaders[key] = NotebookLoader(path)
        return self.loaders[key]
