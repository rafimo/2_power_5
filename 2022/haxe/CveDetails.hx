// connect to NIST API to fetch CVE details
// cerner_2tothe5th_2022
// run as:
//		haxe --run CveDetails CVE-2022-2097
class CveDetails {
	static function main() {
		
		var http = new haxe.Http('https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=${Sys.args()[0]}');

		// when data is received 
		http.onData = function(data:String) {
            var result = haxe.Json.parse(data);
            var vuln = result.vulnerabilities[0];
            trace('CVE: ${vuln.cve.id}');
            trace('Published: ${vuln.cve.published}');
            trace('Description: ${vuln.cve.descriptions.filter(desc -> desc.lang == 'en')[0].value}'); 
		}

		http.onError = function(error) {
			trace('error: $error');
		}
		// make the request
		http.request();
	}
}
