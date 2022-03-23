.. start-bucket-notification-find-arn

.. admonition:: Identifying the ARN for your bucket notifications
   :class: note

   You defined the ``<IDENTIFIER>`` to assign to the target ARN for your bucket notifications when creating the endpoint previously.
   The steps below return the ARNs configured on the deployment.
   Identify the ARN created previously by looking for the ``<IDENTIFIER>`` you specified.
   
   **Review the JSON output**
   
   #. Copy and run the following command, replacing ``ALIAS`` with the :ref:`alias <alias>` of the deployment.

      .. code-block:: shell
         :class: copyable

         mc admin info --json ALIAS

   #. In the JSON output, look for the key ``info.sqsARN``.
   
      The ARN you need is the value of that key that matches the ``<IDENTIFIER>`` you specified.
      
      For example, |ARN|.
   **Use jq to parse the JSON for the value**
    
   #. `Install jq <https://stedolan.github.io/jq/>`_
   #. Copy and run the following command, replacing ``ALIAS`` with the :ref:`alias <alias>` of the deployment.

      .. code-block:: shell
         :class: copyable

         mc admin info --json ALIAS | jq  .info.sqsARN

      This returns the ARN to use for notifications, such as |ARN|

.. end-bucket-notification-find-arn