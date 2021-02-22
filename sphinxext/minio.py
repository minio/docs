"""
    sphinx.domains.minio
    ~~~~~~~~~~~~~~~~~~~~~~~~~

    The MinIO domain.

    :copyright: Copyright 2007-2020 by MinIO Inc. See AUTHORS
    :license: Apache License 2.0. See LICENSE

    Based on the default JavaScript domain distributed with Sphinx (BSD 2-clause)

    Additional work to adapt for MinIO done by MinIO Inc. (See AUTHORS)

    See https://github.com/sphinx-doc/sphinx/blob/3.x/sphinx/domains/javascript.py.
    



"""

from typing import Any, Dict, Iterator, List, Tuple
from typing import cast

from docutils import nodes
from docutils.nodes import Element, Node
from docutils.parsers.rst import directives

from sphinx import addnodes
from sphinx.addnodes import desc_signature, pending_xref
from sphinx.application import Sphinx
from sphinx.builders import Builder
from sphinx.directives import ObjectDescription
from sphinx.domains import Domain, ObjType
from sphinx.domains.python import _pseudo_parse_arglist
from sphinx.environment import BuildEnvironment
from sphinx.locale import _, __
from sphinx.roles import XRefRole
from sphinx.util import logging
from sphinx.util.docfields import Field, GroupedField, TypedField
from sphinx.util.docutils import SphinxDirective
from sphinx.util.nodes import make_id, make_refnode


logger = logging.getLogger(__name__)


class MinioMCCommand(SphinxDirective):
   """
   Description of a MinIO MC Command. Use this class when describing a top level
   ``mc`` or ``mc admin`` command. ``MinioMCObjects`` objects use this
   as a prefix for linking purposes. 
   """

   has_content = False
   required_arguments = 1
   optional_arguments = 1 #for mc admin?
   final_argument_whitespace = True
   option_spec = {
      'noindex': directives.flag # in case we do not want to create an index entry. 
   }

   def run(self) -> List[Node]:
      command = self.arguments[0].strip()
      if (len(self.arguments) > 1):
         command += "-" + self.arguments[1].strip().replace(" ","-")
      
      self.env.ref_context['minio:mc'] = command
      noindex = 'noindex' in self.options
      ret = []
      if not noindex:
         domain = cast(MinIODomain, self.env.get_domain('minio'))

         node_id = make_id(self.env, self.state.document, 'command', command)
         domain.note_module(command, node_id)
         # Make a duplicate entry in 'objects' to facilitate searching for
         # the module in JavaScriptDomain.find_obj()
         domain.note_object(command, 'mc', node_id,
                              location=(self.env.docname, self.lineno))

         target = nodes.target('', '', ids=[node_id], ismod=True)

         self.state.document.note_explicit_target(target)
         ret.append(target)
         indextext = _('%s (command)') % command
         inode = addnodes.index(entries=[('single', indextext, node_id, '', None)])
         ret.append(inode)
      return ret

class MinioMCObject(ObjectDescription):
    """
    Description of a Minio ``mc`` or ``mc admin`` subcommand or subcommand argument
    """

    has_arguments = True

    display_prefix = None

    allow_nesting = True

    option_spec = {
       'noindex': directives.flag,
       'noindexentry': directives.flag,
       'fullpath': directives.flag,
       'option': directives.flag,
       'notext': directives.flag,
    }

    def handle_signature(self, sig: str, signode: desc_signature) -> Tuple[str, str]:
        """Breaks down construct signatures

        Parses out prefix and argument list from construct definition. The
        namespace and class will be determined by the nesting of domain
        directives.
        """
        sig = sig.strip()
        if ',' in sig:
           # For subcommands w/ aliases
           member, alias = sig.split(',', 1)
           member = member.strip()
           alias = alias.strip()
        elif ' ' in sig:
           # For subcommands with spaces
           # Need to find a better way of specifying aliases, this is very hacky
           member = sig.replace(' ', '-')
           alias = None
        else:
            member = sig
            alias = None
        # If construct is nested, prefix the current prefix
        prefix = self.env.ref_context.get('minio:object', None)

        #Grab the top-level command name.
        command_name = self.env.ref_context.get('minio:mc').replace("-"," ")
        name = member
        format_name = member
        format_alias = alias
        if prefix:
            fullname = '-'.join([prefix, name])
        else:
            fullname = name

        if 'option' in self.options:
           format_name = "--" + name
        
        if 'option' in self.options and alias != None:
           format_alias = "--" + alias


        signode['command'] = command_name
        signode['object'] = prefix
        signode['fullname'] = fullname

        if prefix:
           signode += addnodes.desc_addname(prefix + '-', ' ')
        elif command_name and ('fullpath' in self.options):
           signode += addnodes.desc_addname(command_name + '-', command_name + ' ')
        elif command_name:
           signode += addnodes.desc_addname(command_name + '-', ' ')
        
        if (alias != None):
           signode += addnodes.desc_name(name + ', ' + alias, format_name + ', ' + format_alias)
        elif 'notext' in self.options:
           signode += addnodes.desc_name(name, '')
        else:
           signode += addnodes.desc_name(name, format_name)
        
        return fullname, prefix

    def add_target_and_index(self, name_obj: Tuple[str, str], sig: str,
                             signode: desc_signature) -> None:
        mod_name = self.env.ref_context.get('minio:mc')
        fullname = (mod_name + '-' if mod_name else '') + name_obj[0]
        node_id = make_id(self.env, self.state.document, '', fullname)
        signode['ids'].append(node_id)

        self.state.document.note_explicit_target(signode)

        domain = cast(MinIODomain, self.env.get_domain('minio'))
        domain.note_object(fullname, self.objtype, node_id, location=signode)

        if 'noindexentry' not in self.options:
            indextext = self.get_index_text(mod_name, name_obj)
            if indextext:
                self.indexnode['entries'].append(('single', indextext, node_id, '', None))

    def get_index_text(self, objectname: str, name_obj: Tuple[str, str]) -> str:
        name, obj = name_obj
        if self.objtype == 'function':
            if not obj:
                return _('%s() (built-in function)') % name
            return _('%s() (%s method)') % (name, obj)
        elif self.objtype == 'class':
            return _('%s() (class)') % name
        elif self.objtype == 'data':
            return _('%s (global variable or constant)') % name
        elif self.objtype == 'attribute':
            return _('%s (%s attribute)') % (name, obj)
        return ''

    def before_content(self) -> None:
        """Handle object nesting before content

        :minio:`MinioObject` represents MinIO language constructs. For
        constructs that are nestable, this method will build up a stack of the
        nesting heirarchy so that it can be later de-nested correctly, in
        :minio:meth:`after_content`.

        The following keys are used in ``self.env.ref_context``:

            minio:objects
                Stores the object prefix history. With each nested element, we
                add the object prefix to this list. When we exit that object's
                nesting level, ::`after_content` is triggered and the
                prefix is removed from the end of the list.

            minio:object
                Current object prefix. This should generally reflect the last
                element in the prefix history
        """
        prefix = None
        if self.names:
            (obj_name, obj_name_prefix) = self.names.pop()
            prefix = obj_name_prefix.strip('.') if obj_name_prefix else None
            if self.allow_nesting:
                prefix = obj_name
        if prefix:
            self.env.ref_context['minio:object'] = prefix
            if self.allow_nesting:
                objects = self.env.ref_context.setdefault('minio:objects', [])
                objects.append(prefix)

    def after_content(self) -> None:
        """Handle object de-nesting after content

        If this class is a nestable object, removing the last nested class prefix
        ends further nesting in the object.

        If this class is not a nestable object, the list of classes should not
        be altered as we didn't affect the nesting levels in
        :py:meth:`before_content`.
        """
        objects = self.env.ref_context.setdefault('minio:objects', [])
        if self.allow_nesting:
            try:
                objects.pop()
            except IndexError:
                pass
        self.env.ref_context['minio:object'] = (objects[-1] if len(objects) > 0
                                             else None)



class MinioObject(ObjectDescription):
    """
    Description of a MinIO object.
    """
    #: If set to ``True`` this object is callable and a `desc_parameterlist` is
    #: added
    has_arguments = False

    #: what is displayed right before the documentation entry
    display_prefix = None  # type: str

    #: If ``allow_nesting`` is ``True``, the object prefixes will be accumulated
    #: based on directive nesting
    allow_nesting = True

    option_spec = {
        'noindex': directives.flag,
        'noindexentry': directives.flag,
    }

    def handle_signature(self, sig: str, signode: desc_signature) -> Tuple[str, str]:
        """Breaks down construct signatures

        Parses out prefix and argument list from construct definition. The
        namespace and class will be determined by the nesting of domain
        directives.
        """
        sig = sig.strip()

        member = sig
        # If construct is nested, prefix the current prefix
        prefix = self.env.ref_context.get('minio:object', None)

        fullname = member

        if prefix:
          fullname = '.'.join([prefix, member])

        signode['object'] = prefix
        signode['fullname'] = fullname

        if prefix:  
          signode += addnodes.desc_addname(prefix + '.', prefix + '.')
        
        signode += addnodes.desc_name(member, member)

        return fullname, prefix

    def add_target_and_index(self, name_obj: Tuple[str, str], sig: str,
                             signode: desc_signature) -> None:
        mod_name = self.env.ref_context.get('minio:module')
        
        if (self.objtype == "mc" or self.objtype == "mc-cmd" or self.objtype == "mc-cmd-option"):
           fullname = (mod_name + '.' if mod_name else '') + name_obj[0]
        else:
           fullname = self.objtype + "." + name_obj[0]
        
        node_id = make_id(self.env, self.state.document, '', fullname)
        signode['ids'].append(node_id)

        # Assign old styled node_id not to break old hyperlinks (if possible)
        # Note: Will be removed in Sphinx-5.0 (RemovedInSphinx50Warning)
        old_node_id = self.make_old_id(fullname)
        if old_node_id not in self.state.document.ids and old_node_id not in signode['ids']:
            signode['ids'].append(old_node_id)

        self.state.document.note_explicit_target(signode)

        domain = cast(MinIODomain, self.env.get_domain('minio'))
        domain.note_object(fullname, self.objtype, node_id, location=signode)

        if 'noindexentry' not in self.options:
            indextext = self.get_index_text(mod_name, name_obj)
            
            if indextext:
                self.indexnode['entries'].append(('single', indextext, node_id, '', None))

    def get_index_text(self, objectname: str, name_obj: Tuple[str, str]) -> str:
        name, obj = name_obj

        if self.objtype == 'function':
            if not obj:
                return _('%s() (built-in function)') % name
            return _('%s() (%s method)') % (name, obj)
        elif self.objtype == 'class':
            return _('%s() (class)') % name
        elif self.objtype == 'data':
            return _('%s (global variable or constant)') % name
        elif self.objtype == 'attribute':
            return _('%s (%s attribute)') % (name, obj)
        return ''

    def before_content(self) -> None:
        """Handle object nesting before content

        :py:class:`MinioObject` represents MinIO language constructs. For
        constructs that are nestable, this method will build up a stack of the
        nesting heirarchy so that it can be later de-nested correctly, in
        :py:meth:`after_content`.

        For constructs that aren't nestable, the stack is bypassed, and instead
        only the most recent object is tracked. This object prefix name will be
        removed with :py:meth:`after_content`.

        The following keys are used in ``self.env.ref_context``:

            minio:objects
                Stores the object prefix history. With each nested element, we
                add the object prefix to this list. When we exit that object's
                nesting level, :py:meth:`after_content` is triggered and the
                prefix is removed from the end of the list.

            minio:object
                Current object prefix. This should generally reflect the last
                element in the prefix history
        """
        prefix = None
        if self.names:
            (obj_name, obj_name_prefix) = self.names.pop()
            prefix = obj_name_prefix.strip('.') if obj_name_prefix else None
            if self.allow_nesting:
                prefix = obj_name
        if prefix:
            self.env.ref_context['minio:object'] = prefix
            if self.allow_nesting:
                objects = self.env.ref_context.setdefault('minio:objects', [])
                objects.append(prefix)

    def after_content(self) -> None:
        """Handle object de-nesting after content

        If this class is a nestable object, removing the last nested class prefix
        ends further nesting in the object.

        If this class is not a nestable object, the list of classes should not
        be altered as we didn't affect the nesting levels in
        :py:meth:`before_content`.
        """
        objects = self.env.ref_context.setdefault('minio:objects', [])
        if self.allow_nesting:
            try:
                objects.pop()
            except IndexError:
                pass
        self.env.ref_context['minio:object'] = (objects[-1] if len(objects) > 0
                                             else None)

    def make_old_id(self, fullname: str) -> str:
        """Generate old styled node_id for Minio objects.

        .. note:: Old Styled node_id was used until Sphinx-3.0.
                  This will be removed in Sphinx-5.0.
        """
        return fullname.replace('$', '_S_')

class MinioCMDOptionXRefRole(XRefRole):
    def process_link(self, env: BuildEnvironment, refnode: Element,
                     has_explicit_title: bool, title: str, target: str) -> Tuple[str, str]:
        # basically what sphinx.domains.python.PyXRefRole does
        refnode['minio:object'] = env.ref_context.get('minio:object')
        refnode['minio:module'] = env.ref_context.get('minio:module')
        refnode['minio:mc'] = env.ref_context.get('minio:mc')
        if not has_explicit_title:
            title = title.lstrip('.')
            target = target.lstrip('~')
            if title[0:1] == '~':
                title = title[1:]
                # Handle stripping lead path from commands.
                space = title.rfind(' ')
                if space != -1:
                   title = title[space + 1:]
                title = "--" + title
            else:
               #full command, so need to insert the `--`
               title = title[:title.rfind(" ")] + " --" + title[title.rfind(" ")+1:]
        if target[0:1] == '.':
            target = target[1:]
            refnode['refspecific'] = True
        target = target.replace(" ","-")

        return title, target

class MinioXRefRole(XRefRole):
    def process_link(self, env: BuildEnvironment, refnode: Element,
                     has_explicit_title: bool, title: str, target: str) -> Tuple[str, str]:
        # basically what sphinx.domains.python.PyXRefRole does
        refnode['minio:object'] = env.ref_context.get('minio:object')
        refnode['minio:module'] = env.ref_context.get('minio:module')
        refnode['minio:mc'] = env.ref_context.get('minio:mc')
        
        if not has_explicit_title:
            title = title.lstrip('.')
            target = target.lstrip('~')
            if title[0:1] == '~':
                title = title[1:]
                dot = title.rfind('.')
                if dot != -1:
                    title = title[dot + 1:]
                
                # Handle stripping lead path from commands.
                space = title.rfind(' ')
                if space != -1:
                   title = title[space + 1:]
        if target[0:1] == '.':
            target = target[1:]
            refnode['refspecific'] = True

        if (self.reftype == "mc" or self.reftype == "mc-cmd" or self.reftype == "mc-cmd-option"):
          target = target.replace(" ","-")
          return title, target
        
        target = self.reftype + "." + target

        return title, target


class MinIODomain(Domain):
    """MinIO language domain."""
    name = 'minio'
    label = 'MinIO'
    # if you add a new object type make sure to edit MinioObject.get_index_string
    object_types = {
        'data':           ObjType(_('data'),          'data'),
        'kubeconf':       ObjType(_('kubeconf'),      'kubeconf'),
        'userpolicy':     ObjType(_('userpolicy'),    'userpolicy'),
        'flag':           ObjType(_('flag'),          'flag'),
        'mc':             ObjType(_('mc'),            'mc'),
        'mc-cmd':         ObjType(_('mc-cmd'),        'mc-cmd'),
        'mc-cmd-option':  ObjType(_('mc-cmd-option'), 'mc-cmd-option'),
        'policy-action':  ObjType(_('policy-action'), 'policy-action'),
        'envvar':         ObjType(_('envvar'),        'envvar')
    }
    directives = {
        'data':            MinioObject,
        'kubeconf':        MinioObject,
        'userpolicy':      MinioObject,
        'flag':            MinioObject,
        'mc':              MinioMCCommand,
        'mc-cmd':          MinioMCObject,
        'policy-action':   MinioObject,
        'envvar':          MinioObject
    }
    roles = {
        'data':             MinioXRefRole(),
        'kubeconf':         MinioXRefRole(),
        'userpolicy':       MinioXRefRole(),
        'flag':             MinioXRefRole(),
        'mc':               MinioXRefRole(),
        'mc-cmd':           MinioXRefRole(),
        'mc-cmd-option':    MinioCMDOptionXRefRole(),
        'policy-action':    MinioXRefRole(),
        'envvar':           MinioXRefRole(),

    }
    initial_data = {
        'objects': {},  # fullname -> docname, node_id, objtype
        'modules': {},  # modname  -> docname, node_id
        'commands': {},
    }  # type: Dict[str, Dict[str, Tuple[str, str]]]

    @property
    def objects(self) -> Dict[str, Tuple[str, str, str]]:
        return self.data.setdefault('objects', {})  # fullname -> docname, node_id, objtype

    def note_object(self, fullname: str, objtype: str, node_id: str,
                    location: Any = None) -> None:
        if fullname in self.objects:
            docname = self.objects[fullname][0]
            logger.warning(__('duplicate %s description of %s, other %s in %s'),
                           objtype, fullname, objtype, docname, location=location)
        self.objects[fullname] = (self.env.docname, node_id, objtype)

    @property
    def modules(self) -> Dict[str, Tuple[str, str]]:
        return self.data.setdefault('modules', {})  # modname -> docname, node_id

    def note_module(self, modname: str, node_id: str) -> None:
        self.modules[modname] = (self.env.docname, node_id)

    @property
    def command(self) -> Dict[str, Tuple[str, str]]:
       return self.data.setdefault('mc', {}) # command -> commandname, node_id

    def note_command(self, commandname: str, node_id: str) -> None:
       self.command[commandname] = (self.env.docname, node_id)

    def clear_doc(self, docname: str) -> None:
        for fullname, (pkg_docname, node_id, _l) in list(self.objects.items()):
            if pkg_docname == docname:
                del self.objects[fullname]
        for modname, (pkg_docname, node_id) in list(self.modules.items()):
            if pkg_docname == docname:
                del self.modules[modname]

    def merge_domaindata(self, docnames: List[str], otherdata: Dict) -> None:
        # XXX check duplicates
        for fullname, (fn, node_id, objtype) in otherdata['objects'].items():
            if fn in docnames:
                self.objects[fullname] = (fn, node_id, objtype)
        for mod_name, (pkg_docname, node_id) in otherdata['modules'].items():
            if pkg_docname in docnames:
                self.modules[mod_name] = (pkg_docname, node_id)

    def find_obj(self, env: BuildEnvironment, mod_name: str, prefix: str, name: str,
                 typ: str, searchorder: int = 0) -> Tuple[str, Tuple[str, str, str]]:
        if name[-2:] == '()':
            name = name[:-2]

        searches = []
        if mod_name and prefix:
            searches.append('.'.join([mod_name, prefix, name]))
        if mod_name:
            searches.append('.'.join([mod_name, name]))
        if prefix:
            searches.append('.'.join([prefix, name]))
        searches.append(name)

        if searchorder == 0:
            searches.reverse()

        newname = None
        for search_name in searches:
            if search_name in self.objects:
                newname = search_name

        return newname, self.objects.get(newname)

    def resolve_xref(self, env: BuildEnvironment, fromdocname: str, builder: Builder,
                     typ: str, target: str, node: pending_xref, contnode: Element
                     ) -> Element:
        mod_name = node.get('minio:module')
        prefix = node.get('minio:object')
        searchorder = 1 if node.hasattr('refspecific') else 0

        name, obj = self.find_obj(env, mod_name, prefix, target, typ, searchorder)
        if not obj:
            return None
        return make_refnode(builder, fromdocname, obj[0], obj[1], contnode, name)

    def resolve_any_xref(self, env: BuildEnvironment, fromdocname: str, builder: Builder,
                         target: str, node: pending_xref, contnode: Element
                         ) -> List[Tuple[str, Element]]:
        mod_name = node.get('minio:module')
        prefix = node.get('minio:object')
        name, obj = self.find_obj(env, mod_name, prefix, target, None, 1)
        if not obj:
            return []
        return [('minio:' + self.role_for_objtype(obj[2]),
                 make_refnode(builder, fromdocname, obj[0], obj[1], contnode, name))]

    def get_objects(self) -> Iterator[Tuple[str, str, str, str, str, int]]:
        for refname, (docname, node_id, typ) in list(self.objects.items()):
            yield refname, refname, typ, docname, node_id, 1

    def get_full_qualified_name(self, node: Element) -> str:
        modname = node.get('minio:module')
        prefix = node.get('minio:object')
        target = node.get('reftarget')
        if target is None:
            return None
        else:
            return '.'.join(filter(None, [modname, prefix, target]))


def setup(app: Sphinx) -> Dict[str, Any]:
    app.add_domain(MinIODomain)

    return {
        'version': 'builtin',
        'env_version': 2,
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
