// Identify long running AWS EMR Clusters
// cerner_2tothe5th_2022
// Run with args <aws-region> <pattern-to-match> <duration-in-mins>
// for example: us-east-1 incremental 120
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.emr.EmrClient;
import software.amazon.awssdk.services.emr.model.*;

import java.time.*;
import java.util.List;

public class ListClusters {
    public static void main(String[] args) {
        EmrClient emrClient = EmrClient.builder().region(Region.of(args[0])).credentialsProvider(ProfileCredentialsProvider.create()).build();
        ListClustersRequest clustersRequest = ListClustersRequest.builder().clusterStates(ClusterState.RUNNING).build();
        List<ClusterSummary> clusters = emrClient.listClusters(clustersRequest).clusters(); // TODO: paginate
        clusters.stream()
                .filter(cluster -> cluster.name().contains(args[1])) // match only clusters with specific name pattern
                .forEach(cluster -> {
                    float duration = (Instant.now().atOffset(ZoneOffset.UTC).toInstant().getEpochSecond() - cluster.status().timeline().creationDateTime().getEpochSecond()) / 60F;
                    if (duration > Float.parseFloat(args[2])) {
                        System.out.println("Id:" + cluster.id() + " Name: " + cluster.name() + " Duration: " + duration);
                    }
                });
        emrClient.close();
    }
}
