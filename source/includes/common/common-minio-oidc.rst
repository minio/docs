.. start-minio-oidc-policy-variables

The following table contains a list of supported policy variables for use in authorizing :ref:`OIDC-managed users <minio-external-identity-management-openid>`.

Each variable corresponds to a claim returned as part of the authenticated user's JWT token:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Variable
     - Description

   * - ``jwt:sub``
     - Returns the ``sub`` claim for the user.

   * - ``jwt:iss``
     - Returns the Issuer Identifier claim from the ID token.

   * - ``jwt:aud``
     - Returns the Audience claim from the ID token.

   * - ``jwt:jti``
     - Returns the JWT ID claim from the client authentication information.

   * - ``jwt:upn``
     - Returns the User Principal Name claim from the client authentication information.

   * - ``jwt:name``
     - Returns the ``name`` claim for the user.

   * - ``jwt:groups``
     - Returns the ``groups`` claim for the user.

   * - ``jwt:given_name``
     - Returns the ``given_name`` claim for the user.

   * - ``jwt:family_name``
     - Returns the ``family_name`` claim for the user.

   * - ``jwt:middle_name``
     - Returns the ``middle_name`` claim for the user.

   * - ``jwt:nickname``
     - Returns the ``nickname`` claim for the user.

   * - ``jwt:preferred_username``
     - Returns the ``preferred_username`` claim for the user.

   * - ``jwt:profile``
     - Returns the ``profile`` claim for the user.

   * - ``jwt:picture``
     - Returns the ``picture`` claim for the user.

   * - ``jwt:website``
     - Returns the ``website`` claim for the user.

   * - ``jwt:email``
     - Returns the ``email`` claim for the user.

   * - ``jwt:gender``
     - Returns the ``gender`` claim for the user.

   * - ``jwt:birthdate``
     - Returns the ``birthdate`` claim for the user.

   * - ``jwt:phone_number``
     - Returns the ``phone_number`` claim for the user.

   * - ``jwt:address``
     - Returns the ``address`` claim for the user.

   * - ``jwt:scope``
     - Returns the ``scope`` claim for the user.

   * - ``jwt:client_id``
     - Returns the ``client_id`` claim for the user.

See the `OpenID Connect Core 1.0 <https://openid.net/specs/openid-connect-core-1_0.html>`__ document for more information on these scopes.
Your OIDC provider of choice may have more specific documentation.

For example, the following policy uses variables to substitute the authenticated user's ``preferred_username`` as part of the ``Resource`` field such that the user can only access those prefixes which match their username:

.. code-block:: json

   {
   "Version": "2012-10-17",
   "Statement": [
         {
            "Action": ["s3:ListBucket"],
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::mybucket"],
            "Condition": {"StringLike": {"s3:prefix": ["${jwt:preferred_username}/*"]}}
         },
         {
            "Action": [
            "s3:GetObject",
            "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::mybucket/${jwt:preferred_username}/*"]
         }
      ]
   }

MinIO replaces the ``${jwt:preferred_username}`` variable in the ``Resource`` field with the value of the ``preferred_username`` in the JWT token.
MinIO then evaluates the policy and grants or revokes access to the requested API and resource.

.. end-minio-oidc-policy-variables

