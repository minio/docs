Download SDK from https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip

Unzip aws-java-sdk.zip

Replace `samples/AmazonS3/S3Sample.java` file with the following contents:
```
import java.io.File;
import java.io.IOException;

import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.S3ClientOptions;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.ClientConfiguration;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.PutObjectRequest;
import static com.amazonaws.SDKGlobalConfiguration.DISABLE_CERT_CHECKING_SYSTEM_PROPERTY;

public class S3Sample {
    private static String bucketName     = "testbucket";
    private static String keyName        = "hosts";
    private static String uploadFileName = "/etc/hosts";

    public static void main(String[] args) throws IOException {
	AWSCredentials credentials = new BasicAWSCredentials("SXO8VW2OFKKP2OG7AC85",
							     "CKWSSgrUgvfUMTaNBkB63exet4WW+uNhQvi91Bc3");
	ClientConfiguration clientConfiguration = new ClientConfiguration();
	clientConfiguration.setSignerOverride("AWSS3V4SignerType");
	AmazonS3 s3Client = new AmazonS3Client(credentials, clientConfiguration);
	Region usEast1 = Region.getRegion(Regions.US_EAST_1);
	s3Client.setRegion(usEast1);
	s3Client.setEndpoint("http://localhost:9000");
	final S3ClientOptions clientOptions = S3ClientOptions.builder().setPathStyleAccess(true).build();
	s3Client.setS3ClientOptions(clientOptions);

	try {
	    System.out.println("Uploading a new object to S3 from a file\n");
	    File file = new File(uploadFileName);
	    s3Client.putObject(new PutObjectRequest(
						    bucketName, keyName, file
						    ));

	             
	} catch (AmazonServiceException ase) {
	    System.out.println("Caught an AmazonServiceException, which " +
			       "means your request made it " +
			                           "to Amazon S3, but was rejected with an error response" +
			       " for some reason.");
	    System.out.println("Error Message:    " + ase.getMessage());
	    System.out.println("HTTP Status Code: " + ase.getStatusCode());
	    System.out.println("AWS Error Code:   " + ase.getErrorCode());
	    System.out.println("Error Type:       " + ase.getErrorType());
	    System.out.println("Request ID:       " + ase.getRequestId());
	            
	} catch (AmazonClientException ace) {
	    System.out.println("Caught an AmazonClientException, which " +
			       "means the client encountered " +
			                           "an internal error while trying to " +
			                           "communicate with S3, " +
			       "such as not being able to access the network.");
	    System.out.println("Error Message: " + ace.getMessage());
	            
	}
	    
    }
    
}
```

And then run `ant`:

`$ ant`

