from docutils import nodes
from docutils.parsers.rst import Directive, directives
from docutils.utils import SafeString
from sphinx.util.nodes import nested_parse_with_titles, set_source_info


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


def setup(app):
    directives.register_directive('cond', Cond)

    return {
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
