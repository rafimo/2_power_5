// describe AWS CF stack and list out the tags and resources
// run below in the project directory
//      dotnet run <name of stack>
// cerner_2tothe5th_2022
using System;
using System.Threading.Tasks;
using Amazon.CloudFormation;
using Amazon.CloudFormation.Model;

namespace CFDescribe {
    class Program {
        static async Task Main(string[] args) {
            var cfnClient = new AmazonCloudFormationClient();  // Create the CloudFormation client
            var request = new DescribeStacksRequest { StackName = args[0] }; // first arg should be the stack-name

            // Get the stack
            DescribeStacksResponse response = await cfnClient.DescribeStacksAsync(request);
            foreach (Stack stack in response.Stacks) {
                Console.WriteLine($"\nStack: {stack.StackName}  Status: {stack.StackStatus.Value} Created: {stack.CreationTime}");

                // Fetch tags
                if (stack.Tags.Count > 0) {
                    Console.WriteLine("  Tags:");
                    foreach (Tag tag in stack.Tags) Console.WriteLine($"    {tag.Key}, {tag.Value}");
                }

                // The resources of each stack
                DescribeStackResourcesResponse resources = await cfnClient.DescribeStackResourcesAsync(new DescribeStackResourcesRequest { StackName = stack.StackName });
                if (resources.StackResources.Count > 0) {
                    Console.WriteLine("  Resources:");
                    foreach (StackResource resource in resources.StackResources)
                        Console.WriteLine($"    {resource.LogicalResourceId}: {resource.PhysicalResourceId} {resource.ResourceStatus}");
                }
            }
        }
    }
}
