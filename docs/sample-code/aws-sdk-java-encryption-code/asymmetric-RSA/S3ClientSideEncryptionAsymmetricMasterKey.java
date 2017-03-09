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

import java.io.ByteArrayInputStream;
import java.io.File;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Arrays;
import java.util.Iterator;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.junit.Assert;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3EncryptionClient;
import com.amazonaws.services.s3.S3ClientOptions;
import com.amazonaws.services.s3.model.EncryptionMaterials;
import com.amazonaws.services.s3.model.ListVersionsRequest;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.amazonaws.services.s3.model.S3VersionSummary;
import com.amazonaws.services.s3.model.StaticEncryptionMaterialsProvider;
import com.amazonaws.services.s3.model.VersionListing;

public class S3ClientSideEncryptionAsymmetricMasterKey {
	private static final String keyDir = System.getProperty("java.io.tmpdir");
	private static final String bucketName = UUID.randomUUID() + "-"
			+ DateTimeFormat.forPattern("yyMMdd-hhmmss").print(new DateTime());
	private static final String objectKey = UUID.randomUUID().toString();

	public static void main(String[] args) throws Exception {

		// 1. Load keys from files
		byte[] bytes = FileUtils.readFileToByteArray(new File(keyDir
				+ "/private.key"));
		KeyFactory kf = KeyFactory.getInstance("RSA");
		PKCS8EncodedKeySpec ks = new PKCS8EncodedKeySpec(bytes);
		PrivateKey pk = kf.generatePrivate(ks);

		bytes = FileUtils.readFileToByteArray(new File(keyDir + "/public.key"));
		PublicKey publicKey = KeyFactory.getInstance("RSA").generatePublic(
				new X509EncodedKeySpec(bytes));

		KeyPair loadedKeyPair = new KeyPair(publicKey, pk);

		// 2. Construct an instance of AmazonS3EncryptionClient.
		EncryptionMaterials encryptionMaterials = new EncryptionMaterials(
				loadedKeyPair);
	    AWSCredentials credentials = new BasicAWSCredentials("Q3AM3UQ867SPQQA43P2F",
                "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG");
		AmazonS3EncryptionClient encryptionClient = new AmazonS3EncryptionClient(
				credentials,
				new StaticEncryptionMaterialsProvider(encryptionMaterials));
		Region usEast1 = Region.getRegion(Regions.US_EAST_1);
		encryptionClient.setRegion(usEast1);
		encryptionClient.setEndpoint("https://play.minio.io:9000");

		final S3ClientOptions clientOptions = S3ClientOptions.builder().setPathStyleAccess(true).build();
	    encryptionClient.setS3ClientOptions(clientOptions);

		// Create the bucket
		encryptionClient.createBucket(bucketName);
		// 3. Upload the object.
		byte[] plaintext = "Hello World, S3 Client-side Encryption Using Asymmetric Master Key!"
				.getBytes();
		System.out.println("plaintext's length: " + plaintext.length);
		encryptionClient.putObject(new PutObjectRequest(bucketName, objectKey,
				new ByteArrayInputStream(plaintext), new ObjectMetadata()));

		// 4. Download the object.
		S3Object downloadedObject = encryptionClient.getObject(bucketName,
				objectKey);
		byte[] decrypted = IOUtils.toByteArray(downloadedObject
				.getObjectContent());
		Assert.assertTrue(Arrays.equals(plaintext, decrypted));
		System.out.println("decrypted length: " + decrypted.length);
		//deleteBucketAndAllContents(encryptionClient);
	}

	private static void deleteBucketAndAllContents(AmazonS3 client) {
		System.out.println("Deleting S3 bucket: " + bucketName);
		ObjectListing objectListing = client.listObjects(bucketName);

		while (true) {
			for (Iterator<?> iterator = objectListing.getObjectSummaries()
					.iterator(); iterator.hasNext();) {
				S3ObjectSummary objectSummary = (S3ObjectSummary) iterator
						.next();
				client.deleteObject(bucketName, objectSummary.getKey());
			}

			if (objectListing.isTruncated()) {
				objectListing = client.listNextBatchOfObjects(objectListing);
			} else {
				break;
			}
		}
		client.deleteBucket(bucketName);
	}
}
