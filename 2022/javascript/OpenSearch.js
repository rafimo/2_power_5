// Fetch OpenSearch Domains from AWS and list out the OpenSearch endpoint which can used to index documents
// cerner_2tothe5th_2022
// npm install @aws-sdk/client-opensearch
// Run below, after you have established creds via the AWS CLI
//  node OpenSearch.js
import { OpenSearchClient, ListDomainNamesCommand, DescribeDomainCommand } from "@aws-sdk/client-opensearch";
const client = new OpenSearchClient({ region: "us-west-2" });

const run = async () => {
  try {
    // fetch all OpenSearch Domains
    const data = await client.send(new ListDomainNamesCommand({}));

    for (const domain of data.DomainNames) {
      // describe the domain
      const cluster = await client.send(new DescribeDomainCommand({DomainName: domain.DomainName}));
      console.log(domain.DomainName, cluster.DomainStatus.Endpoints.vpc, cluster.DomainStatus.EngineVersion);
    }
  } catch (err) {
    console.log("Error", err);
  }
};

run();
