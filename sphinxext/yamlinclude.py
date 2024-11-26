import os.path

from docutils import statemachine

from docutils.parsers.rst import directives

from sphinx.util.docutils import SphinxDirective

import yaml

class YamlInclude(SphinxDirective):
   
   has_content = False
   required_arguments = 1 # Must have the file to include
   optional_arguments = 0 # Must only specify the file to include

   option_spec = {
      "key": directives.unchanged_required,
      "subs" : directives.unchanged,
      "includepath" : directives.unchanged,
      "debug" : directives.flag,
   }
   
   def run(self):
      
      # Subs should be specified as a multi-line indented set of comma-separated key values
      # :subs:
      #   foo,bar
      #   bin,baz
      #
      # We parse that into a dictionary for lookup later as part of the substitution loop.
      subs = {}
      if ('subs') in self.options:
         for i in self.options.get('subs').splitlines():
            kv = i.split(',')
            subs[kv[0]] = kv[1]

      if ('debug') in self.options: print ("Substitution dictionary is "); print(subs)

      key = self.options.get('key')

      # I straight up have no idea what this does or how it works
      # It is pulled directly from the Includes definition in
      # docutils/parsers/rst/directives.misc.py
      # But it returns the correct directory so I guess it's fine

      source = self.state_machine.input_lines.source(
         self.lineno - self.state_machine.input_offset - 1)
      source_dir = os.path.dirname(os.path.abspath(source))

      if ('includepath') in self.options:
         source_dir += '/' + self.options.get('includepath')
      else:
         source_dir += '/includes'

      if ('debug') in self.options: print ("Using " + source_dir + " as source directory")

      path = os.path.normpath(os.path.join(source_dir, self.arguments[0]))
      if ('debug') in self.options: print ("Path is " + path)

      # We open the YAML file and do a lookup based on the key
      # This should theoretically be O(1) regardless of file size

      with open(path, "r") as file:
         try:
            yfile = yaml.safe_load(file)
            content = yfile[key]['content']
            if ('debug') in self.options: print ("Content is " + content)

            content = statemachine.string2lines(content, convert_whitespace=True)

            # If we have any subs, iterate through the content line by line and perform simple string substitution.

            if (len(subs) > 0):
               print("Doing substitutions")
               for i,x in enumerate(content):
                  for j in subs:
                     content[i] = content[i].replace(j,subs[j])
                  

            self.state_machine.insert_input(content, path)

            return []

         except yaml.YAMLError as exc:
            print(exc)

      return []

def setup(app):
   directives.register_directive('yamlinclude', YamlInclude)

   return {
      'parallel_read_safe': True,
      'parallel_write_safe': True,
   }