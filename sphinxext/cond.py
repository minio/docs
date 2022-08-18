"""

   Original Cond logic derived from https://github.com/mongodb/docs-tools/blob/master/sphinxext/fixed_only.py

   Original Only logic derived from https://github.com/sphinx-doc/sphinx/blob/5.x/sphinx/directives/other.py#L289, under the BSD license

   

"""

from docutils import nodes
from docutils.nodes import Element, Node
from docutils.parsers.rst import Directive, directives
from sphinx.util.docutils import SphinxDirective
from docutils.utils import SafeString
from sphinx.util.nodes import nested_parse_with_titles, set_source_info, Node
from typing import TYPE_CHECKING, Any, Dict, List, cast

# Keeping this in case we need it later, but assuming everything works as expected, we can probably drop this entirely

class Cond(Directive):
    """
    Directive to only include text if the given tag(s) are enabled.
    """
    has_content = True
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec = {}

    def run(self):
        config = self.state.document.settings.env.config
        try:
            result = config._raw_config['tags'].eval_condition(self.arguments[0])
        except ValueError as err:
            raise self.severe(u'Error parsing conditional parsing expression: {}'.format(SafeString(str(err))))

        if result:
            node = nodes.Element()
            set_source_info(self, node)
            nested_parse_with_titles(self.state, self.content, node)
            return node.children

        return []

class CondPlus(SphinxDirective):
    """
    Directive to only include text if the given tag(s) are enabled.
    """
    has_content = True
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec = {}

    def run(self):
        config = self.state.document.settings.env.config
        try:
            result = config._raw_config['tags'].eval_condition(self.arguments[0])
        except ValueError as err:
            raise self.severe(u'Error parsing conditional parsing expression: {}'.format(SafeString(str(err))))

        if not result:
             # early exit if we know there's no match
             return []

         # Same as util.nested_parse_with_titles but try to handle nested
         # sections which should be raised higher up the doctree.
        memo: Any = self.state.memo
        surrounding_title_styles = memo.title_styles
        surrounding_section_level = memo.section_level
        memo.title_styles = []
        memo.section_level = 0

        node = Element()
        node.document = self.state.document
        set_source_info(self, node)

        try:
           self.state.nested_parse(self.content, self.content_offset, node, match_titles=True)

           title_styles = memo.title_styles
           if (not surrounding_title_styles or
                 not title_styles or
                 title_styles[0] not in surrounding_title_styles or
                 not self.state.parent):
                 # No nested sections so no special handling needed.
                 return node.children

           current_depth = 0
           parent = self.state.parent
           while parent:
              current_depth +=1
              parent = parent.parent
              # This should stop at the "Title" element

           # Accounts for the "Title" element?
           # Adding a debug just in case this runs negative - unsure when or why or how that would happen
           current_depth -= 2
           if (current_depth < 0):
               print("Negative Depth" + str(current_depth))

           # Grabbing the decorator for the title
           title_style = title_styles[0]
           nested_depth = len(surrounding_title_styles)
           if title_style in surrounding_title_styles:
              nested_depth = surrounding_title_styles.index(title_style)
            
           # This should give us the number of heading levels to pop up, effectively
           n_sects_to_raise = current_depth - nested_depth + 1

            # Resetting parent
           parent = cast(Element, self.state.parent)

           for i in range (n_sects_to_raise):
              if parent.parent:
                 parent = parent.parent

           parent.extend(node)

            # for i in node:
            #    parent.append(i)

        finally:
           memo.title_styles = surrounding_title_styles
           memo.section_level = surrounding_section_level

        # Actual work is done by extending the correct parent node, so we can return an empty list.
        return []

def setup(app):
    #directives.register_directive('cond', Cond)
    # If everything works as expected, we can rename CondPlus to Cond or "Conditional" or something like that.
    directives.register_directive('cond', CondPlus)

    return {
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
