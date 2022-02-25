:orphan:

===========
Design Page
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

This page is designed to assist MinIO UI/UX work on the documentation. Think of
it like a 'kitchen-sink' of various objects and headers to more easily see
what everything looks liker right now. If it's on this page, it exists
somewhere else in the documentation.

If you are not working on MinIO UI/UX, this page has no useful content. 
Head back to the :doc:`Index </index>`. 

Common Markup
-------------

Text Markup
~~~~~~~~~~~

*This is italics text*

**This is bold text**

``This is monospaced text``

`This is hyperlink text <https://min.io>`__

.. code-block:: shell
   :class: copyable

   echo "This is a code block. It includes as small copy hover in the top-right."

   echo "Syntax highlighting is automatic via pygments."

Containers
~~~~~~~~~~

.. container::

   This text is in a container. Containers can be helpful for custom rendering
   of text. Add a custom class to the container to test the CSS:

   .. code-block:: shell

      .. container::
         :class: class-name

Sphinx Design
-------------

The following components come from 
:github:`sphinx-design <executablebooks/sphinx-design>`

Tabs
~~~~

MinIO uses the ExecutableBooks 
:github:`sphinx-design <executablebooks/sphinx-design>`  library for tabs.

.. tab-set::

   .. tab-item:: Plain Text

      This is plain text content

   .. tab-item:: Text and Code

      This is plain text content with code:

      .. code-block:: shell
         :class: copyable

         mc admin info ALIAS

Cards
~~~~~

.. card:: Title of the card

   This is the header of the card
   ^^^
   This is content inside of the card.

   The card can contain varying content. 

   .. code-block:: shell

      echo "This is some code block"

   +++
   This is the footer of the card

.. card:: This card is clickable
   :link: https://min.io

   Clicking this card will take you to https://min.io

.. card:: This card is clickable
   :link: objects
   :link-type: ref

   Clicking this card will take you to the location of the ``objects`` reference
   anchor.

.. card-carousel:: 4

   .. card:: Card Carousel 1

      This is the first item in the carousel

   .. card:: Card Carousel 2

      This is the second item in the carousel

   .. card:: Card Carousel 3

      This is the third item in the carousel

   .. card:: Card Carousel 4

      This is the fourth item in the carousel

Grids
~~~~~

.. grid:: 1 1 3 3
   :outline:
   :gutter: 2

   .. grid-item::

      The first item in the grid

   .. grid-item::

      The second item in the grid

   .. grid-item::

      The third item in the grid

      .. grid:: 1 1 1 1
         :outline:

         .. grid-item::

            SubGrid Item 1

         .. grid-item::

            SubGrid Item 2

         .. grid-item::

            SubGrid Item 3

.. grid:: 2 2 3 3
   :gutter: 3

   .. grid-item-card:: Card 1

      Card 1 content

   .. grid-item-card:: Card 2

      Card 2 content

   .. grid-item::
      :child-direction: row
      :child-align: spaced

      .. grid:: 1 1 1 1
         :gutter: 3
         :padding: 0

         .. grid-item-card:: SubCard 1

            SubCard 1 content

         .. grid-item-card:: SubCard 2

            SubCard 2 content

         .. grid-item-card:: SubCard 3

            SubCard 3 content

Header 1
--------

This is content under a level 1 header. The header includes an 
anchor tag for linking. The table of contents for this page is 
configured to display up to 2 header levels. The header title should
display in the right hand TOC.

Header 2
~~~~~~~~

This is content under a level 2 header. The header includes an anchor tag
for linking. The table of contents for this page is configured to display up
to 2 header levels. The header title should display in the right hand TOC

Header 3
++++++++

This is content under a level 3 header. The header includes an anchor tag
for linking. The table of contents for this page is configured to display up to
2 header levels. The header title should *not* display in the right hand TOC.

Header 4
========

This is content under a level 4 header. The header includes an anchor tag
for linking. The table of contents for this page is configured to display up to
2 header levels. The header title should *not* display in the right hand TOC.

Admonitions
-----------

The MinIO documentation uses the following admonition types. 
Admonition HTML code resembles the following:

.. code-block:: shell

   <div class="admonition [warning|important|note|custom]>
      <p class="admonition-title"></p>
   </div>

The additional class is set when defining the admonition and can be
any arbitrary string. Sphinx has defaults around ``warning``, 
``note``, and ``custom``.

Note Admonition
~~~~~~~~~~~~~~~

The note admonition renders as the following:

.. note::

   This text is in the note body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 

You can set custom text for the note title:

.. admonition:: Custom title with ``monospaced`` text
   :class: note

   This text is in the note body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 

Important Admonition
~~~~~~~~~~~~~~~~~~~~

The important admonition renders as follows:

.. important::

   This text is in the important body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 


You can set custom text for the important title:

.. admonition:: This is the important title with ``monospaced`` text
   :class: important

   This text is in the important body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 

Warning Admonition
~~~~~~~~~~~~~~~~~~

The warning admonition renders as follows:

.. warning::

   This text is in the warning body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 


You can set custom text for the warning title:

.. admonition:: This is the warning title with ``monospaced`` text
   :class: warning

   This text is in the warning body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 

Generic Admonition
~~~~~~~~~~~~~~~~~~

The generic admonition can apply any arbitrary class. This may be 
useful if we want to display an admonition using very specific designs.


.. admonition:: admonition-title
   :class: class-name

   This text is in the admonition body. It includes some 
   ``monospaced``, **bold**, and *italics*. 

   This is a :doc:`link </index>` to another page in the documentation.

   This is a `link <https://min.io>`__ to an external page. 

Lists
-----

List Table
~~~~~~~~~~

Sphinx has special markup for producing clean tables, vs ascii-style table
definitions.

The following ``.. list-table`` has a single header row and multiple columns:

.. list-table::
   :header-rows: 1
   :widths: 25 25 25 25
   :width: 100%

   * - Row Title 1
     - Row Title 2
     - Row Title 3
     - Row Title 4

   * - Column Item 1
     - Column Item 2
     - Column Item 3
     - Column Item 4

   * - Column Item 1
     - Column Item 2
     - Column Item 3
     - Column Item 4

   * - Column Item 1
     - Column Item 2
     - Column Item 3
     - Column Item 4

The following ``.. list-table`` uses a stub column, where the first column
contains the "header" or title:

.. list-table::
   :stub-columns: 1
   :widths: 25 25 25 25
   :width: 100%

   * - Row Title 1
     - Column Item 1
     - Column Item 2
     - Column Item 3

   * - Row Title 2
     - Column Item 1
     - Column Item 2
     - Column Item 3

   * - Row Title 3
     - Column Item 1
     - Column Item 2
     - Column Item 3

   * - Row Title 4
     - Column Item 1
     - Column Item 2
     - Column Item 3

Bullets and Numbered Lists
~~~~~~~~~~~~~~~~~~~~~~~~~~

This is a bullet list:

- Item A
- Item B
   - Item B.1
   - Item B.2
- Item C
   - Item C.1
   - Item C.2
   - Item C.3
      - Item C.3.1
      - Item C.3.2

This is a numbered list:

1) Item A

2) Item B

  1) Item B.1

  2) Item B.2

3) Item C

  3) Item C.1

  4) Item C.2

  5) Item C.3

    1) Item C.3.1

    2) Item C.3.2

Definition Lists
~~~~~~~~~~~~~~~~

Sphinx markup includes syntax for producing a Description List and
various Description Details. These typically are *not* anchored, so their
usefulness is somewhat limited. They can be a nice way of creating visually
distinct lists for quick scrolling and view. They are used frequently
in the reference documentation.

Description List Title 1
  This is the description body for this title.

  Another paragraph in this definition list

Description List Title 2
  This is the description body for this title.

  Another paragraph in this definition list

Description List Title 3
  This is the description body for this title.

  Another paragraph in this definition list

Reference Definition
--------------------

Sphinx supports creating customized reference-type directives. We use
several throughout the docs. The following section includes some example
definitions. The initial table links to each definition.

- :mc:`foo`
- :mc-cmd:`foo bar`
- :mc-cmd:`foo bar baz`
- :data:`foo`
- :data:`foo.bar`


.. mc:: foo

There's actually a top-level definition here for linking, but not
for display. This is intentional (For now). 

.. mc-cmd:: bar
   :fullpath:

   Used for defining CLI commands.

   .. mc-cmd:: bin

      Used for defining various arguments to a CLI command

   .. mc-cmd:: baz
      

      Used for defining an option to a CLI command

.. data:: foo

   A generic bit of data we can reference.

   .. data:: bar

      These are nested and linked.



