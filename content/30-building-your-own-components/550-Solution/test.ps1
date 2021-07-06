#Install Pester
$ErrorActionPreference = 'stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name Pester -Force -Scope CurrentUser -SkipPublisherCheck -AllowClobber

#Run validation tests with ExitCode
Import-Module Pester
$PesterPreference = [PesterConfiguration]::Default
$PesterPreference.TestResult.Enabled = $true
$PesterPreference.Output.Verbosity = 'detailed'
$PesterPreference.Run.Exit = $true

Describe "IIS validation test" {
    BeforeAll {
        $httpResponse = Invoke-WebRequest localhost
    }
    It "HTTP Headers should have key: server, value: Microsoft-IIS" {
        $httpResponse.Headers['server'] | Should -Match 'Microsoft-IIS'
    }
    It "IIS should return HTTP 200 OK" {
        $httpResponse.StatusDescription | Should -BeExactly 'OK'
        $httpResponse.StatusCode | Should -BeExactly 200
    }
    It "IIS should return unicorn.png image" {
        $httpResponse.Images.src | Should -Match 'unicorn'
    }
}