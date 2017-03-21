/*
 * Minio Cookbook for Amazon S3 Compatible Cloud Storage,
 * (C) 2017 Minio,Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Arrays;

public class GenerateAsymmetricMasterKey {
  private static final String keyDir  = System.getProperty("java.io.tmpdir");
  private static final SecureRandom srand = new SecureRandom();

  public static void main(String[] args) throws Exception {
    // Generate RSA key pair of 1024 bits
    KeyPair keypair = genKeyPair("RSA", 1024);
    // Save to file system
    saveKeyPair(keyDir, keypair);
    // Loads from file system
    KeyPair loaded = loadKeyPair(keyDir, "RSA");
  }

  public static KeyPair genKeyPair(String algorithm, int bitLength)
      throws NoSuchAlgorithmException {
    KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance(algorithm);
    keyGenerator.initialize(1024, srand);
    return keyGenerator.generateKeyPair();
  }

  public static void saveKeyPair(String dir, KeyPair keyPair)
      throws IOException {
    PrivateKey privateKey = keyPair.getPrivate();
    PublicKey publicKey = keyPair.getPublic();

    X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(
        publicKey.getEncoded());
    FileOutputStream fos = new FileOutputStream(dir + "/public.key");
    fos.write(x509EncodedKeySpec.getEncoded());
    fos.close();

    PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(
        privateKey.getEncoded());
    fos = new FileOutputStream(dir + "/private.key");
    fos.write(pkcs8EncodedKeySpec.getEncoded());
    fos.close();
  }

  public static KeyPair loadKeyPair(String path, String algorithm)
      throws IOException, NoSuchAlgorithmException,
      InvalidKeySpecException {
    // read public key from file
    File filePublicKey = new File(path + "/public.key");
    FileInputStream fis = new FileInputStream(filePublicKey);
    byte[] encodedPublicKey = new byte[(int) filePublicKey.length()];
    fis.read(encodedPublicKey);
    fis.close();

    // read private key from file
    File filePrivateKey = new File(path + "/private.key");
    fis = new FileInputStream(filePrivateKey);
    byte[] encodedPrivateKey = new byte[(int) filePrivateKey.length()];
    fis.read(encodedPrivateKey);
    fis.close();

    // Convert them into KeyPair
    KeyFactory keyFactory = KeyFactory.getInstance(algorithm);
    X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(
        encodedPublicKey);
    PublicKey publicKey = keyFactory.generatePublic(publicKeySpec);

    PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(
        encodedPrivateKey);
    PrivateKey privateKey = keyFactory.generatePrivate(privateKeySpec);

    return new KeyPair(publicKey, privateKey);
  }
}
