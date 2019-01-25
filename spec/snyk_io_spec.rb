# yavdb - The Free and Open Source vulnerability database
# Copyright (C) 2017-present Rodrigo Fernandes
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require_relative 'spec_helper'

require 'yavdb/sources/snyk_io'
require 'yavdb/constants'

RSpec.describe YAVDB::Sources::SnykIO::Client do
  test_urls = [
    'https://snyk.io/vuln/SNYK-JAVA-ORGJBPM-31602',
    'https://snyk.io/vuln/npm:xlsx:20180222',
    'https://snyk.io/vuln/SNYK-PYTHON-SWAUTH-40766',
    'https://snyk.io/vuln/SNYK-RUBY-SORCERY-20425',
    'https://snyk.io/vuln/SNYK-GOLANG-GITHUBCOMBTCSUITEGOSOCKSSOCKS-50055',
    'https://snyk.io/vuln/SNYK-GOLANG-GITHUBCOMSNAPCORESNAPDDAEMON-50060',
    'https://snyk.io/vuln/SNYK-PHP-CONTAOLISTINGBUNDLE-70371',
    'https://snyk.io/vuln/SNYK-DOTNET-MIME-60187'
  ]

  describe 'create' do
    advisories = test_urls.map do |test_url|
      advisory_page = YAVDB::Sources::SnykIO::Client.send(:get_page_html, test_url, false, nil)
      YAVDB::Sources::SnykIO::Client.send(:create, test_url, advisory_page)
    end.flatten

    it 'should have the required properties' do
      expect(advisories).to all(have_attributes(:id => an_instance_of(String)))
      expect(advisories).to all(have_attributes(:title => an_instance_of(String)))
      expect(advisories).to all(have_attributes(:description => an_instance_of(String)))
      expect(advisories).to all(have_attributes(:affected_package => an_instance_of(String)))
      expect(advisories).to all(have_attributes(:vulnerable_versions => an_instance_of(Array)))
      # expect(advisories).to all(have_attributes(:unaffected_versions => an_instance_of(Array)))
      # expect(advisories).to all(have_attributes(:patched_versions => an_instance_of(Array)))
      expect(advisories).to all(have_attributes(:severity => an_instance_of(String)))
      expect(advisories).to all(have_attributes(:package_manager => an_instance_of(String)))
      # expect(advisories).to all(have_attributes(:cve => an_instance_of(Array)))
      # expect(advisories).to all(have_attributes(:cwe => an_instance_of(Array)))
      # expect(advisories).to all(have_attributes(:osvdb => an_instance_of(Array)))
      # expect(advisories).to all(have_attributes(:cvss_v2_vector => an_instance_of(String)))
      # expect(advisories).to all(have_attributes(:cvss_v2_score => an_instance_of(String)))
      # expect(advisories).to all(have_attributes(:cvss_v3_vector => an_instance_of(String)))
      # expect(advisories).to all(have_attributes(:cvss_v3_score => an_instance_of(String)))
      expect(advisories).to all(have_attributes(:disclosed_date => an_instance_of(Date)))
      expect(advisories).to all(have_attributes(:created_date => an_instance_of(Date)))
      expect(advisories).to all(have_attributes(:last_modified_date => an_instance_of(Date)))
      expect(advisories).to all(have_attributes(:credit => an_instance_of(Array)))
      # expect(advisories).to all(have_attributes(:references => an_instance_of(Array)))
      expect(advisories).to all(have_attributes(:source_url => an_instance_of(String)))
    end

    it 'should have valid properties' do
      expect(advisories.all? { |a| YAVDB::Constants::POSSIBLE_PACKAGE_MANAGERS.include?(a[:package_manager]) }).to be_truthy
    end

    it 'should have correct properties for SNYK-JAVA-ORGJBPM-31602' do
      vuln = advisories.select { |v| v.id == 'snykio:maven:org.jbpm:jbpm-designer-client:31602' }.first
      expect(vuln).to have_attributes(:title => 'Cross-site Scripting (XSS)')
      expect(vuln).to have_attributes(:description => "Affected versions of [`org.jbpm:jbpm-designer-client`][1] are vulnerable\nto Cross-site Scripting (XSS).\n\n\n\n[1]: https://jbpm.org\n\\nCross-Site Scripting (XSS) attacks occur when an attacker tricks a\nuser’s browser to execute malicious JavaScript code in the context of a\nvictim’s domain. Such scripts can steal the user’s session cookies for\nthe domain, scrape or modify its content, and perform or modify actions\non the user’s behalf, actions typically blocked by the browser’s Same\nOrigin Policy.\n\nThese attacks are possible by escaping the context of the web\napplication and injecting malicious scripts in an otherwise trusted\nwebsite. These scripts can introduce additional attributes (say, a\n\\\"new\\\" option in a dropdown list or a new link to a malicious site) and\ncan potentially execute code on the clients side, unbeknown to the\nvictim. This occurs when characters like `<` `>` `\"` `'` are not escaped\nproperly.\n\nThere are a few types of XSS:\n\n* **Persistent XSS** is an attack in which the malicious code persists\n  into the web app’s database.\n* **Reflected XSS** is an which the website echoes back a portion of the\n  request. The attacker needs to trick the user into clicking a\n  malicious link (for instance through a phishing email or malicious JS\n  on another page), which triggers the XSS attack.\n* **DOM-based XSS** is an that occurs purely in the browser when\n  client-side JavaScript echoes back a portion of the URL onto the page.\n  DOM-Based XSS is notoriously hard to detect, as the server never gets\n  a chance to see the attack taking place.\n\n")
      expect(vuln).to have_attributes(:affected_package => 'org.jbpm:jbpm-designer-client')
      expect(vuln).to have_attributes(:vulnerable_versions => ['[,6.3.3)'])
      expect(vuln).to have_attributes(:severity => 'medium')
      expect(vuln).to have_attributes(:package_manager => 'maven')
      expect(vuln).to have_attributes(:cve => ['CVE-2016-5398'])
      expect(vuln).to have_attributes(:cwe => ['CWE-79'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2016-07-19'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2017-12-07'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2017-12-07'))
      expect(vuln).to have_attributes(:credit => ['Jeremy Choi'])
      expect(vuln).to have_attributes(:references => ['https://nvd.nist.gov/vuln/detail/CVE-2016-5398', 'https://bugzilla.redhat.com/show_bug.cgi?id=1358523'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-JAVA-ORGJBPM-31602')
    end

    it 'should have correct properties for npm:xlsx:20180222' do
      vuln = advisories.select { |v| v.id == 'snykio:npm:xlsx:20180222' }.first
      expect(vuln).to have_attributes(:title => 'Regular Expression Denial of Service (ReDoS)')
      expect(vuln).to have_attributes(:description => "[`xlsx`][1] is a parser and writer for various spreadsheet formats.\n\nAffected versions of this package are vulnerable to Regular Expression\nDenial of Service (ReDoS) attacks. This can cause an impact of about 10\nseconds matching time for data 40k characters long.\n\n\n\n[1]: https://www.npmjs.com/package/xlsx\n\\nDenial of Service (DoS) describes a family of attacks, all aimed at\nmaking a system inaccessible to its original and legitimate users. There\nare many types of DoS attacks, ranging from trying to clog the network\npipes to the system by generating a large volume of traffic from many\nmachines (a Distributed Denial of Service - DDoS - attack) to sending\ncrafted requests that cause a system to crash or take a disproportional\namount of time to process.\n\nThe Regular expression Denial of Service (ReDoS) is a type of Denial of\nService attack. Regular expressions are incredibly powerful, but they\naren\\'t very intuitive and can ultimately end up making it easy for\nattackers to take your site down.\n\nLet’s take the following regular expression as an example:\n\n    regex = /A(B|C+)+D/\n\nThis regular expression accomplishes the following:\n\n* `A` The string must start with the letter \\'A\\'\n* `(B|C+)+` The string must then follow the letter A with either the\n  letter \\'B\\' or some number of occurrences of the letter \\'C\\' (the\n  `+` matches one or more times). The `+` at the end of this section\n  states that we can look for one or more matches of this section.\n* `D` Finally, we ensure this section of the string ends with a \\'D\\'\n\nThe expression would match inputs such as `ABBD`, `ABCCCCD`, `ABCBCCCD`\nand `ACCCCCD`\n\nIt most cases, it doesn\\'t take very long for a regex engine to find a\nmatch:\n\n    $ time node -e '/A(B|C+)+D/.test(\"ACCCCCCCCCCCCCCCCCCCCCCCCCCCCD\")'\n    0.04s user 0.01s system 95% cpu 0.052 total\n    \n    $ time node -e '/A(B|C+)+D/.test(\"ACCCCCCCCCCCCCCCCCCCCCCCCCCCCX\")'\n    1.79s user 0.02s system 99% cpu 1.812 total\n\nThe entire process of testing it against a 30 characters long string\ntakes around ~52ms. But when given an invalid string, it takes nearly\ntwo seconds to complete the test, over ten times as long as it took to\ntest a valid string. The dramatic difference is due to the way regular\nexpressions get evaluated.\n\nMost Regex engines will work very similarly (with minor differences).\nThe engine will match the first possible way to accept the current\ncharacter and proceed to the next one. If it then fails to match the\nnext one, it will backtrack and see if there was another way to digest\nthe previous character. If it goes too far down the rabbit hole only to\nfind out the string doesn’t match in the end, and if many characters\nhave multiple valid regex paths, the number of backtracking steps can\nbecome very large, resulting in what is known as *catastrophic\nbacktracking*.\n\nLet\\'s look at how our expression runs into this problem, using a\nshorter string: \\\"ACCCX\\\". While it seems fairly straightforward, there\nare still four different ways that the engine could match those three\nC\\'s:\n\n1.  CCC\n2.  CC+C\n3.  C+CC\n4.  C+C+C.\n\nThe engine has to try each of those combinations to see if any of them\npotentially match against the expression. When you combine that with the\nother steps the engine must take, we can use [RegEx 101 debugger][1] to\nsee the engine has to take a total of 38 steps before it can determine\nthe string doesn\\'t match.\n\nFrom there, the number of steps the engine must use to validate a string\njust continues to grow.\n\n| String | Number of C\\'s | Number of steps |\n|----------\n| ACCCX | 3 | 38 |\n| ACCCCX | 4 | 71 |\n| ACCCCCX | 5 | 136 |\n| ACCCCCCCCCCCCCCX | 14 | 65,553 |\n\nBy the time the string includes 14 C\\'s, the engine has to take over\n65,000 steps just to see if the string is valid. These extreme\nsituations can cause them to work very slowly (exponentially related to\ninput size, as shown above), allowing an attacker to exploit this and\ncan cause the service to excessively consume CPU, resulting in a Denial\nof Service.\n\n\n\n[1]: https://regex101.com/debugger\n")
      expect(vuln).to have_attributes(:affected_package => 'xlsx')
      expect(vuln).to have_attributes(:vulnerable_versions => ['<0.12.2'])
      expect(vuln).to have_attributes(:severity => 'low')
      expect(vuln).to have_attributes(:package_manager => 'npm')
      expect(vuln).to have_attributes(:cve => nil)
      expect(vuln).to have_attributes(:cwe => match_array(['CWE-185', 'CWE-400']))
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2018-02-21'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2018-02-22'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2018-02-22'))
      expect(vuln).to have_attributes(:credit => ['Jamie Davis'])
      expect(vuln).to have_attributes(:references => ['https://github.com/SheetJS/js-xlsx/commit/88e9e31ebf067c40b58c84dc1a7a842750c379ba'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/npm:xlsx:20180222')
    end

    it 'should have correct properties for SNYK-PYTHON-SWAUTH-40766' do
      vuln = advisories.select { |v| v.id == 'snykio:pypi:swauth:40766' }.first
      expect(vuln).to have_attributes(:title => 'Access Restriction Bypass')
      expect(vuln).to have_attributes(:description => "[`swauth`][1] is An alternative authentication system for Swift.\n\nAffected versions of the package are vulnerable to Access Restriction\nBypass. An issue was discovered in middleware.py in OpenStack Swauth\nthrough 1.2.0 when used with OpenStack Swift through 2.15.1. The Swift\nobject store and proxy server are saving (unhashed) tokens retrieved\nfrom the Swauth middleware authentication mechanism to a log file as\npart of a GET URI. This allows attackers to bypass authentication by\ninserting a token into an X-Auth-Token header of a new request.\n\n\n\n[1]: http://pypi.python.org/pypi/swauth\n")
      expect(vuln).to have_attributes(:affected_package => 'swauth')
      expect(vuln).to have_attributes(:vulnerable_versions => ['[,1.3.0)'])
      expect(vuln).to have_attributes(:severity => 'high')
      expect(vuln).to have_attributes(:package_manager => 'pypi')
      expect(vuln).to have_attributes(:cve => ['CVE-2017-16613'])
      expect(vuln).to have_attributes(:cwe => ['CWE-287'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2017-11-20'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2017-12-07'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2017-12-07'))
      expect(vuln).to have_attributes(:credit => ['Unknown'])
      expect(vuln).to have_attributes(:references => ['https://nvd.nist.gov/vuln/detail/CVE-2017-16613', 'https://github.com/openstack/swauth/commit/70af7986265a3defea054c46efc82d0698917298'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-PYTHON-SWAUTH-40766')
    end

    it 'should have correct properties for SNYK-RUBY-SORCERY-20425' do
      vuln = advisories.select { |v| v.id == 'snykio:rubygems:sorcery:20425' }.first
      expect(vuln).to have_attributes(:title => 'Authorization Bypass')
      expect(vuln).to have_attributes(:description => "[`sorcery`][1] Provides common authentication needs such as signing\nin/out, activating by email and resetting password.\n\nAffected versions of the package are vulnerable to Authorization Bypass.\nThe `state` field was kept between requests.\n\n\n\n[1]: https://rubygems.org/gems/sorcery\n")
      expect(vuln).to have_attributes(:affected_package => 'sorcery')
      expect(vuln).to have_attributes(:vulnerable_versions => ['<0.9.1  >=0.8.3'])
      expect(vuln).to have_attributes(:severity => 'low')
      expect(vuln).to have_attributes(:package_manager => 'rubygems')
      expect(vuln).to have_attributes(:cve => nil)
      expect(vuln).to have_attributes(:cwe => ['CWE-639'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2015-04-04'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2017-12-07'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2017-12-07'))
      expect(vuln).to have_attributes(:credit => ['Grzegorz Witek'])
      expect(vuln).to have_attributes(:references => ['https://github.com/NoamB/sorcery/commit/457f89d10ed5efc0c3dccea0dd78587bfd5bf211'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-RUBY-SORCERY-20425')
    end

    it 'should have correct properties for SNYK-GOLANG-GITHUBCOMBTCSUITEGOSOCKSSOCKS-50055' do
      vuln = advisories.select { |v| v.id == 'snykio:go:github.com/btcsuite/go-socks/socks:50055' }.first
      expect(vuln).to have_attributes(:title => 'Denial of Service (DoS)')
      expect(vuln).to have_attributes(:description => "[`github.com/btcsuite/go-socks/socks`][1] is a SOCKS5 proxy library for\nGo.\n\nAffected versions of this package are vulnerable to Denial of Service\n(DoS). An attacker can exploit this vulnerability to trigger an infinite\nloop, causing the system to stop responding\n\n\n\n[1]: https://github.com/btcsuite/go-socks\n\\nDenial of Service (DoS) describes a family of attacks, all aimed at\nmaking a system inaccessible to its intended and legitimate users.\n\nUnlike other vulnerabilities, DoS attacks usually do not aim at\nbreaching security. Rather, they are focused on making websites and\nservices unavailable to genuine users resulting in downtime.\n\nOne popular Denial of Service vulnerability is DDoS (a Distributed\nDenial of Service), an attack that attempts to clog network pipes to the\nsystem by generating a large volume of traffic from many machines.\n\nWhen it comes to open source libraries, DoS vulnerabilities allow\nattackers to trigger such a crash or crippling of the service by using a\nflaw either in the application code or from the use of open source\nlibraries.\n\nTwo common types of DoS vulnerabilities:\n\n* High CPU/Memory Consumption- An attacker sending crafted requests that\n  could cause the system to take a disproportionate amount of time to\n  process. For example,\n  [commons-fileupload:commons-fileupload](SNYK-JAVA-COMMONSFILEUPLOAD-30082).\n\n* Crash - An attacker sending crafted requests that could cause the\n  system to crash. For Example, [npm `ws` package](npm:ws:20171108)\n\n")
      expect(vuln).to have_attributes(:affected_package => 'github.com/btcsuite/go-socks/socks')
      expect(vuln).to have_attributes(:vulnerable_versions => ['*'])
      expect(vuln).to have_attributes(:severity => 'low')
      expect(vuln).to have_attributes(:package_manager => 'go')
      expect(vuln).to have_attributes(:cve => nil)
      expect(vuln).to have_attributes(:cwe => ['CWE-400'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2013-08-07'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2017-10-30'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2017-10-30'))
      expect(vuln).to have_attributes(:credit => ['David Hill'])
      expect(vuln).to have_attributes(:references => ['https://github.com/btcsuite/go-socks/commit/233bccbb1abe02f05750f7ace66f5bffdb13defc'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-GOLANG-GITHUBCOMBTCSUITEGOSOCKSSOCKS-50055')
    end

    it 'should have correct properties for SNYK-GOLANG-GITHUBCOMSNAPCORESNAPDDAEMON-50060' do
      vuln = advisories.select { |v| v.id == 'snykio:go:github.com/snapcore/snapd/daemon:50060' }.first
      expect(vuln).to have_attributes(:title => 'Authentication Bypass')
      expect(vuln).to have_attributes(:description => "Affected versions of [`github.com/snapcore/snapd/daemon`][1] are\nvulnerable to Authentication Bypass. The `snap logs` command could be\nmade to call journalctl without match arguments and therefore allow\nunprivileged, unauthenticated users to bypass systemd-journald\\'s access\nrestrictions.\n\n\n\n[1]: https://github.com/snapcore/snapd\n")
      expect(vuln).to have_attributes(:affected_package => 'github.com/snapcore/snapd/daemon')
      expect(vuln).to have_attributes(:vulnerable_versions => ['>=2.27 <2.29.3'])
      expect(vuln).to have_attributes(:severity => 'high')
      expect(vuln).to have_attributes(:package_manager => 'go')
      expect(vuln).to have_attributes(:cve => ['CVE-2017-14178'])
      expect(vuln).to have_attributes(:cwe => ['CWE-288'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2017-08-02'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2018-02-14'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2018-02-14'))
      expect(vuln).to have_attributes(:credit => ['John Lenton'])
      expect(vuln).to have_attributes(:references => ['https://github.com/snapcore/snapd/pull/4194', 'https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1730255', 'https://github.com/snapcore/snapd/commit/6219ca26484557c52cc05afcac7443b963b26d8c'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-GOLANG-GITHUBCOMSNAPCORESNAPDDAEMON-50060')
    end

    it 'should have correct properties for SNYK-PHP-CONTAOLISTINGBUNDLE-70371' do
      vuln = advisories.select { |v| v.id == 'snykio:packagist:contao/listing-bundle:70371' }.first
      expect(vuln).to have_attributes(:title => 'SQL Injection')
      expect(vuln).to have_attributes(:description => "Affected versions of [`contao/listing-bundle`][1] are vulnerable to SQL\nInjection\n\nBoth the search filter in the back end and the \\\"listing\\\" module in the\nfront end are vulnerable. To exploit the vulnerability in the back end,\na back end user has to be logged in, whereas the front end vulnerability\ncan be exploited by anyone.\n\n\n\n[1]: https://packagist.org/packages/contao/listing-bundle\n")
      expect(vuln).to have_attributes(:affected_package => 'contao/listing-bundle')
      expect(vuln).to have_attributes(:vulnerable_versions => ['>=3  <3.5.30 || >=4  <4.4.8'])
      expect(vuln).to have_attributes(:severity => 'medium')
      expect(vuln).to have_attributes(:package_manager => 'packagist')
      expect(vuln).to have_attributes(:cve => ['CVE-2017-16558'])
      expect(vuln).to have_attributes(:cwe => ['CWE-89'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2017-11-15'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2017-12-04'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2017-12-04'))
      expect(vuln).to have_attributes(:credit => ['Unknown'])
      expect(vuln).to have_attributes(:references => ['https://contao.org/en/news/contao-4_4_8.html'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-PHP-CONTAOLISTINGBUNDLE-70371')
    end

    it 'should have correct properties for SNYK-DOTNET-MIME-60187' do
      vuln = advisories.select { |v| v.id == 'snykio:nuget:mime:60187' }.first
      expect(vuln).to have_attributes(:title => 'Regular Expression Denial of Service (ReDoS)')
      expect(vuln).to have_attributes(:description => "[`mime`][1] is a comprehensive, compact MIME type module.\n\nAffected versions of this package are vulnerable to Regular expression\nDenial of Service (ReDoS). It uses regex the following regex\n`/.*[\\.\\/\\\\]/` in its lookup, which can cause a slowdown of 2 seconds\nfor 50k characters.\n\n\n\n[1]: https://www.npmjs.com/package/mime\n\\nDenial of Service (DoS) describes a family of attacks, all aimed at\nmaking a system inaccessible to its original and legitimate users. There\nare many types of DoS attacks, ranging from trying to clog the network\npipes to the system by generating a large volume of traffic from many\nmachines (a Distributed Denial of Service - DDoS - attack) to sending\ncrafted requests that cause a system to crash or take a disproportional\namount of time to process.\n\nThe Regular expression Denial of Service (ReDoS) is a type of Denial of\nService attack. Regular expressions are incredibly powerful, but they\naren\\'t very intuitive and can ultimately end up making it easy for\nattackers to take your site down.\n\nLet’s take the following regular expression as an example:\n\n    regex = /A(B|C+)+D/\n\nThis regular expression accomplishes the following:\n\n* `A` The string must start with the letter \\'A\\'\n* `(B|C+)+` The string must then follow the letter A with either the\n  letter \\'B\\' or some number of occurrences of the letter \\'C\\' (the\n  `+` matches one or more times). The `+` at the end of this section\n  states that we can look for one or more matches of this section.\n* `D` Finally, we ensure this section of the string ends with a \\'D\\'\n\nThe expression would match inputs such as `ABBD`, `ABCCCCD`, `ABCBCCCD`\nand `ACCCCCD`\n\nIt most cases, it doesn\\'t take very long for a regex engine to find a\nmatch:\n\n    $ time node -e '/A(B|C+)+D/.test(\"ACCCCCCCCCCCCCCCCCCCCCCCCCCCCD\")'\n    0.04s user 0.01s system 95% cpu 0.052 total\n    \n    $ time node -e '/A(B|C+)+D/.test(\"ACCCCCCCCCCCCCCCCCCCCCCCCCCCCX\")'\n    1.79s user 0.02s system 99% cpu 1.812 total\n\nThe entire process of testing it against a 30 characters long string\ntakes around ~52ms. But when given an invalid string, it takes nearly\ntwo seconds to complete the test, over ten times as long as it took to\ntest a valid string. The dramatic difference is due to the way regular\nexpressions get evaluated.\n\nMost Regex engines will work very similarly (with minor differences).\nThe engine will match the first possible way to accept the current\ncharacter and proceed to the next one. If it then fails to match the\nnext one, it will backtrack and see if there was another way to digest\nthe previous character. If it goes too far down the rabbit hole only to\nfind out the string doesn’t match in the end, and if many characters\nhave multiple valid regex paths, the number of backtracking steps can\nbecome very large, resulting in what is known as *catastrophic\nbacktracking*.\n\nLet\\'s look at how our expression runs into this problem, using a\nshorter string: \\\"ACCCX\\\". While it seems fairly straightforward, there\nare still four different ways that the engine could match those three\nC\\'s:\n\n1.  CCC\n2.  CC+C\n3.  C+CC\n4.  C+C+C.\n\nThe engine has to try each of those combinations to see if any of them\npotentially match against the expression. When you combine that with the\nother steps the engine must take, we can use [RegEx 101 debugger][1] to\nsee the engine has to take a total of 38 steps before it can determine\nthe string doesn\\'t match.\n\nFrom there, the number of steps the engine must use to validate a string\njust continues to grow.\n\n| String | Number of C\\'s | Number of steps |\n|----------\n| ACCCX | 3 | 38 |\n| ACCCCX | 4 | 71 |\n| ACCCCCX | 5 | 136 |\n| ACCCCCCCCCCCCCCX | 14 | 65,553 |\n\nBy the time the string includes 14 C\\'s, the engine has to take over\n65,000 steps just to see if the string is valid. These extreme\nsituations can cause them to work very slowly (exponentially related to\ninput size, as shown above), allowing an attacker to exploit this and\ncan cause the service to excessively consume CPU, resulting in a Denial\nof Service.\n\n\n\n[1]: https://regex101.com/debugger\n")
      expect(vuln).to have_attributes(:affected_package => 'mime')
      expect(vuln).to have_attributes(:vulnerable_versions => ['[,1.4.1), [2,2.0.3)'])
      expect(vuln).to have_attributes(:severity => 'low')
      expect(vuln).to have_attributes(:package_manager => 'nuget')
      expect(vuln).to have_attributes(:cve => nil)
      expect(vuln).to have_attributes(:cwe => ['CWE-400'])
      expect(vuln).to have_attributes(:disclosed_date => Date.parse('2017-09-26'))
      expect(vuln).to have_attributes(:created_date => Date.parse('2017-09-26'))
      expect(vuln).to have_attributes(:last_modified_date => Date.parse('2017-09-26'))
      expect(vuln).to have_attributes(:credit => ['CristianAlexandru Staicu'])
      expect(vuln).to have_attributes(:references => ['https://github.com/broofa/node-mime/issues/167', 'https://github.com/broofa/node-mime/commit/855d0c4b8b22e4a80b9401a81f2872058eae274d', 'https://github.com/broofa/node-mime/commit/1df903fdeb9ae7eaa048795b8d580ce2c98f40b0'])
      expect(vuln).to have_attributes(:source_url => 'https://snyk.io/vuln/SNYK-DOTNET-MIME-60187')
    end
  end
end
