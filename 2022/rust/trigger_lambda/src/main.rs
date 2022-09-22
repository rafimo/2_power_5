// cerner_2tothe5th_2022
// ensure you have logged into aws cli, this script assumes you have valid creds available at ~/.aws/credentials
// to run execute cargo run

// invokes a lambda function with a given payload
use aws_sdk_lambda::types::Blob;
use aws_sdk_lambda::{Client, Error};

#[tokio::main]
async fn main() -> Result<(), Error> {
    let shared_config = aws_config::load_from_env().await;
    let client = Client::new(&shared_config);

    let invoke_resp = client.invoke()
        .function_name("some-lambda")
        .payload(Blob::new("{\"detail\": { \"id\" : \"some-id\"} }"))
        .send().await?;
    println!("{}", invoke_resp.status_code());
    Ok(())
}
