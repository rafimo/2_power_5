<?php require 'vendor/autoload.php';
// cerner_2tothe5th_2022
// ensure you have logged into aws cli, this script assumes you have valid token in default profile 
// available at ~/.aws/credentials
// install the SDK `composer require aws/aws-sdk-php`

// pass in the region and prefix to query for and the state 'OK|ALARM|INSUFFICIENT_DATA',
// for example:
//      cloudwatch.php us-west-2 staging ALARM
use Aws\CloudWatch\CloudWatchClient; 

function describeAlarms($region, $prefix, $state) {  
    $cloudWatchClient = new CloudWatchClient([ 'profile' => 'default', 'region' => $region, 'version' => '2010-08-01']); 
    echo "finding alarms for region $region - prefix $prefix and state $state\n";
    $result = $cloudWatchClient->describeAlarms(['AlarmNamePrefix' => $prefix, 'StateValue' => $state]);
    $message = '';
    if (isset($result['@metadata']['effectiveUri'])) {
        $message .= 'Alarms at the effective URI of ' . $result['@metadata']['effectiveUri'] . "\n\n";
        $message .= parse($result, 'CompositeAlarms');
        $message .= parse($result, 'MetricAlarms');
    } else {
        $message .= 'No alarms found.';
    } 
    return $message;
}

function parse($result, $type) {
    $message = "$type alarms:\n";
    if (isset($result[$type])) {
        foreach ($result[$type] as $alarm) {
            $message .= $alarm['AlarmName'] . "\n";
        }
    } 
    return $message;
}

// pass in the prefix to query for and the state 'OK|ALARM|INSUFFICIENT_DATA',
// for example us-west-2 staging ALARM
echo describeAlarms($argv[1], $argv[2], $argv[3]); ?>
